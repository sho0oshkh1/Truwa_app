import SwiftUI
import AVFoundation

class SoundManager: ObservableObject {
static let instance = SoundManager()

var player: AVAudioPlayer?
@Published var currentTime: Double = 0

enum SoundOption: String {
case badum
case sound1
}

func playSound(sound: SoundOption) {
guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else { return }
do {
player = try AVAudioPlayer(contentsOf: url)
player?.play()

// Update currentTime periodically
Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
guard let self = self else { return }
self.currentTime = self.player?.currentTime ?? 0
}

} catch let error {
print("Error playing sound. \(error.localizedDescription)")
}
}

func stopAudio() {
player?.pause()
}

func goBackward() {
player?.currentTime -= 10
}

func goForward() {
player?.currentTime += 10
}

func totalTime() -> Double {
let totalTime = player?.duration ?? 0
return totalTime
}
}

struct AudioPlay1: View {
@StateObject private var SoundManager1 = SoundManager.instance
@State private var isPlaying = false
    @State private var isShowingSheet = false
var body: some View {
ZStack{
Color("1")
.ignoresSafeArea()

VStack {
Text("اسم المحتوى")
.font(.custom("Al Bayan", size: 24))
.offset(x: 0, y: -100)

ZStack {
    RoundedRectangle(cornerRadius: 20)
        .foregroundColor(Color("6")).frame(width: 353,height: 380)
        .opacity(0.3)
    Image("lotus")
        .resizable()
        .frame(width: 352.36, height: 233.9)

    HStack {
        Image("music")
            .resizable()
            .frame(width: 79, height: 79)
            .offset(x: -90, y: -170)

        Image("music")
            .resizable()
            .frame(width: 79, height: 79)
            .offset(x: 80, y: -170)
    }

Image(systemName: isPlaying ? "pause.fill" : "play.fill")
.resizable()
.frame(width: 28, height: 36)
.foregroundColor(.black)
.onTapGesture {
isPlaying.toggle()
if isPlaying {
SoundManager1.playSound(sound: .sound1)
} else {
SoundManager1.stopAudio()
}
}
HStack(spacing: 200) {
Button(action: {
SoundManager1.goBackward()
}) {
Image(systemName: "gobackward.10")
.resizable()
.aspectRatio(contentMode: .fit).accentColor(.black)
.frame(width: 30, height: 30)
}

Button(action: {
SoundManager1.goForward()
}) {
Image(systemName: "goforward.10")
.resizable()
.aspectRatio(contentMode: .fit).accentColor(.black)
.frame(width: 30, height: 30)
}
}
.offset(x: 0, y: 0)

VStack(spacing: 20) {
Slider(value: $SoundManager1.currentTime, in: 0...SoundManager1.totalTime())
.accentColor(.black)

HStack(spacing: 220) {
Text(formatTimeInterval(SoundManager1.currentTime))
Text(formatTimeInterval(SoundManager1.totalTime()))
}
}
.offset(x: 0, y: 10)
.offset(x: 0, y: 130)

    VStack{
        Button(action: {
        }, label: {
            Image(systemName: "heart.fill").resizable().frame(width: 30,height:28)
                .foregroundColor(Color("3"))
                //.foregroundColor(.black)
        })
    }
    .offset(x:0,y:160)
}
.padding()
    
    ZStack {
                     RoundedRectangle(cornerRadius: 10)
                         .foregroundColor(Color("2"))
                         .frame(width: 295, height: 45)
                         .shadow(radius: 1)
                     
                     Button(action: {
                         isShowingSheet = true
                     }) {
                         Text("شارك مع الأصدقاء")
                             .background(Color("2"))
                             .foregroundColor(.black)
                             .frame(width: 295.0, height: 45.0)
                     }
                 }
                 .sheet(isPresented: $isShowingSheet) {
                     share()
                 }//end of ZStack
                 .padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
    // .offset(x: 50, y: 270)
}
}
.onAppear {
SoundManager.instance.playSound(sound: .sound1)
}
.onDisappear {
SoundManager.instance.stopAudio()
}
}

func formatTimeInterval(_ timeInterval: Double) -> String {
let formatter = DateComponentsFormatter()
formatter.unitsStyle = .positional
formatter.allowedUnits = [.minute, .second]
formatter.zeroFormattingBehavior = .pad
return formatter.string(from: timeInterval) ?? "00:00"
}
}

struct AudioPlay1_Previews: PreviewProvider {
static var previews: some View {
AudioPlay1()
}
}




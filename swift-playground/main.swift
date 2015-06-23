import Foundation

class Album {
    var name: String
    var artist: String
    init(name: String, artist: String) {
        self.name = name;
        self.artist = artist;
    }
}

extension Album: CustomDebugStringConvertible {
    internal var debugDescription: String {
        return "[\(artist): \(name)]"
    }
}

extension Album: CustomStringConvertible {
    var description: String {
        return "\(artist) - \(name)"
    }
}

var albums = [
    Album(name: "A Thousand Suns", artist: "Linkin Park"),
    Album(name: "Hybrid Theory", artist: "Linkin Park"),
    Album(name: "V", artist: "Maroon 5"),
    Album(name: "Hands All Over", artist: "Maroon 5"),
    Album(name: "Songs About Janes", artist: "Maroon 5"),
    Album(name: "My Everything", artist: "Ariana Grande"),
    Album(name: "Yours Truly", artist: "Ariana Grande"),
    Album(name: "Ocean Eyes", artist: "Owl City"),
    Album(name: "Maybe I'm Dreaming", artist: "Owl City"),
    Album(name: "Of June", artist: "Owl City"),
    Album(name: "The Hunting Party", artist: "Linkin Park")
]

func getAlbumsOfArtist(list: [Album], artist: String) -> [Album] {
    return albums.filter { album in
        return album.artist == artist
    }
}

func searchAlbumOfArtist(list: [Album], artist: String) -> [Album] {
    return albums.filter { album in
        return album.artist.hasPrefix(artist)
    }
}


func dumpJSON(list: [Album]) -> JSON {
    let arr = albums.map { album in
        return [
            "artist": album.artist,
            "name": album.name
        ]
    }
    return JSON(arr);
}

let owlCity = getAlbumsOfArtist(albums, artist: "Owl City")
print(owlCity);

let ariana = searchAlbumOfArtist(albums, artist: "Ariana")
print(ariana)
print(dumpJSON(albums))

let a = "Héllo, 🇺🇸laygr😮und!"
print(a.characters.count)
print(a.utf16.count)
print(a.utf8.count)
print(a.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))

var i = 10;

repeat {
    print("Hello")
    i -= 1 // -- i , i -- both not working?
} while( i > 0)

i = 10;

while( i > 0) {
    print("World")
    i -= 1
}

for(var j = 0; j < 10; j++) {
    print("Swift")
}
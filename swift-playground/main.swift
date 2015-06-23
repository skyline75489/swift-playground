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
    Album(name: "Songs About Janes", artist: "Maroon 5"),
    Album(name: "My Everything", artist: "Ariana Grande"),
    Album(name: "Yours Truly", artist: "Ariana Grande"),
    Album(name: "Ocean Eyes", artist: "Owl City"),
    Album(name: "Maybe I'm Dreaming", artist: "Owl City")
]

func getAlbumsOfArtist(list: [Album], artist: String) -> [Album] {
    return albums.filter { album in
        return album.artist == artist
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

let owlCity = getAlbumsOfArtist(albums, artist: "Linkin Park")
print(owlCity);
print(dumpJSON(albums))
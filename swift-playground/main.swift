import Foundation


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

print(dumpJSON(albums))

if let r = Requests.post("http://localhost:5000/folders", payload: ["query": "info"]) {
    print(JSON(data: r))
}
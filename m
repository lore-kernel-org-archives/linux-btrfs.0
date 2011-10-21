From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: snapshots changed behavior
Date: Fri, 21 Oct 2011 19:53:38 +0200
Message-ID: <38803013.ZrEk6jGlKT@venice>
References: <4EA19E66.2020102@webstarts.com>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: Jim <jim@webstarts.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EA19E66.2020102@webstarts.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, 21 October, 2011 12:31:34 Jim wrote:
> Good afternoon btrfs list,

Hi Jim

> about a month ago, when testing btrfs, I could create a snapshot with
> btrfs snap create and be able to drill down in the snapshot to find
> subvols and files below the snapshot level.  I currently need to use
> btrfsctl -s to create snapshots and can no longer drill down through
> subvols in them.  An example would be a file tree of /btrfs (subvol)
> /data (subvol) /sites (subvol) /0000 (directory) /files-in-dir.  If I
> snapshot /btrfs/data I can open data and see /sites but can see nothing
> below /sites.  However, if I snap /btrfs/data/sites I can drill down
> through all lower directories and files.  In my past tests I was able to
> drill all the way down from the /btrfs/data snap.  

I am quite sure that the snapshot is NOT recursive. If a subvolume contains 
another subvolume, and you snapshot the former, the new subvolume shall not 
contain the "child" subvolume.

>From what you report, it seems that /sites was a directory and not a snapshot.

Pay attention that btrfsctl -s allow to take as source a directory. In this 
case this program snapshot the subvolume which contains the subdirectory 
passed as argument. 
Instead the btrfs tool checked if the source is a subvolume. If not it raises 
an error.

I say so because the btrfctl behaviour confused a lot of people.

In any case btrfs was never been capable to snapshot a directory.

> Also, in the past, a
> snap was definitely a sparse file and was able to easily be moved, moved
> back, remounted and used.  Currently, the useful file /btrfs/data/sites
> contains 5GB of data and both shows and moves as 5GB of data, not like a
> sparse file.  Am I misusing the filesystem, or improperly using the
> commands?  Or have changes been made to the functionality which I
> missed?  

It is not allowed to move files between subvolume. The mv command in this case 
copies the files and removes the original ones.

>From what you wrote it seems that (for mistake) you thought that a directory 
was a subvolume.

> Sorry to take your time on such a simple matter, but I need to
> understand how to best use the filesystem.  Thanks very much for your
> advice.
> Jim Maloney
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

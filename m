From: Jim <jim@webstarts.com>
Subject: snapshots changed behavior
Date: Fri, 21 Oct 2011 12:31:34 -0400
Message-ID: <4EA19E66.2020102@webstarts.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Good afternoon btrfs list,
about a month ago, when testing btrfs, I could create a snapshot with 
btrfs snap create and be able to drill down in the snapshot to find 
subvols and files below the snapshot level.  I currently need to use 
btrfsctl -s to create snapshots and can no longer drill down through 
subvols in them.  An example would be a file tree of /btrfs (subvol)
/data (subvol) /sites (subvol) /0000 (directory) /files-in-dir.  If I 
snapshot /btrfs/data I can open data and see /sites but can see nothing 
below /sites.  However, if I snap /btrfs/data/sites I can drill down 
through all lower directories and files.  In my past tests I was able to 
drill all the way down from the /btrfs/data snap.  Also, in the past, a 
snap was definitely a sparse file and was able to easily be moved, moved 
back, remounted and used.  Currently, the useful file /btrfs/data/sites 
contains 5GB of data and both shows and moves as 5GB of data, not like a 
sparse file.  Am I misusing the filesystem, or improperly using the 
commands?  Or have changes been made to the functionality which I 
missed?  Sorry to take your time on such a simple matter, but I need to 
understand how to best use the filesystem.  Thanks very much for your 
advice.
Jim Maloney

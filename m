From: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Subject: btrfsctl -s returns 1
Date: Tue, 12 Jan 2010 20:08:51 +0100
Message-ID: <20100112200851.4c44b75b@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I wrote a script generating snapshots of several subvolumes. But the script
failed after taking the first snapshot.

I then did it by hand:

> btrfsctl -s /.backups/2010-01-12.1/home /home
operation complete
Btrfs v0.19-4-gab8fb4c
> echo $?
1

Usually commands return 0 if everything went ok (and it seems that the snapshot
was taken correctly).

Has the returned "1" some special meaning?

------

Another, minor issue:

Mayby my manual is out of date. It tells me

> man btrfsctl
...
       -s snapshot-name directory
              Creates a new snapshot of the directory specified.
...

but as I learned one can only take a snapshot of a subvolume.

Greetings, Michael

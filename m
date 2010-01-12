From: Tomas Carnecky <tomas.carnecky@gmail.com>
Subject: Script for easier handling of subvolumes/snapshots
Date: Tue, 12 Jan 2010 02:12:08 +0100
Message-ID: <4B4BCC68.4060006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I just wrote this litte scrip to help me create/list/restore/destroy 
subvolumes and snapshots. It is a really simple bash script that uses 
the btrfsctl commandline utility. Here is a transcript of a short session:

$ ./bsu.sh create /pool/subvol
$ echo 1 > /pool/subvol/file
$ sync
$ ./bsu.sh create /pool/subvol@snapshot
$ echo 2 > /pool/subvol/file
$ sync
$ ./bsu.sh create /pool/subvol@snapshot2
$ ./bsu.sh list /pool/subvol
    snapshot
    snapshot2
$ ./bsu.sh restore /pool/subvol@snapshot
$ cat /pool/subvol/file
1
$ ./bsu.sh list /pool/subvol
    snapshot
    snapshot2
$ ./bsu.sh destroy /pool/subvol@snapshot
$ ./bsu.sh destroy /pool/subvol@snapshot2
$ ./bsu.sh destroy /pool/subvol

How it works: subvolumes are created as usual, snapshots are created in 
a separate subvolume which is saved as .btrfs in the original subvolume. 
Because the snapshots are kept separate, reverting to an earlier 
snapshot doesn't destroy newer snapshots.

The script can create nested subvolumes and snapshots of those, but 
unfortunately snapshots don't preserve subvolumes which are contained 
within the original filesystem:

/pool/foo # <- subvol
/pool/foo/bar # <- subvol
btrfsctl -s copy /pool/foo
# /pool/copy/bar is a normal directory, not a subvolume and can be 
deleted with a simple 'rmdir'

I don't know if that is a bug or btrfs working as intended. Either way, 
don't use my script to create such nested subvolumes. It might or might 
not badly break and delete all your data.

A shell script can only do so much, so if it were to be extended, it 
would probably be worth investigating if rewriting it in C is viable. I 
think especially handling the recursive features would be easier from C.

The script is available in my btrfs-tools repository on github:
http://github.com/wereHamster/btrfs-tools

tom

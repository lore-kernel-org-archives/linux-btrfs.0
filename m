From: Evan LeCompte <evanlec@gmail.com>
Subject: Re: FS won't mount, =?utf-8?b?b3Blbl9jdHJlZQ==?= failed, Assertion !(path->slots[0] == 0) failed
Date: Fri, 23 Dec 2011 09:37:28 +0000 (UTC)
Message-ID: <loom.20111223T103108-120@post.gmane.org>
References: <CB041FF1.1FD66%dsmith@tgen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 <dsmith <at> tgen.org> writes:

> 
> So I'm having a bit of trouble with one of my btrfs filesystems.  It isn't
mounting after a power failure.  I
> can't get restore or btrfsck to run, even on backup supers.  I've pasted some
output below.  My btrfs-progs
> below come from git this morning, running on linux 3.2.0.
> 
> # mount /dev/md2 /media/test/
> mount: wrong fs type, bad option, bad superblock on /dev/md2,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> 
> dmesg:
> [26423.775471] device label LUMBERYARD devid 1 transid 1268960 /dev/md2
> [26423.860966] parent transid verify failed on 25487586828288 wanted 1268960
found 1246404
> [26423.860974] parent transid verify failed on 25487586828288 wanted 1268960
found 1246404
> [26423.860979] parent transid verify failed on 25487586828288 wanted 1268960
found 1246404
> [26423.872936] btrfs: open_ctree failed
> 
> # ./btrfsck /dev/md2
> parent transid verify failed on 25487586828288 wanted 1268960 found 1246404
> parent transid verify failed on 25487586828288 wanted 1268960 found 1246404
> parent transid verify failed on 25487586828288 wanted 1268960 found 1246404
> parent transid verify failed on 25487586828288 wanted 1268960 found 1246404
> Ignoring transid failure
> btrfsck: root-tree.c:46: btrfs_find_last_root: Assertion `!(path->slots[0] ==
0)' failed.
> Aborted
> # ./btrfsck -s 1 /dev/md2
> using SB copy 1, bytenr 67108864
> parent transid verify failed on 25483242758144 wanted 1268944 found 1268949
> parent transid verify failed on 25483242758144 wanted 1268944 found 1268949
> parent transid verify failed on 25483242758144 wanted 1268944 found 1268957
> parent transid verify failed on 25483242758144 wanted 1268944 found 1268957
> Ignoring transid failure
> btrfsck: root-tree.c:46: btrfs_find_last_root: Assertion `!(path->slots[0] ==
0)' failed.
> Aborted
> # ./btrfsck -s 2 /dev/md2
> using SB copy 2, bytenr 274877906944
> parent transid verify failed on 25483242758144 wanted 1268944 found 1268949
> parent transid verify failed on 25483242758144 wanted 1268944 found 1268949
> parent transid verify failed on 25483242758144 wanted 1268944 found 1268957
> parent transid verify failed on 25483242758144 wanted 1268944 found 1268957
> Ignoring transid failure
> btrfsck: root-tree.c:46: btrfs_find_last_root: Assertion `!(path->slots[0] ==
0)' failed.
> Aborted
> 
> # ./find-root /dev/md2
> http://pastebin.com/3umfQHhh
> 
> # ./restore -i -f 25483145760768 /dev/md2 /tmp
> parent transid verify failed on 25487586828288 wanted 1268960 found 1246404
> parent transid verify failed on 25487586828288 wanted 1268960 found 1246404
> parent transid verify failed on 25487586828288 wanted 1268960 found 1246404
> parent transid verify failed on 25487586828288 wanted 1268960 found 1246404
> Ignoring transid failure
> restore: root-tree.c:46: btrfs_find_last_root: Assertion `!(path->slots[0] ==
0)' failed.
> Aborted
> # ./restore -i -u 1 /dev/md2 /tmp
> parent transid verify failed on 25483242758144 wanted 1268944 found 1268949
> parent transid verify failed on 25483242758144 wanted 1268944 found 1268949
> parent transid verify failed on 25483242758144 wanted 1268944 found 1268957
> parent transid verify failed on 25483242758144 wanted 1268944 found 1268957
> Ignoring transid failure
> restore: root-tree.c:46: btrfs_find_last_root: Assertion `!(path->slots[0] ==
0)' failed.
> Aborted
> # ./restore -i -u 1 -f 25483145760768 /dev/md2 /tmp
> parent transid verify failed on 25483242758144 wanted 1268944 found 1268949
> parent transid verify failed on 25483242758144 wanted 1268944 found 1268949
> parent transid verify failed on 25483242758144 wanted 1268944 found 1268957
> parent transid verify failed on 25483242758144 wanted 1268944 found 1268957
> Ignoring transid failure
> restore: root-tree.c:46: btrfs_find_last_root: Assertion `!(path->slots[0] ==
0)' failed.
> Aborted
> 
> All further restores with various combinations of superblocks and bytenr's I
tried produced output
> identical to one of the restores above.
> 
> As the newest data on this filesystem had not been backed up, it would be nice
if I could either return the
> filesystem to a mountable state, or recover specific files to another
filesystem.  Any ideas?
> 

I'm having the very same issue as you. I've tried all the latest btrfs tools,
btrfsck, btrfs-zero-log, restore, find-root etc etc.

All to no avail. only err output is always 

"" btrfs_find_last_root: Assertion `!(path->slots[0] == 0)' failed. ""

This is a very cryptic error that doesn't tell me anything. and it seems to be
the only error that is ever thrown when transaction id's get out of sync.

Is there ANY way to even recover ANY files at all from these btrfs filesystems
that lose transid sync? mine occurred simply from a loose sata cable falling out
of one of my drives while the system was running.

This is extremely frustrating, but I guess I have no one to blame but myself. I
do have a backup but its about a month old (my cron backup script died for some
reason and I didn't notice). So I'm faced with losing a months worth of work :(

Please help us, anyone!




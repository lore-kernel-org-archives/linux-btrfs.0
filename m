From: "Norbert Scheibner" <scno@gmx.net>
Subject: Re: cross-subvolume cp --reflink
Date: Sun, 01 Apr 2012 19:07:54 +0200
Message-ID: <20120401170754.238550@gmx.net>
References: <20120401152749.61790@gmx.net> <4F787485.202@gmail.com>
 <20120401164136.61800@gmx.net> <4F788619.1040403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F788619.1040403@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> On: Sun, 01 Apr 2012 19:45:13 +0300 Konstantinos Skarlatos wrote

> > That's my point. This poor man's dedupe would solve my problems here
> very well. I don't need a zfs-variant of dedupe. I can implement such a
> file-based dedupe with userland tools and would be happy.
> 
> do you have any scripts that can search a btrfs filesystem for dupes 
> and replace them with cp --reflink?

Nothing really working and tested very well. After I get to known the missing cp --reflink feature I stopped to develop the script any further.

I use btrfs for my backups. Ones a day I rsync --delete --inplace the complete system to a subvolume, snapshot it, delete some tempfiles in the snapshot.
In addition to that I wanted to shrink file-duplicates.

What the script should do:
1. I md5sum every file
2. If the checksums are identical, I compare the files
3. If 2 or more files are really identical:
   - move one to a temp-dir
   - cp --reflink the second to the position and name of the first
   - do a chown --reference, chmod --reference and touch --reference
     to copy owner, file mode bits and time from the orginal to the
     reflink-copy and then delete the original in temp-dir

Everything could be done with bash. Thinkable is the use of a database for the md5sums, which could be used for other purposes in the future.

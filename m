Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:51563 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759308AbaD3TaA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Apr 2014 15:30:00 -0400
Date: Wed, 30 Apr 2014 21:29:54 +0200
From: Xavier Bassery <xavier@bartica.org>
To: linux-btrfs@vger.kernel.org
Cc: Niv Gal Waizer <nivwiz@gmail.com>
Subject: Re: File system errors
Message-ID: <20140430212954.2cfdaf03@renoir.lan>
In-Reply-To: <535D720E.1080900@gmail.com>
References: <535D714C.3000507@gmail.com>
	<535D720E.1080900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 28 Apr 2014 00:09:34 +0300
Niv Gal Waizer <nivwiz@gmail.com> wrote:

[this reply comes after we've dealt with the issue on IRC]

> A week ago I installed kernel 3.14 on an existing laptop with btrfs 
> install by ubuntu.  I upgraded ubuntu to 14.04 a few days ago.
> I had problems installing a package, then I removed libc6 by mistake,
> I could no longer boot the system. I booted from a usb disk with
> ubuntu 14.04. I ran btrfsck on the btrfs partition and find many
> errors:
> root@ubuntu:~# btrfsck /dev/sda1
> Checking filesystem on /dev/sda1
> UUID: a4e2f8a7-3a4e-47a0-8d96-20d70a53af04
> checking extents
> Incorrect local backref count on 772273311744 parent 839903506432
> owner 0 offset 0 found 0 wanted 1 back 0x2e5d7f0
> Backref disk bytenr does not match extent record,
> bytenr=772273311744, ref bytenr=0
> Backref 772273311744 root 256 owner 1453610 offset 0 num_refs 0 not 
> found in extent tree
[...]
> Errors found in extent allocation tree or chunk allocation
> checking free space cache
> cache and super generation don't match, space cache will be
> invalidated checking fs roots
> root 256 inode 146314 errors 200, dir isize wrong
> root 256 inode 160861 errors 400, nbytes wrong
> root 256 inode 967929 errors 1800, odd csum item, some csum missing
> root 256 inode 996928 errors 1800, odd csum item, some csum missing
> root 256 inode 1326452 errors 400, nbytes wrong
> root 256 inode 1326453 errors 400, nbytes wrong
> root 261 inode 160861 errors 400, nbytes wrong
> root 261 inode 967929 errors 1800, odd csum item, some csum missing
> root 261 inode 996928 errors 1800, odd csum item, some csum missing
> root 261 inode 1326452 errors 400, nbytes wrong
> root 261 inode 1326453 errors 400, nbytes wrong
> found 77318565024 bytes used err is 1

 
> I then ran btrfsck --repair /dev/sda1

It is often recommended to not use --repair without being told so by a
developer or an experienced user.
The reason is that there are cases (esp. fs that refuse to mount) where
--repair is not appropriate and could make things worse instead of
fixing anything.
Fortunately, you were not in such a case.

> I then ran it again and got:
> btrfsck /dev/sda1
> Checking filesystem on /dev/sda1
> UUID: a4e2f8a7-3a4e-47a0-8d96-20d70a53af04
> checking extents

The multiple "Incorrect local backref" are gone.
It looks like the repair in your case fixed them.
Some others have experienced huge numbers a those lines that
would show up intermittently but would not go away with a repair.

> checking free space cache
> cache and super generation don't match, space cache will be
> invalidated checking fs roots
> root 256 inode 160861 errors 400, nbytes wrong
> root 256 inode 967929 errors 1800, odd csum item, some csum missing
> root 256 inode 996928 errors 1800, odd csum item, some csum missing
> root 256 inode 1326452 errors 400, nbytes wrong
> root 256 inode 1326453 errors 400, nbytes wrong
> root 261 inode 160861 errors 400, nbytes wrong
> root 261 inode 967929 errors 1800, odd csum item, some csum missing
> root 261 inode 996928 errors 1800, odd csum item, some csum missing
> root 261 inode 1326452 errors 400, nbytes wrong
> root 261 inode 1326453 errors 400, nbytes wrong
> found 237847721824 bytes used err is 1

These lines report inconsistencies in the metadata.
These inconsistencies were likely linked to former bugs that should have
been fixed now in your 3.14 kernel.
Possible culprits are bugs that have been patched by:
- "Btrfs: relocate csums properly with prealloc extents" for the errors
1800 (which are actually 2 errors with bitfields 0x1000 and 0x800)
[confirmed on IRC, as those files were VM image files]
, and 
- "Btrfs: don't use ram_bytes for uncompressed inline items" for the
errors 400 messages.
I've been told that the latter errors (nbytes wrong) should be harmless.

As you've noticed, "btrfs check --repair" didn't fix those errors
(except the error 200, dir isize wrong).

> I ran the btrfsck from this kerenl:
> Linux ubuntu 3.13.0-24-generic #46-Ubuntu SMP Thu Apr 10 19:11:08 UTC 
> 2014 x86_64 x86_64 x86_64 GNU/Linux

btrfs check is in userspace and as such doesn't behave differently
based on the kernel that is used.

> I ran an offline smart long test and found no errors on the drive.
> 
> What is wrong with my file system?
> What extra info need I supply?

Hopefully, there is nothing to worry much about.
If you still want to clean the 400 and 1800 errors from the check
output then you first need to find those files.
Let's consider "root 256 inode 967929 errors 1800" for instance.
To find the subvolume path of "root 256", use:

# btrfs subv list /mountpoint

you may get something like:
ID 256 gen 425928 top level 5 path @	 <-- here's the path
ID 261 gen 426018 top level 5 path @home

Then you can find the file path that matches the reported inode number
in that subvolume with:
btrfs inspect-internal inode-resolve 967929 /mountpoint/@

Now to fix the errors you can try various things.
First, for files you don't care, deleting them is the obvious fix.
For those valuable, you could copy the problematic file to a temporary
file and replace the original file with that copy and hopefully that
should do the trick.
In the case  you couldn't read them because of any csum error, you may
consider mounting the fs with -o ro,nodatasum once, the time for you to
copy the files somewhere else.
Alternatively you could also try "btrfs restore".



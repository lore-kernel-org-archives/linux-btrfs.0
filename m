From: Matt Brown <shadowfax@gmx.com>
Subject: Re: Copy/move btrfs volume
Date: Thu, 01 Jul 2010 16:21:14 -0600
Message-ID: <4C2D14DA.3040301@gmx.com>
References: <i0hqkk$r4h$1@dough.gmane.org>	<AANLkTin1O6Oa7oq4nFMfNhv4N5FWCko7bcuTMoR5Xkob@mail.gmail.com> <i0huf7$98a$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <i0huf7$98a$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/01/2010 05:33 AM, Lubos Kolouch wrote:
> Daniel J Blueman, Thu, 01 Jul 2010 12:26:10 +0100:
>>> What is the correct way to do this?
>>
>> The only way to do this preserving duplication is to use hardlinks
>> between duplicated files (which reference counts the inode), and use
>> 'rsync -H'.
>>
>> Dan

Hello,

With backed up files consisting of hard links, I usually use dd to copy
the file systems at the block level

# dd if=/dev/sda of=/dev/sdb bs=20M

and then expand the file system. This is because I found that tools like
rsync, while usually fast, are extremely slow when dealing with millions
of hard linked files.

This could also be used for btrfs to keep its snapshots.

> A scenario - I have raid5 of say, 1TB HDDs. It contains many snapshots.
> Then, few years later, new machine is bought and there are, say, 5TB
> discs.
> ...
> Lubos

For me, I had to copy over BackupPC hardlinked files from a full disk to
a smaller disk, both using ext4, and I could not use dd. What normally
should have taken an hour, instead took almost a week. (Yes, I wanted to
use btrfs, but it had a hard link limit of 255 - don't know if it still
does.)

It would be nice to have a btrfs command that could rapidly copy over
the file system, snapshots, and all other file system info.

But what benefit would having a native btrfs 'copy/rsync' command have
over the dd/resize option?

Pros
- Files will be immediately checksumed on new disks, but this may not be
as important since a checksum/verify command will be implemented.
- Great 'feature' for copying files to new drives, and keeping
snapshots. Could even be used to export snapshots.
- I believe compressed files will have to be uncompressed and
recompressed, depending on when file is checksummed. (I may be wrong on
this one). This will actually be a con for slow and/or high load machines.
- One command instead of many (dd -> resize -> verify).

Cons
- File system would still have to be unmounted, or at least read-only,
as I doubt the command will have rsync's update or delete abilities.
But, maybe it could.

Questionable
- May be faster than dd/resize, or it may be just as slow as rsync is
with hard links. And I am talking about dozens to thousands of
snapshots, and millions to billions of files.

Matt

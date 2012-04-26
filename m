From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Interpreting Output of "btrfs fi show"
Date: Thu, 26 Apr 2012 20:54:47 +0000 (UTC)
Message-ID: <pan.2012.04.26.20.54.46@cox.net>
References: <CAGy7UtioPbdjomzuv3phZcF+HShyYKytkOKnAhP+4VGj29Aahg@mail.gmail.com>
	<C7$h9m5PCXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Helmut Hullen posted on Thu, 26 Apr 2012 13:11:00 +0200 as excerpted:

> Hallo, Bart,
> 
> Du meintest am 26.04.12:
> 
>>>> As for the two filesystems shown in btrfs fi show... I have no clue
>>>> what that is about. Did you maybe make a mistake to create a btrfs
>>>> filesystem on the whole disk at first?
> 
>>> That is possible. But afterwards I certainly repartioned the device
>>> and created a btrfs filesystem on /dev/sda1. Maybe this info is only
>>> in the partition table? I understand that I should avoid mounting
>>> /dev/sda in this situation.
> 
>> Well I think there is a btrfs superblock still present from the
>> full-disk filesystem. Due to the offset of the first partition from the
>> start of the disk, this superblock was not overwritten when you created
>> the filesystem inside the partition.
> 
> Sounds familiar ...
> 
> I now use to delete about the first 10 MByte of the target disk via "dd
> if=/dev/zero"

Interestingly, this reminds me very much of the problem reiserfs has 
(used to have??) with reiserfsck --rebuild-tree, where it would scan the 
disk and decide anything that looked like a reiserfs superblock must 
indeed be one, so any loopback filesystems created on a larger reiserfs 
would screw up the larger reiserfs if rebuild-tree was ever run on it.

FWIW, I still run reiserfs, while waiting for a new filesystem with tail-
packing (FWIW one of the features btrfs has, but btrfs isn't mature yet), 
but I've never done a loopback reiserfs hosted on reiserfs -- I make sure 
any loopbacks are something else, so I I've never had that problem 
personally nor do I expect to.

But /unlike/ reiserfs, which was only affected with the well warned as 
don't-use-unless-you-have-to fsck --rebuild-tree option, it seems that 
due to btrfs scan, etc, btrfs has its similar problem in more routine 
operation.

But of course Chris Mason, being reiserfs maintainer for many years (and 
whose praises I continue to sing for introducing and making ordered 
journaling the reiserfs default in the mainline kernel... such that 
during the infamous period when ext3 defaulted to writeback journaling, 
reiserfs was arguably more stable than ext3!), both knows and has 
forgotten waayyy more about that than most of us would ever /dream/ of 
knowing in the first place, I'm sure!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


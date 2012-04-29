From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Interpreting Output of "btrfs fi show"
Date: Sun, 29 Apr 2012 04:15:24 +0000 (UTC)
Message-ID: <pan.2012.04.29.04.15.24@cox.net>
References: <CAGy7UtioPbdjomzuv3phZcF+HShyYKytkOKnAhP+4VGj29Aahg@mail.gmail.com>
	<C7$h9m5PCXB@helmut.hullen.de> <pan.2012.04.26.20.54.46@cox.net>
	<8118972.tgkAvno4mK@bursa22>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hubert Kario posted on Sat, 28 Apr 2012 18:42:52 +0200 as excerpted:

> On Thursday 26 of April 2012 20:54:47 Duncan wrote:
>> Helmut Hullen posted on Thu, 26 Apr 2012 13:11:00 +0200 as excerpted:
>> > Hallo, Bart,
>> >> 
>> >> Well I think there is a btrfs superblock still present from the
>> >> full-disk filesystem. Due to the offset of the first partition from
>> >> the start of the disk, this superblock was not overwritten when you
>> >> created the filesystem inside the partition.
>> > 
>> > Sounds familiar ...
>> > 
>> > I now use to delete about the first 10 MByte of the target disk via
>> > "dd if=/dev/zero"
>> 
>> But /unlike/ reiserfs, which was only affected with the well warned as
>> don't-use-unless-you-have-to fsck --rebuild-tree option, it seems that
>> due to btrfs scan, etc, btrfs has its similar problem in more routine
>> operation.
> 
> I'd say that this kind of problem is basically impossible in btrfs
> because of FS UUID written all over the tree.

Very good point!  I had forgotten about that.

> What we see here, is a superblock that is written in *very* specific
> place on the partition, that just is aligned in place that makes the
> whole disk look like btrfs.

Yes.  That would be more analogous to the md/raid problem related to one 
of the 1.x metadata formats, where it's at the /end/ of the volume.  If 
that "volume" happens to correspond to the end of the physical disk as 
well, then it's not always clear whether the md with metadata of that 
version is the entire device or just a partition thereon.

> I don't think it's actually possible for btrfs to put a file with btrfs
> filesystem image in place where it could seem like the basic block
> device has btrfs /too/. It depends on whatever the metadata block is
> allocated before data block on disk. It /may/ be possible in mixed
> data-metadata allocation mode.
> Chris or Josef, can you confirm?

Makes sense.  I too would like confirmation on the mixed-mode case, tho, 
as when I setup with btrfs, I'll very likely be using mixed-mode for some 
of my smaller filesystems.  (I don't plan on using the sub-volumes for 
that, as a good part of the reason I'm doing it is robustness, not 
putting all my data "eggs" in the same filesystem "basket".  Keeping them 
in separate baskets means if one filesystem "basket" dies, I've lost only 
a relatively small subset of my data.)

> Still, a "zero-superblock" option would be useful for the btrfs tool.
> I'll see what I can do about this.

Yes, indeed.  Particularly since various bits of btrfs functionality 
depend on scanning for filesystems (presumably their superblocks), and 
output like that in the OP can be confusing indeed, as well as 
potentially dangerous in recovery situations, where the wrong one might 
be activated by accident.  (FWIW, there's an mdadm --zero-superblock 
option.  I should take note of this thread and be sure I use it when next 
I redo my layouts, probably when I switch some of them to btrfs instead, 
tho that's going to be a bit as I'm waiting for N-way-mirroring, aka 
proper raid1 mode, not the 2-way-only-mirroring that btrfs calls raid1 
mode currently.)

Thanks.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34528 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750809AbaHWQqY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Aug 2014 12:46:24 -0400
Date: Sat, 23 Aug 2014 12:38:05 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: superblock checksum mismatch after crash, cannot mount
Message-ID: <20140823163803.GA9149@hungrycats.org>
References: <53F7BD8E.10308@floga.de>
 <pan$a4556$243aa48a$bd2898a8$c2006893@cox.net>
 <53F85317.8060900@floga.de>
 <pan$16219$d960b649$52ed1e6$33540704@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <pan$16219$d960b649$52ed1e6$33540704@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 23, 2014 at 09:34:10AM +0000, Duncan wrote:
> Florian Gamböck posted on Sat, 23 Aug 2014 10:38:47 +0200 as excerpted:
> 
> > Am 23.08.2014 07:27, schrieb Duncan:
> >> btrfs-show-super is your tool for inspecting the superblocks.  [...]
> >> Then use btrfs rescue super-recover
> 
> > Yes, show-super told me, that the first super block did "NOT MATCH", but
> > the second one seemed to be in order ("MATCHED"). The SD card is 16 GiB
> > big, so there was no third super block.
> > 
> > Rescue also listed the first one as bad and the second one as good and
> > it seemed to run successfully, no errors whatsoever.
> 
> Good so far, but...
> 
> > However, after "recovering", every single partition on the card broke.
> > There were three partitions: 1 = fat32 ("/boot"), 2 = swap, 3 = btrfs
> > ("/"). Naturally I ran the rescue command on partition 3, I hope that
> > was not a mistake. Afterwards, as I said, none of the partitions were
> > recognized anymore. Not even btrfs recognized the third partition.
> 
> That is strange.  Was the partition table still recognized?  Had you used 
> mbr or gpt partitioning (I'm presuming the pi handles them, of course, I 
> don't know a lot about pi/arm).
> 
> FWIW these days I use gpt because it keeps one checksummed copy at each 
> end of the device for better reliability, and of course also because it 
> does away with primary/secondary/logical partition worries and allows 
> partition names/labels (as distinct from filesystem labels), but I have 
> literally /no/ idea whether pi supports it as I've never worked with a pi.
> 
> I can't think of any scenario that would screw up all the partitions  
> unless the partition table was damaged and/or unless the firmware was 
> buggy and basically scrambled things.  It's almost as if the superblock 
> fix landed in the middle of the partition table (maybe 64 KiB into the 
> entire SD card, is that still partition table?) instead of at the 64 KiB 
> mark into what would have been partition 3, the btrfs partition, but if 
> it was reading the second one as good, it must have gotten the right 
> partition to do that, in which case it couldn't be that you simply typoed 
> and didn't include the digit.
> 
> I can't personally rule out a bug in btrfs rescue as I've never used that 
> tool myself, but one this severe?  Hard to imagine, yet /something/ 
> screwed up. 
> 
> Weird.

Sounds like perfectly normal SD card corruption.

> Anyway, were it me, I'd consider that sdcard suspect (bad firmware) until 
> I could pin down what it did a bit better, because something implausible 
> just happened, and that's as plausible an explanation as anything else 
> we've got.
> 
> > Since I've thought I messed up entirely, I just gave up, re-formatted
> > the card and let my backups do the job.
> 
> At that point, that's what I would have done too, with the caveat about 
> considering the card suspect for the time being, and being sure it's 
> /regularly/ backed up in case it scrambles again.
> 
> > It's quite annoying though, how often I get those problems. May it be
> > that the Raspberry Pi is too slow to let btrfs do its background magic,
> > may it be that btrfs is not that suitable for SD cards (in my case it's
> > a class 10 microSDHC, 16GiB), or may it be that btrfs is still not that
> > reliable when it comes to "unclean" shutdowns.
> 
> I'd guess a mix of the above.  There's some recent research at how poor 
> certain solid state devices are at handling power cuts.  Someone here 
> probably has a link or google it.  Having work on one partition scramble 
> others certainly seems like bad firmware to me, tho I'm no expert.  But 
> btrfs' write patterns are surely about as far from the fat many of these 
> devices were designed for as it gets, so btrfs may well be stressing it 
> quite a bit as well.

btrfs write patterns are probably closer to what SD cards are designed
for than ext4 or xfs.  btrfs COW tries to write data sequentially in
contiguous chunks like a camera sequentially storing JPEGs on a FAT
filesystem.  Contrast with ext4 which alternates between journal writes
and random 4K page writes.  ext4 also writes metadata twice (once in
the FS, once in the journal) to wear out the SD card faster.

> I'd also try to compare notes with other pi users and see if they're 
> noting problems with the pi and btrfs as well.  I'm entirely clueless in 
> that regard, but I read enough about them to at least know they have a 
> rather large and active user community, so you can't be the first to have 
> tried it.  Someone's gotta have some experience to share.

I have several Pis running btrfs on a local build of kernel 3.12.24.
I have no btrfs-specific problems with these...but there's a "but":

Consumer SD cards are /terrible/ storage devices.  Always back up all
data written to an SD card as soon as possible after writing it, and
develop a process to restore the backup to a new SD card conveniently
when--not if--the card fails.

Over the years I've burned my way through dozens of SD cards in Pis,
Beagles, x86 laptops, USB SD card readers, cameras and cell phones.
I have more bad or failed cards than good ones in my collection, but no
more than three of any specific model.  Brand, price, and specs don't
correlate to success or failure.  Even the good cards wear out after
heavy use.  The bad ones fail much faster, and are more likely to give
you garbage data instead of properly formed I/O errors as they fail.

btrfs helps with the backup/restore process, detects SD card failure
faster, and puts less write load on the SD card (COW instead of
journalling, and compression reduces write size).

Some might suggest "ext4 is better than btrfs because I can fix a
corrupt SD card with e2fsck that I can't fix with btrfsck"; however,
in my experience the Pis don't have enough RAM to run e2fsck when it
allocates extra memory to fix non-trivial FS corruption, and failing SD
cards just get worse when you rewrite them anyway.  Save some time and
sanity, and just skip ahead to building a new SD card (preferably not
the same brand and model as the old one) from the last backup.  You may
need to go through three or four models before you find one that works.

Bad firmware (i.e. anything less than the very /best/ firmware) can flip
bits instead of giving explicit I/O errors.  No filesystem can survive
this.  btrfs can turn flipped bits into I/O errors and try to limit
the damage by making the filesystem read-only, but it can't fix the
underlying problem.

You might still be able to use a bad SD card read-only in a Pi (e.g. to
boot and mount root from a USB device); however, any write to a bad
SD card can scramble its contents, so such a system is running on
borrowed time.  In the worst cases, a single write can make all data on
the card instantly and permanently irretrievable.  In typical cases a
write to one location effectively change data in several other locations
in unpredictable ways, including changes to the mapping between logical
block addresses and physical storage locations.

btrfs suppresses redundant metadata by default when it detects
non-rotating media, so on a single storage device you won't get two copies
of metadata and all corruption is unrecoverable.  Corrupt metadata
produces messages that look more like FS bugs than storage device
corruption--you won't get nice clean "checksum failed" error messages
when btrfs can't find the data checksums in a corrupt metadata tree to
verify them.

> The other possibility I guess is to try a different brand and spec of 
> card, to see if that makes any difference.  I just don't know at this 
> point, so it's all in-play ATM.
> 
> > Nevertheless, I will keep your explanations around for future reference,
> > they were really helpful! Thanks again!
> 
> =:^)
> 
> -- 
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

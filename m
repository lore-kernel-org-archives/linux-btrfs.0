From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: LABEL only 1 device
Date: Sun, 26 Feb 2012 18:07:31 +0000 (UTC)
Message-ID: <pan.2012.02.26.18.07.31@cox.net>
References: <20120226153036.GB18898@carfax.org.uk>
	<C3b12r9i1uB@helmut.hullen.de> <20120226164400.GC18898@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Sun, 26 Feb 2012 16:44:00 +0000 as excerpted:

>> I prefer LABELling the devices/partitions, and then I'd seen that the
>> option "-L" makes problems when I use it for more than 1 device/
>> partition.
> 
>    As far as I know, you can't label partitions or devices. Labels are
> a filesystem thing, and are stored in a FS-dependent manner. There's a
> confusion that historically it's been a one-to-one mapping, so people
> get *very* sloppy about the distinction (particularly since there's no
> real way of referring to a filesystem independently of the block
> device(s) it's resident on).

With legacy MBR-based partitioning, that is correct, devices don't have a 
label, filesystems do.  Take an md/raid1 device for instance, and put a 
filesystem on it.  It's the filesystem that gets the label when mkfs 
(make filesystem) is done, putting the same label on the filesystem on 
all the md/raid1 component devices since it's mirrored (raid-1-ed) to all 
of them.

However, GPT-based partitioning *DOES* have partition level labels 
available.  I'm not sure if for instance parted exposes that 
functionality, but gptfdisk, which I use, certainly does.  That's useful 
with partitioned md/raid, since the filesystem on the partition gets a 
different label than the gpt-partition itself, which has a different 
label than all the underlying physical device partitions that compose the 
md/raid1.

Unfortunately, since gpt is reasonably new in terms of filesystem and 
partitioning tools, there isn't really anything (mount, etc) that makes 
/use/ of that label yet, tho gptfdisk does display it, let you modify it, 
etc, so it's easier to keep track at that level of whether you're 
operating on what you intended to operate on, as long as you keep the 
physical device partition labels distinct from the partitioned md/raid 
device labels, from the filesystem labels as created by mkfs.  (I have a 
consistent scheme I use, so they are distinct here.)

FWIW, gpt was designed by Intel and others to be used by EFI, but BIOS 
based devices support it as well, as do grub2, grub-legacy (with patches 
applied), and the kernel (with the related kernel config options 
enabled).  Since it does away with the primary/secondary/logical 
partition distinction, has dual-copy checksummmed partition tables, and 
has partition labels, plus the fact that it supports 2+TiB drives, it's 
gradually replacing MBR even on BIOS systems, but it's a slow process as 
MBR has been around for decades!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


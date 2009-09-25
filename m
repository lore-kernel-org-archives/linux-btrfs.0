From: Edward Shishkin <edward.shishkin@gmail.com>
Subject: Re: how does grub exactly work?
Date: Fri, 25 Sep 2009 15:48:48 +0200
Message-ID: <4ABCCA40.3020501@gmail.com>
References: <200909251049.18109.aj@dungeon.inka.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Andreas Jellinghaus <aj@dungeon.inka.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200909251049.18109.aj@dungeon.inka.de>
List-ID: <linux-btrfs.vger.kernel.org>

Andreas Jellinghaus wrote:
> Hi Edward,
>   

Hello.

> I saw your mail on btrfs ml with the grub patches and the notes
> how to deal with btrfs.
>
> can you explain how grub and btrfs work exactly?
> I read the grub manual at
> http://www.gnu.org/software/grub/manual/html_node/Bootstrap-
> tricks.html#Bootstrap-tricks
>
> so I wonder: does btrfs provide a "boot loader area" similar
> to ffs and reiserfs, where grub places the stage 1.5 code
> and stage 1 can read it?
>
>   

Yes.

> or does grub find out the sectors of the stage 1.5 file and
> put the list of those into the stage 1 file (first sector address
> of stage 1.5 file) and stage 1.5 first sector (list of all
> other sectors)?
>   

Grub doesn't make the blocklist for stage1_5

Optionally grub makes the blocklist for stage2 (in particular
when stage1.5 can not be embedded for some reasons).

Note, that it is important to embed and use btrfs_stage1_5.
First, because btrfs has defragmentator, which can make the
blocklist out of date (so that you'll need to reinstall grub).
Second, I am not sure, if the blocklist will be composed
correctly in the case when stage2 locates in btrfs volume
(I didn't look at the blocklist specification: it can happen that
grub installer makes an assumption that all sectors of stage2
locate on the same device).

> and what would be the proper way to make boot from a raid1 device?
> so that if one disk fails the other can boot?
> device (hd0) /dev/sda
> root (hd0,X) 
> setup (hd0)
>
> device (hd0) /dev/sdb
> root (hd0,X)
> setup (hd0)
>   

Perhaps, it will work. But officially grub doesn't
understand software raid, and I am not familiar
with raid1 specifications, so...  ;)

> if data is written to mbr only and the sectors between mbr and
> the first partition, this could work. but if data is written to
> mbr and to btrfs (either a "boot loader area" or changes to the
> stage 1.5 file), then that data can only contain the valid block
> lists for one of the two hard disks - which shouldn't be a problem
> if drives are the same and have 100% the same geometry and partitioning.
>
> so I wonder, and it would be great if thise fine details would be
> documented for btrfs somewhere, as there is very little information
> about them (the situation isn't better with other filesystems either).
>
> thanks for your help!
>
> Regards, Andreas
>
>   


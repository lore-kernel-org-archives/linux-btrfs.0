Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40677 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbcBLHKp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 02:10:45 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aU7sH-0003QO-Qy
	for linux-btrfs@vger.kernel.org; Fri, 12 Feb 2016 08:10:41 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Feb 2016 08:10:41 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Feb 2016 08:10:41 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] btrfs: change max_inline default to 2048
Date: Fri, 12 Feb 2016 07:10:29 +0000 (UTC)
Message-ID: <pan$a7a79$b5fd299c$6a9e065d$4210bc14@cox.net>
References: <1455209730-22811-1-git-send-email-dsterba@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba posted on Thu, 11 Feb 2016 17:55:30 +0100 as excerpted:

> The current practical default is ~4k on x86_64 (the logic is more
> complex, simplified for brevity)

> Proposed fix: set the default to 2048

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index bfe4a337fb4d..6661ad8b4088 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2252,7 +2252,7 @@ struct btrfs_ioctl_defrag_range_args {

> -#define BTRFS_DEFAULT_MAX_INLINE	(8192)
> +#define BTRFS_DEFAULT_MAX_INLINE	(2048)

Default?

For those who want to keep the current inline, what's the mkfs.btrfs or 
mount-option recipe to do so?  I don't see any code added for that, nor 
am I aware of any current options to change it, yet "default" indicates 
that it's possible to set it other than that default if desired.


Specifically what I'm looking at here is avoiding "tails", ala reiserfs. 

Except to my understanding, on btrfs, this feature doesn't avoid tails on 
large files at all -- they're unchanged and still take whole blocks even 
if for just a single byte over an even block size.  Rather, (my 
understanding of) what the feature does on btrfs is redirect whole files 
under a particular size to metadata.  While that won't change things for 
larger files, in general usage it /can/ still help quite a lot, as above 
some arbitrary cutoff (which is what this value ultimately becomes), a 
fraction of a block, on a file that's already say hundreds of blocks, 
doesn't make a lot of difference, while a fraction of a block on a file 
only a fraction of a block in size, makes ALL the difference, 
proportionally.  And given that a whole lot more small files can fit in 
whatever size compared to larger files...

Of course dup metadata with single data does screw up the figures, 
because any data that's stored in metadata then gets duped to twice the 
size it would take as data, so indeed, in that case, half a block's size 
(which is what your 2048 is) maximum makes sense, since above that, the 
file would take less space stored in data as a full block, then it does 
squished into metadata but with metadata duped.

But there's a lot of users who choose to use the same replication for 
both data and metadata, on a single device either both single, or now 
that it's possible, both dup, and on multi-device, the same raid-whatever 
for both.  For those people, even a (small) multi-block setting makes 
sense, because for instance 16 KiB plus one byte becomes 20 KiB when 
stored as data in 4 KiB blocks, but it's still 16 KiB plus one byte as 
metadata, and the multiplier is the same for both, so...  And on raid1, 
of course that 4 KiB extra block becomes 8 KiB extra, 2 * 4 KiB blocks, 
32 KiB + 4 B total as metadata, 40 KiB total as data.

And of course we now have dup data as a single-device possibility, so 
people can set dup data /and/ metadata, now, yet another same replication 
case.

But there's some historical perspective to consider here as well.  Back 
when metadata nodes were 4 KiB by default too, I believe the result was 
something slightly under 2048 anyway, so the duped/raid1 metadata vs. 
single data case worked as expected, while now that metadata nodes are 16 
KiB by default, you indicate the practical result is near the 4 KiB block 
size, and you correctly point out the size-doubling implications of that 
on the default single-data, raid1/dup-metadata, compared to how it used 
to work.

So your size implications point is valid, and of course reliably getting/
calculating replication value is indeed problematic, too, as you say, 
so...

There is indeed a case to be made for a 2048 default, agreed.

But exposing this as an admin-settable value, so admins that know they've 
set a similar replication value for both data and metadata can optimize 
accordingly, makes a lot of sense as well.

(And come to think of it, now that I've argued that point, it occurs to 
me that maybe setting 32 KiB or even 64 KiB node size as opposed to 
keeping the 16 KiB default, may make sense in this regard, as it should 
allow larger max_inline values, to 16 KiB aka 4 * 4 KiB blocks, anyway, 
which as I pointed out could still cut down on waste rather dramatically, 
while still allowing the performance efficiency of separate data/metadata 
on files of any significant size, where the proportional space wastage of 
sub-block tails will be far smaller.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


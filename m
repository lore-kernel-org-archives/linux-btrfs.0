Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbcBOSmX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 13:42:23 -0500
Date: Mon, 15 Feb 2016 19:42:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: change max_inline default to 2048
Message-ID: <20160215184218.GP4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1455209730-22811-1-git-send-email-dsterba@suse.com>
 <pan$a7a79$b5fd299c$6a9e065d$4210bc14@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$a7a79$b5fd299c$6a9e065d$4210bc14@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 12, 2016 at 07:10:29AM +0000, Duncan wrote:
> Default?
> 
> For those who want to keep the current inline, what's the mkfs.btrfs or 
> mount-option recipe to do so?  I don't see any code added for that, nor 
> am I aware of any current options to change it, yet "default" indicates 
> that it's possible to set it other than that default if desired.

The name of the mount option is max_inline, referred in the subject.
This is a runtime option and not affected by mkfs.

> Specifically what I'm looking at here is avoiding "tails", ala reiserfs. 

The inline data are not the same as the reiserfs-style tail packing.
On btrfs only files smaller than the limit are inlined, file tails
allocate a full block.

> Except to my understanding, on btrfs, this feature doesn't avoid tails on 
> large files at all -- they're unchanged and still take whole blocks even 
> if for just a single byte over an even block size.  Rather, (my 
> understanding of) what the feature does on btrfs is redirect whole files 
> under a particular size to metadata. 

Right.

> While that won't change things for 
> larger files, in general usage it /can/ still help quite a lot, as above 
> some arbitrary cutoff (which is what this value ultimately becomes), a 
> fraction of a block, on a file that's already say hundreds of blocks, 
> doesn't make a lot of difference, while a fraction of a block on a file 
> only a fraction of a block in size, makes ALL the difference, 
> proportionally.  And given that a whole lot more small files can fit in 
> whatever size compared to larger files...
> 
> Of course dup metadata with single data does screw up the figures, 
> because any data that's stored in metadata then gets duped to twice the 
> size it would take as data, so indeed, in that case, half a block's size 
> (which is what your 2048 is) maximum makes sense, since above that, the 
> file would take less space stored in data as a full block, then it does 
> squished into metadata but with metadata duped.
> 
> But there's a lot of users who choose to use the same replication for 
> both data and metadata, on a single device either both single, or now 
> that it's possible, both dup, and on multi-device, the same raid-whatever 
> for both.  For those people, even a (small) multi-block setting makes 
> sense, because for instance 16 KiB plus one byte becomes 20 KiB when 
> stored as data in 4 KiB blocks, but it's still 16 KiB plus one byte as 
> metadata,

Not exactly like that, the internal limits are page size, b-tree leaf
space and max_inline. So on a common hardware the limit is 4k.

> and the multiplier is the same for both, so...  And on raid1, 
> of course that 4 KiB extra block becomes 8 KiB extra, 2 * 4 KiB blocks, 
> 32 KiB + 4 B total as metadata, 40 KiB total as data.
> 
> And of course we now have dup data as a single-device possibility, so 
> people can set dup data /and/ metadata, now, yet another same replication 
> case.

I think the replication is not strictly related to this patch. Yes it
applies for the default DUP metadata profile, but that's rather a
conicidence. The primary purpose is to guarantee replication for
metadata, not the inlined data.

> But there's some historical perspective to consider here as well.  Back 
> when metadata nodes were 4 KiB by default too, I believe the result was 
> something slightly under 2048 anyway,

In that case the b-tree leaf limit applies, so it's 4k - leaf header,
resulting in ~3918 bytes.

> so the duped/raid1 metadata vs. 
> single data case worked as expected, while now that metadata nodes are 16 
> KiB by default, you indicate the practical result is near the 4 KiB block 
> size,

Here the page size limit applies and it's 4k exactly.

> and you correctly point out the size-doubling implications of that 
> on the default single-data, raid1/dup-metadata, compared to how it used 
> to work.
> 
> So your size implications point is valid, and of course reliably getting/
> calculating replication value is indeed problematic, too, as you say, 
> so...
> 
> There is indeed a case to be made for a 2048 default, agreed.
> 
> But exposing this as an admin-settable value, so admins that know they've 
> set a similar replication value for both data and metadata can optimize 
> accordingly, makes a lot of sense as well.
> 
> (And come to think of it, now that I've argued that point, it occurs to 
> me that maybe setting 32 KiB or even 64 KiB node size as opposed to 
> keeping the 16 KiB default, may make sense in this regard, as it should 
> allow larger max_inline values, to 16 KiB aka 4 * 4 KiB blocks, anyway, 
> which as I pointed out could still cut down on waste rather dramatically, 
> while still allowing the performance efficiency of separate data/metadata 
> on files of any significant size, where the proportional space wastage of 
> sub-block tails will be far smaller.)

As stated above, unfortunatelly no, and what's worse, larger node sizes
cause increase in memcpy overhead on all metadata changes. Then the
amount of bytes saved would not IMO justify the performance drop. The
tendency is to lower the limit, there were people asking how to turn
inlining off completely.

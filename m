Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbbFKPZT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 11:25:19 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 51B23AD27
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2015 15:25:18 +0000 (UTC)
Message-ID: <5579A85C.2040301@suse.com>
Date: Thu, 11 Jun 2015 11:25:16 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] btrfs: skip superblocks during discard
References: <1434036062-21597-1-git-send-email-jeffm@suse.com> <1434036062-21597-2-git-send-email-jeffm@suse.com>
In-Reply-To: <1434036062-21597-2-git-send-email-jeffm@suse.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 6/11/15 11:20 AM, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> Btrfs doesn't track superblocks with extent records so there is
> nothing persistent on-disk to indicate that those blocks are in
> use.  We track the superblocks in memory to ensure they don't get
> used by removing them from the free space cache when we load a
> block group from disk.  Prior to 47ab2a6c6a (Btrfs: remove empty
> block groups automatically), that was fine since the block group
> would never be reclaimed so the superblock was always safe.  Once
> we started removing the empty block groups, we were protected by
> the fact that discards weren't being properly issued for unused
> space either via FITRIM or -odiscard.  The block groups were still
> being released, but the blocks remained on disk.
> 
> In order to properly discard unused block groups, we need to filter
> out the superblocks from the discard range.  Superblocks are
> located at fixed locations on each device, so it makes sense to
> filter them out in btrfs_issue_discard, which is used by both
> -odiscard and FITRIM.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com> --- 
> fs/btrfs/extent-tree.c | 50
> ++++++++++++++++++++++++++++++++++++++++++++------ 1 file changed,
> 44 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c index
> 0ec3acd..75d0226 100644 --- a/fs/btrfs/extent-tree.c +++
> b/fs/btrfs/extent-tree.c @@ -1884,10 +1884,47 @@ static int
> remove_extent_backref(struct btrfs_trans_handle *trans, return
> ret; }
> 
> -static int btrfs_issue_discard(struct block_device *bdev, -				u64
> start, u64 len) +#define in_range(b, first, len)	((b) >= (first) &&
> (b) < (first) + (len)) +static int btrfs_issue_discard(struct
> block_device *bdev, u64 start, u64 len, +			       u64
> *discarded_bytes) { -	return blkdev_issue_discard(bdev, start >> 9,
> len >> 9, GFP_NOFS, 0); +	u64 skipped = 0; +	u64 bytes_left = len; 
> +	int ret = 0 , j; + +	*discarded_bytes = 0; + +	/* Skip any
> superblocks on this device. */ +	for (j = 0; j <
> BTRFS_SUPER_MIRROR_MAX; j++) { +		u64 sb_offset =
> btrfs_sb_offset(j); +		u64 size = sb_offset - start; + +		if
> (!in_range(sb_offset, start, bytes_left)) +			continue; + +		if
> (size) { +			ret = blkdev_issue_discard(bdev, start >> 9, size >>
> 9, +						   GFP_NOFS, 0); +			if (!ret) +				*discarded_bytes +=
> size; +			else if (ret != -EOPNOTSUPP) +				return ret; +		} + +
> start = sb_offset + BTRFS_SUPER_INFO_SIZE; +		if (start > len) +
> start = len; +		bytes_left = len - start; +		skipped +=
> BTRFS_SUPER_INFO_SIZE;

Whoops. This is an unused artifact from an earlier version.

- -Jeff

> +	} + +	if (bytes_left) { +		ret = blkdev_issue_discard(bdev, start
> >> 9, bytes_left >> 9, +					   GFP_NOFS, 0); +		if (!ret) +
> *discarded_bytes += bytes_left; +	} +	return ret; }
> 
> int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr, @@
> -1906,16 +1943,17 @@ int btrfs_discard_extent(struct btrfs_root
> *root, u64 bytenr, struct btrfs_bio_stripe *stripe =
> bbio->stripes; int i;
> 
> - for (i = 0; i < bbio->num_stripes; i++, stripe++) { +			u64
> bytes; + if (!stripe->dev->can_discard) continue;
> 
> ret = btrfs_issue_discard(stripe->dev->bdev, stripe->physical, -
> stripe->length); +						  stripe->length, &bytes); if (!ret) -
> discarded_bytes += stripe->length; +				discarded_bytes += bytes; 
> else if (ret != -EOPNOTSUPP) break; /* Logic errors or -ENOMEM, or
> -EIO but I don't know how that could happen JDM */
> 
> 


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJVeahbAAoJEB57S2MheeWyA3YP/00sK18TqJi6ohu0l18otsd2
vG2lAtPUDT6f4dFM1GvO4PYLssuwm0Vy98qFYO30lvcHbdbajhsGd1qk+IzEq3Dr
+Qxze9lIrX8267nRE3aqu1I8/y2Gn5Wcy5Xr6fwhN0g+m5J+fWZHy1mfTvqbNt+M
U7Cg4hgvTFDcuV5adrg3JoQ3W/w6IvgIid27oNZ0MJMaK4f2jcLfmhGVCTcCnydp
7fEUsMow2firGJew7161ORYkYjTn76JW2HXB8ETOgWUcMpZon1KWduVXOTD0r9sk
UrfMJ8dLw6334T265gmQrBXvb3yOBLbyRYuksUFhXFUo1/xDSQMLGMBrkEf6T/Vo
mwnXVw5hnPM41vZiJ4Pc56vg1Yy4JGMXs28XEyHrj7gQWo3b1jRw0YhosZE/TR5+
BsJb4KqBTPor/upPLmDwIOYU4Ia+GZ5V2k1jYsE9qs6khHXlX9is8WHeB/fMzfCe
zkZEl8YI3ek50wXcqBk+QHFj8LT89Eyq59O3iaCFceIhvjO87ldRDBtTtBR34ogf
mZphx9UzVTcY31wftDYKMMi2Xs+8BZgXq7H7IXc2muugFlK9AGsMv4iXPbVkmUmE
T4pS2vKqCwfkW9bGf7ufQaOpVgwzQjDkC/Ngtybl8sULroOjI3lm6p+2/jMuqyYd
twV2FaYAJAI/tiQkTken
=1g/b
-----END PGP SIGNATURE-----

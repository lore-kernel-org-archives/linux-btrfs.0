Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42604 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752790AbdHISPa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Aug 2017 14:15:30 -0400
Date: Wed, 9 Aug 2017 18:15:29 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs: fix out of bounds array access while reading
 extent buffer
Message-ID: <20170809181529.GE7140@carfax.org.uk>
References: <20170807193903.9093-1-bo.li.liu@oracle.com>
 <20170809171016.7501-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SwLo357mIESq0V3a"
In-Reply-To: <20170809171016.7501-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--SwLo357mIESq0V3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 09, 2017 at 11:10:16AM -0600, Liu Bo wrote:
> There is a cornel case that slip through the checkers in functions
             ^^^^^^ corner

   Sorry, that's been bugging me every time it goes past. A cornel is
a kind of tree, apparently.

   Hugo.

> reading extent buffer, ie.
> 
> if (start < eb->len) and (start + len > eb->len),
> then
> 
> a) map_private_extent_buffer() returns immediately because
> it's thinking the range spans across two pages,
> 
> b) and the checkers in read_extent_buffer(), WARN_ON(start > eb->len)
> and WARN_ON(start + len > eb->start + eb->len), both are OK in this
> corner case, but it'd actually try to access the eb->pages out of
> bounds because of (start + len > eb->len).
> 
> The case is found by switching extent inline ref type from shared data
> ref to non-shared data ref, which is a kind of metadata corruption.
> 
> It'd use the wrong helper to access the eb,
> eg. btrfs_extent_data_ref_root(eb, ref) is used but the %ref passing
> here is "struct btrfs_shared_data_ref".  And if the extent item
> happens to be the first item in the eb, then offset/length will get
> over eb->len which ends up an invalid memory access.
> 
> This is adding proper checks in order to avoid invalid memory access,
> ie. 'general protection fault', before it's too late.
> 
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> 
> v3: Remove the unnecessary ASSERT and num_pages.
> 
> v2: Improve the commit log to clarify that this can only happen if
> metadata is corrupted.
> 
>  fs/btrfs/extent_io.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 0aff9b2..e6c6853 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -5417,8 +5417,12 @@ void read_extent_buffer(struct extent_buffer *eb, void *dstv,
>  	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
>  	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
>  
> -	WARN_ON(start > eb->len);
> -	WARN_ON(start + len > eb->start + eb->len);
> +	if (start + len > eb->len) {
> +		WARN(1, KERN_ERR "btrfs bad mapping eb start %llu len %lu, wanted %lu %lu\n",
> +		     eb->start, eb->len, start, len);
> +		memset(dst, 0, len);
> +		return;
> +	}
>  
>  	offset = (start_offset + start) & (PAGE_SIZE - 1);
>  
> @@ -5491,6 +5495,12 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
>  	unsigned long end_i = (start_offset + start + min_len - 1) >>
>  		PAGE_SHIFT;
>  
> +	if (start + min_len > eb->len) {
> +		WARN(1, KERN_ERR "btrfs bad mapping eb start %llu len %lu, wanted %lu %lu\n",
> +		       eb->start, eb->len, start, min_len);
> +		return -EINVAL;
> +	}
> +
>  	if (i != end_i)
>  		return 1;
>  
> @@ -5502,12 +5512,6 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
>  		*map_start = ((u64)i << PAGE_SHIFT) - start_offset;
>  	}
>  
> -	if (start + min_len > eb->len) {
> -		WARN(1, KERN_ERR "btrfs bad mapping eb start %llu len %lu, wanted %lu %lu\n",
> -		       eb->start, eb->len, start, min_len);
> -		return -EINVAL;
> -	}
> -
>  	p = eb->pages[i];
>  	kaddr = page_address(p);
>  	*map = kaddr + offset;

-- 
Hugo Mills             | Jazz is the sort of music where no-one plays
hugo@... carfax.org.uk | anything the same way once.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--SwLo357mIESq0V3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZi1FBAAoJEFheFHXiqx3kqUAP/RaLlWFjue1Ph+CrzPC+Ipo4
AZqTTV2vdkvmrDaH2cRv8nSxNbP70r08mgWPyvi538G6bz6hJNuPPHJMei5+XsRo
0SO9YiaJN5dNylzadHJxDh95XyJLrcfKFi9ejRifHEz8fexEWbTcwKEhDPHeS+ak
mVJOdn+wC03zRhR7uqU/LYXOsStTDk54ugGRCRF1oafMc5imaM2iSOHlJYlqGnii
uWjTz+Ks6Y1SUPwfN/x29cBvnGYKPB5W7OOEfAMan3ZQQzdKdXj2YDamLulCciH4
RZcl1WIc9oGDxYWZLJX7c8MXJc4EZ66TCahX7BQRAMTDyRK6mcc05jyb13nvdjLI
gloHaLPFaDyJoz3LAt3iQ1o3jKVAr+U0dWZZgY4LRhDaYl10DJi3fQ3Uxw75WBhg
FjbcsgcaBHmBOYJ81734/7uU6f+HpEji/NcKKoBj6ycW8ovl/TBo/YUw4wOmA1wm
10YVMfXc3b5T6x77K6nDu3n9Zg94UdlUNDOme2+GSb9ERUZ3sKtwBAa/A9SuDTBB
QyHOT2peMIHD/xlJfIsNk4uuat4l3YdYwGlREy8l3nmWH5EMFcJMob8tzB2hWUMT
6v6NlZLAj/s/gP6jLVw/Lx/mKD96hubrlt3w4fOWFVCzy1T692Ev+nvSZefPEtjf
ha1hwSDAK7RL4zKX3pkR
=aRJl
-----END PGP SIGNATURE-----

--SwLo357mIESq0V3a--

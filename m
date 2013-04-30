Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57354 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760050Ab3D3Oft (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 10:35:49 -0400
Date: Tue, 30 Apr 2013 15:35:42 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add debug check for extent_io range alignment
Message-ID: <20130430143542.GE8274@carfax.org.uk>
References: <1367332184-13367-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N1GIdlSm9i+YlY4t"
In-Reply-To: <1367332184-13367-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--N1GIdlSm9i+YlY4t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 30, 2013 at 04:29:44PM +0200, David Sterba wrote:
> The 'end' value must exactly cover the end of the interval, which means
> one byte less than the expected block alignment, or in case of a file
> smaller than one block, one byte less than the inode size.

   If that's actually the case, then the error message needs to use
"]" not ")" to close the interval. Using ")" would imply that the end
value is one past the end of the interval in question.

   Hugo.

> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  fs/btrfs/extent_io.c |   27 +++++++++++++++++++++++++++
>  1 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index c4949f1..6f6beda 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -76,10 +76,29 @@ void btrfs_leak_debug_check(void)
>  		kmem_cache_free(extent_buffer_cache, eb);
>  	}
>  }
> +
> +#define btrfs_debug_check_extent_io_range(inode, start, end)		\
> +	__btrfs_debug_check_extent_io_range(__func__, (inode), (start), (end))
> +static inline void __btrfs_debug_check_extent_io_range(const char *caller,
> +		struct inode *inode, u64 start, u64 end)
> +{
> +	u64 isize = i_size_read(inode);
> +
> +	if (end >= PAGE_SIZE && (end % 2) == 0 && end != isize - 1) {
> +		printk_ratelimited(KERN_DEBUG
> +		    "btrfs: %s: ino %llu isize %llu odd range [%llu,%llu)\n",
> +				caller,
> +				(unsigned long long)btrfs_ino(inode),
> +				(unsigned long long)isize,
> +				(unsigned long long)start,
> +				(unsigned long long)end);
> +	}
> +}
>  #else
>  #define btrfs_leak_debug_add(new, head)	do {} while (0)
>  #define btrfs_leak_debug_del(entry)	do {} while (0)
>  #define btrfs_leak_debug_check()	do {} while (0)
> +#define btrfs_debug_check_extent_io_range(c, s, e)	do {} while (0)
>  #endif
>  
>  #define BUFFER_LRU_MAX 64
> @@ -509,6 +528,8 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
>  	int err;
>  	int clear = 0;
>  
> +	btrfs_debug_check_extent_io_range(tree->mapping->host, start, end);
> +
>  	if (delete)
>  		bits |= ~EXTENT_CTLBITS;
>  	bits |= EXTENT_FIRST_DELALLOC;
> @@ -664,6 +685,8 @@ static void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
>  	struct extent_state *state;
>  	struct rb_node *node;
>  
> +	btrfs_debug_check_extent_io_range(tree->mapping->host, start, end);
> +
>  	spin_lock(&tree->lock);
>  again:
>  	while (1) {
> @@ -756,6 +779,8 @@ __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
>  	u64 last_start;
>  	u64 last_end;
>  
> +	btrfs_debug_check_extent_io_range(tree->mapping->host, start, end);
> +
>  	bits |= EXTENT_FIRST_DELALLOC;
>  again:
>  	if (!prealloc && (mask & __GFP_WAIT)) {
> @@ -976,6 +1001,8 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
>  	u64 last_start;
>  	u64 last_end;
>  
> +	btrfs_debug_check_extent_io_range(tree->mapping->host, start, end);
> +
>  again:
>  	if (!prealloc && (mask & __GFP_WAIT)) {
>  		prealloc = alloc_extent_state(mask);

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Is it true that "last known good" on Windows XP ---         
                            boots into CP/M?                             

--N1GIdlSm9i+YlY4t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUX/WvlheFHXiqx3kAQLUJBAAgUF8Qxg4nJA2Vs6mZ0bQLozjLMKYniJh
Ik7hcJlaF2v2Dd3oXOMhyXBbIIGK9T3uYVF98TXyVLU/npUbpZzfL6tKQxBLHvve
Nzg8xwI3Bzn597A+7EJ8BAApAZpoTVZ4JnWygGQOqPvqkQrcRP++irZMNNvFc8PG
kPE2O6WNvFk4WBsLwLIJNvP9Z6ojnvwlbxzKzgfzI4nu0u2SlU/WWYEPbFvgr/ip
BK249ex6/Yu7T1QO4YRuMMgXnCblpFltNeCBx3gw1jzNwDSuGbMAAxzZkBJiw3Cn
+itDlIITZYl4TPYtsk9i0sXIMCsBLefd1UKks0d6EOpQGcRwZCy6MiIyT2ErHCDk
ZAWBfwHqIvlyi79Q5HDSHUXrq5XFMmopprohCyfEKXQ2jvQkO2KNJBtDSop7IEBp
a0msUlKUhKzLjgDkNojQgvQf9tDC5611d5yEWtDXggIHcVO1av6aWNSzAxW4hsDT
9dL6AGFetQ3js9j29GuZs+9RMz0DGSQsQWLKwbTcRa5yckovCHAoLzfsTjSzQRlp
EhnNyCPpyoqehLb9Dh+5IU6k8rjTgo24IrzvOn9/H3dlI6LZWzrQncHodM5FXloP
D9OGzr0WsKJf4WCNgn+rVzdZdiPLX0HACOB56bL3fsjDulHHBbupV5MJwhLpDYFm
mLR4vdwfR3A=
=QJ0Q
-----END PGP SIGNATURE-----

--N1GIdlSm9i+YlY4t--

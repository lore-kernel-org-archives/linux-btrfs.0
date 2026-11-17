Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794949627;
	b=zaA+Qx0nHs3CqybFDY45zbEk4SeJkD8SU6Jl4k30sFc67KbF+Fb7MbHV4crsCGM0xfdt
	 EBmjq3gsmXj1Rg0CEEbo9oD1BJ7mp/djqTeDbyOicxeuVUYimSfDVR6uEqDhU4icG6ZjA
	 45uMdg9/HcDiJDbFWQvg2ahJt+91SeWez2Y270LKy3dqCF86FFUWlz6SHRfRqCkd/2tS9
	 X3fIbhfwBnkRWiLLHlDHvjL8EksTODLXE/8aePRwr5+Ytqr4v2wXhEC9EzipqT6WKmHkr
	 WywaLDQl39gVp5BW/MCLmtTjcgja5B9PwiRZxkTCwL3+RjixwnAZ3cuxvG+3YV3H+uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794949627;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=+mtfIwajnODtBFaBaUfN1bsti9GZifU3MXsCulSORZg=;
	b=JOu6iv3netYtxSsbpAQ+Fd8ovha7UPvqbPxXo92YiwtCDg/QE7bFotLC5+KoMV5Kqw6A
	 ylDBK2M4LnbPvBm0RbsU/vlX1eEDDLZ8DSZrtu9VK+1YwYTOUHpDbszQaK5RBofv07g8v
	 rba7nY8nf3PKMHAhus4XfiK6s2flc3Rmqh0uvQvMkq7Vx23DMzGwt0lCMbWKHhDXerU5e
	 voegc9AKj1sUm0zGI8Ks1K+rcUku8iforetD76hHp1djlXH4eZH0MOSrh31JCbIKWF7WQ
	 xPlalP8P8ghrwmIIz8f4V+LuBRklywbIkj0MKlc9PP9/03xeCaC/ZWrNXgX1vmJgUtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XUEgztUn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5C1606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 21:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XUEgztUn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1DA1F000C4;
	Tue, 17 Nov 2026 21:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794949626;
	bh=+mtfIwajnODtBFaBaUfN1bsti9GZifU3MXsCulSORZg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XUEgztUnaeiZzhYudd0qWybi0Z5pzoFZom4ImXtqrGTVhlIW+Bn7wBtZgXTerPAut
	 GcPUTQqRziCT9sHkNWcYCYkhfraUjvjStjjdtKL5di5UV+mfXF1RDC66LgzbZ9bDJg
	 Rv5CW6HmalO6+VC7x97jfAnX0fLWTj9OIm20g7sdWnlWSjtEn6K93iECDjT0izNprs
	 mh2KQqUyXIR9+bfdeq5gf4gGT+0eXrLNpZM7DhgR3R2UnXgaHtoc/9VGm9HMwMhNh6
	 ZGLBF1Eg5Jfp9EehBfYSqcVWlyEoWlE+/86I7fspSlODBmULk73+Z1bkSJPfJRWqgq
	 91AngpgX7AS3A==
Message-ID: <34e278a6-37f5-46bb-8344-1ea32e60bebb@kernel.org>
Date: Tue, 17 Nov 2026 13:07:05 -0800
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 01/27] btrfs: zoned: don't wait for a zone finish after
 a filesystem error
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>, David Sterba <dsterba@suse.com>,
 Boris Burkov <boris@bur.io>
References: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
 <20261117185850.4128157-2-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261117185850.4128157-2-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/17/26 10:58, Johannes Thumshirn wrote:
> When no zone can be activated, buffered writeback in cow_file_range() and
> direct IO in btrfs_new_extent_direct() wait uninterruptibly for
> BTRFS_FS_NEED_ZONE_FINISH to be cleared, which only happens once a zone
> is finished.
> 
> After a transaction abort or an emergency shutdown no zone gets finished
> anymore, so the waiters sleep forever. With writeback holding locked
> folios, btrfs_cleanup_transaction() then blocks in
> invalidate_inode_pages2_range() as well. generic/388 hangs this way.
> 
> Clear the bit and wake the waiters when the filesystem error is set,
> clear it again if it gets set after an error was recorded, and let the
> waiters bail out with the filesystem error.
> 
> Fixes: 2ce543f47843 ("btrfs: zoned: wait until zone is finished when allocation didn't progress")
> Fixes: 776a838f1fa9 ("btrfs: zoned: wait for data BG to be finished on direct IO allocation")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/direct-io.c |  4 +++-
>  fs/btrfs/fs.h        |  1 +
>  fs/btrfs/inode.c     |  3 +++
>  fs/btrfs/messages.c  |  1 +
>  fs/btrfs/zoned.c     | 10 +++++++++-
>  5 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 2cad9f048f4a..7bf048dfced6 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -191,7 +191,9 @@ static struct extent_map *btrfs_new_extent_direct(struct btrfs_inode *inode,
>  		ASSERT(btrfs_is_zoned(fs_info));
>  		wait_on_bit_io(&inode->root->fs_info->flags, BTRFS_FS_NEED_ZONE_FINISH,
>  			       TASK_UNINTERRUPTIBLE);
> -		goto again;
> +		ret = BTRFS_FS_ERROR(fs_info);
> +		if (likely(!ret))
> +			goto again;
>  	}
>  	if (ret)
>  		return ERR_PTR(ret);
> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> index 2dd167c32d61..84a6eb2ebf83 100644
> --- a/fs/btrfs/fs.h
> +++ b/fs/btrfs/fs.h
> @@ -1232,6 +1232,7 @@ static inline void btrfs_force_shutdown(struct btrfs_fs_info *fs_info)
>  	 * So here we only mark the fs error without flipping it RO.
>  	 */
>  	WRITE_ONCE(fs_info->fs_error, -EIO);
> +	clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
>  	if (!test_and_set_bit(BTRFS_FS_STATE_EMERGENCY_SHUTDOWN, &fs_info->fs_state)) {
>  		btrfs_crit(fs_info, "emergency shutdown");
>  		fserror_report_shutdown(fs_info->sb, GFP_KERNEL);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 4b29b82eb180..319488794320 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1409,6 +1409,9 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
>  				wait_on_bit_io(&inode->root->fs_info->flags,
>  					       BTRFS_FS_NEED_ZONE_FINISH,
>  					       TASK_UNINTERRUPTIBLE);
> +				ret = BTRFS_FS_ERROR(fs_info);
> +				if (unlikely(ret))
> +					goto out_unlock;
>  				continue;
>  			}
>  			if (done_offset) {
> diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
> index 73acb69c3849..2722751401b0 100644
> --- a/fs/btrfs/messages.c
> +++ b/fs/btrfs/messages.c
> @@ -163,6 +163,7 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function
>  	 * send it down to the disk.
>  	 */
>  	WRITE_ONCE(fs_info->fs_error, error);
> +	clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
>  
>  	/* Don't go through full error handling during mount. */
>  	if (!(sb->s_flags & SB_BORN))
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index b1be02eeba68..ca0aedb916bf 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2773,8 +2773,16 @@ bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
>  	spin_unlock(&fs_info->zone_active_bgs_lock);
>  	mutex_unlock(&fs_info->chunk_mutex);
>  
> -	if (!ret)
> +	if (!ret) {
>  		set_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
> +		/*
> +		 * No zone gets finished after a filesystem error, don't let
> +		 * anybody wait for it. Pairs with the clear in the error paths.
> +		 */
> +		smp_mb__after_atomic();

Looks good to me, but inserting the comment block here between the set_bit() and
smp_mb__after_atomic() is odd looking. I would keep these together as they
should be.

The comment describes why the "if" is here, so let' move it right before it.
Also, the comment would be nicer as:

		/*
		 * No zone gets finished after a filesystem error, so do not let
		 * anybody wait for it. This pairs with the clear in the error
		 * path.
		 */


s/error, don't let/error, so do not let

> +		if (unlikely(BTRFS_FS_ERROR(fs_info)))
> +			clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
> +	}
>  
>  	return ret;
>  }


-- 
Damien Le Moal
Western Digital Research

Received: from out198-150.us.a.mail.aliyun.com (out198-150.us.a.mail.aliyun.com [47.90.198.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDFC2FE071
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 23:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.198.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779753360; cv=none; b=ldYqhUvDfzIhBCpvV++FiAPO1p0dpRFGujiyeSAaJjZCli+4fLYjHRgt2NvBqP/8EqxRejwSPP3kCq8pSJMjkuixlQCOKuJaFtZfUQxMQXpoj/B/wi6fdB/fGkHmvMNCervb4z9G+5BbYkxjj6XSeyUsMpA0UU+kwryJP+aPIgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779753360; c=relaxed/simple;
	bh=z+PAblZ6e4DM3G7rEujDcx4E3lvQ8VwT62fuaakYovk=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:Message-Id:
	 MIME-Version:Content-Type; b=X5hagNkb6qtsZHSK4Mnoue/tWrf/H5FK3BQhaRUKHti1hOKICc1emAg4qlp18tD3/iflxSicmLOhzeZX5x+UixVfs0/weAJztc1MHfPGnXOyjGRRWw5xqCIo+gdTRg9g3xGamCce9yTAb4uEdUx/lwF4CXQOGLE7Wpc1WdH4MWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=47.90.198.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.04438603|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0121891-0.00011477-0.987696;FP=5255740576341562554|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037031241;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.hglMi1r_1779753338;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.hglMi1r_1779753338 cluster:ay29)
          by smtp.aliyun-inc.com;
          Tue, 26 May 2026 07:55:38 +0800
Date: Tue, 26 May 2026 07:55:38 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH v2] btrfs: use IOMAP_DIO_BOUNCE flag instead of falling back to buffered IO
Cc: linux-btrfs@vger.kernel.org
In-Reply-To: <e578ff1a2dd9a4f720ea77bc601534734ce87e18.1779685479.git.wqu@suse.com>
References: <e578ff1a2dd9a4f720ea77bc601534734ce87e18.1779685479.git.wqu@suse.com>
Message-Id: <20260526075538.BA75.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.83.02 [en]

Hi,


> Previously btrfs forces direct writes to fall back to buffered ones if the
> inode has data checksum or the profile has duplication.
> 
> That fallback is to avoid the content being modified that the final
> content may mismatch with the checksum or the other mirrors.
> 
> That brings a pretty huge performance cost, which already caused some
> concern at that time.
> 
> But later upstream commit c9d114846b38 ("iomap: add a flag to bounce
> buffer direct I/O") introduced a new method by copying the content into
> new pages, and do all the operations based on the newly allocated pages.
> 
> So let btrfs to utilize the new flag for direct writes if we require
> stable folios.
> 
> There is a quick benchmark, using the following fio setup:
> 
>  fio --name=randwrite --filename $mnt/foobar --ioengine=libaio --size=4G \
>      --rw=randwrite --iodepth=64 --runtime=60 --time_based --direct=1 \
>      --bs=$blocksize
> 
> Unit is MiB/s.
> 
>  Blocksize | Zero-copy (*) | Buffered |   Bounce
> -----------+---------------+----------+-----------
>         4K |          35.1 |     17.1 |      33.8
>        64K |           522 |      251 |       492
> 
> *: This is done by reverting the commit 968f19c5b1b7 ("btrfs: always
>    fallback to buffered write if the inode requires checksum")
> 
> Although with page bouncing the performance is only around 95% of
> true-zero copy, it's still almost double the performance of buffered
> fallback.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Rework the comment in btrfs_dio_write()
> ---
>  fs/btrfs/direct-io.c | 45 ++++++++++++++++----------------------------
>  1 file changed, 16 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 57167d56dc72..173fe065fc38 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -768,10 +768,25 @@ static ssize_t btrfs_dio_read(struct kiocb *iocb, struct iov_iter *iter,
>  static struct iomap_dio *btrfs_dio_write(struct kiocb *iocb, struct iov_iter *iter,
>  					 size_t done_before)
>  {
> +	struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
>  	struct btrfs_dio_data data = { 0 };
> +	const u64 data_profile = btrfs_data_alloc_profile(inode->root->fs_info) &
> +				 BTRFS_BLOCK_GROUP_PROFILE_MASK;
> +	unsigned int dio_flags = IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIGNED;
> +
> +	/*
> +	 * Userspace may modify the buffer while DIO is in flight. With
> +	 * data checksumming this would produce a checksum that doesn't
> +	 * match the persisted data; with duplicated profiles the mirrors
> +	 * would diverge. Bounce in those cases so writeback sees stable
> +	 * content.
> +	 */
> +	if (!(inode->flags & BTRFS_INODE_NODATASUM) ||
> +	    (data_profile != BTRFS_BLOCK_GROUP_RAID0 && data_profile != 0))
> +		dio_flags |= IOMAP_DIO_BOUNCE;
>  
>  	return __iomap_dio_rw(iocb, iter, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
> -			    IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIGNED, &data, done_before);
> +			      dio_flags, &data, done_before);
>  }
>  
>  static ssize_t check_direct_IO(struct btrfs_fs_info *fs_info,
> @@ -800,8 +815,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>  	ssize_t ret;
>  	unsigned int ilock_flags = 0;
>  	struct iomap_dio *dio;
> -	const u64 data_profile = btrfs_data_alloc_profile(fs_info) &
> -				 BTRFS_BLOCK_GROUP_PROFILE_MASK;
>  
>  	if (iocb->ki_flags & IOCB_NOWAIT)
>  		ilock_flags |= BTRFS_ILOCK_TRY;
> @@ -815,16 +828,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>  	if (iocb->ki_pos + iov_iter_count(from) <= i_size_read(inode) && IS_NOSEC(inode))
>  		ilock_flags |= BTRFS_ILOCK_SHARED;
>  
> -	/*
> -	 * If our data profile has duplication (either extra mirrors or RAID56),
> -	 * we can not trust the direct IO buffer, the content may change during
> -	 * writeback and cause different contents written to different mirrors.
> -	 *
> -	 * Thus only RAID0 and SINGLE can go true zero-copy direct IO.
> -	 */
> -	if (data_profile != BTRFS_BLOCK_GROUP_RAID0 && data_profile != 0)
> -		goto buffered;
> -
>  relock:
>  	ret = btrfs_inode_lock(BTRFS_I(inode), ilock_flags);
>  	if (ret < 0)
> @@ -865,22 +868,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>  		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
>  		goto buffered;
>  	}
> -	/*
> -	 * We can't control the folios being passed in, applications can write
> -	 * to them while a direct IO write is in progress.  This means the
> -	 * content might change after we calculated the data checksum.
> -	 * Therefore we can end up storing a checksum that doesn't match the
> -	 * persisted data.
> -	 *
> -	 * To be extra safe and avoid false data checksum mismatch, if the
> -	 * inode requires data checksum, just fallback to buffered IO.
> -	 * For buffered IO we have full control of page cache and can ensure
> -	 * no one is modifying the content during writeback.
> -	 */
> -	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
> -		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
> -		goto buffered;
> -	}
>  
>  	/*
>  	 * The iov_iter can be mapped to the same file range we are writing to.

Do we need this too just like xfs?

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index fa82def46e39..64eae7417242 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3843,7 +3843,7 @@ const struct file_operations btrfs_file_operations = {
 #endif
 	.remap_file_range = btrfs_remap_file_range,
 	.uring_cmd	= btrfs_uring_cmd,
-	.fop_flags	= FOP_BUFFER_RASYNC | FOP_BUFFER_WASYNC,
+	.fop_flags	= FOP_BUFFER_RASYNC | FOP_BUFFER_WASYNC | FOP_DONTCACHE,
 };
 
 int btrfs_fdatawrite_range(struct btrfs_inode *inode, loff_t start, loff_t end)

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2026/05/26




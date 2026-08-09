Received: from drax.kayaks.hungrycats.org (drax.kayaks.hungrycats.org [174.142.148.226])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06165331A56
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 20:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=174.142.148.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786306545; cv=none; b=XjKljNsUxItfmvqBH5j2w5bkWtgjPwdGerPQY7DAS1/H13MPhpNp1DXf8Kb0yu6o6Q+/A6/N2xRilbFSE2BlQemVx/A2YmMGhIXScjld2eePQjFIUWNLZWzIF6O5OUJBP/baJeFNoFw0kJr1sPcrhzncxE83qNDF5xV55O7910g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786306545; c=relaxed/simple;
	bh=XJ+TWQVwjps8YnQvQwvBXhEFxB6BAyTpCzDTgjT8HxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iiUmjk/fTO1pTJVWhjDBTFqNKCSBdkaFo3vKzLlR+CQzils5gVlRv3/t4kJ8OVlooto+9B4bRQbmnhnvQs6YmkHfteVp1DVSiYtYq2PbX+OJWiPtStWydZtVVtsG3gFMrQeZ4sn7rwJhY01yYOiHKHStoyvwmqOBuj2y8jK/AMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=umail.furryterror.org; spf=pass smtp.mailfrom=drax.hungrycats.org; arc=none smtp.client-ip=174.142.148.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=umail.furryterror.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=drax.hungrycats.org
Received: by drax.kayaks.hungrycats.org (Postfix, from userid 1002)
	id 275A01B1F2D9; Sun, 09 Aug 2026 16:15:43 -0400 (EDT)
Date: Sun, 9 Aug 2026 16:15:43 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: koraynilay <koray.fra@gmail.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/5] btrfs: fix -o compress= level getting inherited
 by compression xattr property
Message-ID: <anjf71ZUXUC4dd1W@hungrycats.org>
References: <20260809185303.600071-1-koray.fra@gmail.com>
 <20260809185303.600071-2-koray.fra@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260809185303.600071-2-koray.fra@gmail.com>

On Sun, Aug 09, 2026 at 08:52:59PM +0200, koraynilay wrote:
> When setting the btrfs.compression xattr, btrfs uses the mount option level
> (since levels in the xattr aren't supported yet) to compress the data, even
> if the compression algorithm between the property and the compress= option
> are different (!!).
> For example, when mounting with compress=zstd:15 and setting
> btrfs.compression=zlib, the data would get compressed at zlib:9, because
> btrfs would take "zlib" from the xattr but "15" from the mount option,
> which would then get correctly clamped at 9.
> 
> To fix, just hard-code the compress level at 0, forcing the property's
> algorithm default.
> 
> Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  fs/btrfs/inode.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 2534cd9284d5..6d7f2aa2555c 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -938,6 +938,7 @@ static void compress_file_range(struct btrfs_work *work)
>  		compress_level = inode->defrag_compress_level;
>  	} else if (inode->prop_compress) {
>  		compress_type = inode->prop_compress;
> +		compress_level = 0;

This set to zero should be conditional on inode->prop_compress !=
fs_info->compress_type; otherwise, it prevents the compress-level mount
option from working in the common case where 'btrfs.compression=zstd'
or 'chattr +c' has been set.

>  	}
>  
>  	/* Compression level is applied here. */
> @@ -2326,6 +2327,7 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
>  			compress_level = inode->defrag_compress_level;
>  		} else if (inode->prop_compress) {
>  			compress_type = inode->prop_compress;
> +			compress_level = 0;
>  		}
>  		cb = btrfs_compress_bio(inode, 0, blocksize, compress_type, compress_level, 0);
>  		if (IS_ERR(cb)) {
> -- 
> 2.55.0
> 
> 

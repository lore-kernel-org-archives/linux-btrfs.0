Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283B1366562
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 04:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782274815; cv=none; b=K1edEtji1rpvNVsztk+1gb8b/b7/Vvbk9cHDnahdC26BNyVBJehC4kn5Ati8mfp+ZiSATiifA8qBFbURGKFG3pE1K/hfP9sHOtSx7SvI3eIeqpgG+vcxIamMGogEYixiPxhL5cWkd/MLHuFFSHXjyjRaUVo7pbevqBETWkSdbOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782274815; c=relaxed/simple;
	bh=31LyMc8zp4RHzcuBoQwfIA/sDQ9nvb3tptPGVRsX8Wk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jYo15E85CKauLD7e4W7NSibwTKlCU9ATV+SExgVh7fSprDNvDqtVL98rcWK06dtX6v/Fw2rslGbqVxR1crCJbcYlypVI8VALAv4PWbk+bAzd1aIt2L21J+DIzmK1v97C7sAxsB++SLU85FxrKNfbuOWqpBua24rCKUCNXmVQ7WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=FSi8pfLw; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=gWAcBpF/; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="FSi8pfLw";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gWAcBpF/"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 6F7551D0011C;
	Wed, 24 Jun 2026 00:20:12 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 24 Jun 2026 00:20:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1782274812; x=1782361212; bh=Hk7pJM2HC0
	yANp3aYwGyfDLH4pktfgrToVEWkGo+Ot4=; b=FSi8pfLwROv2JrydhD9MQkAYj/
	cLaz5+qC0TTPS21SAEiGUj9bTwPAGccQRb2n0b9rT8duIns6Blk4uFtqx+bkUnIy
	QemGAGBSxeSU3e0e65h4SR2pJm0vJlARhztalirbApt+bhLz5iWc0OykHdnuMEr3
	m/C34hx71QjEeSHvaeSIJaSeyTVBo/0EMs5Pp8CQ36kW0f3iGPGzjmtyfJJE59S9
	daAXEF1XSR7BjTS3IkUknS25WC+I0sZyN7JZbQIEI5ElP/e4NTUqxmEdCKST++m5
	KASbMIvQP4791scJhaD7u1O8AQChaiM6jAShYvWxUah8gLk6YBO47lBOqtcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1782274812; x=1782361212; bh=Hk7pJM2HC0yANp3aYwGyfDLH4pktfgrToVE
	WkGo+Ot4=; b=gWAcBpF/uubwPg+ZbEDJjlHaxKKbUpqvTWyJygYmkq9yH4UlPiG
	lxELHrhxoGcjxCEO/2dJPuidgBLJ/vUujfI6sRgNWshb1Rvzsw4ggzR5Sp5zFdm/
	veFe6sqBTruXmR2fT8/KAtUHNFW1CNGR2QlMdup05+RUvwbFanytWBBDA9vYPM27
	7LhPd+WDRIBGkfIcubXZfjyx4O02zUDZb2pnhlK8WXUzRyPaJadBAxxK4SaTpkkz
	qjKv9DL0SZ/ouGC2STwExPAjJ8sTxlnPLR5otyZO9G8ZulrEDNsd4EqqKiP9z79X
	TEirJJcYjmOsf/3X44PelzyIWtXVOl7Y4+w==
X-ME-Sender: <xms:_Fo7arPCuEJP6OIIJoZe9xewjiOz8VIAZMT2iAT7ICl_1Nv_DJ3noA>
    <xme:_Fo7ar9XL_c6UYDqq4ndSA8SY8JhnnUVeMIsFdJUakstGfYeRj37ibkqeKdpkeF85
    VTlyxmhbSEH8wDjIYLAN5LMoiNL6_LQe5puUxGSLA5Xi7LuyK2KTQ>
X-ME-Received: <xmr:_Fo7an7sWoLG1RJThfsxBXKHOoN4xUP6QJ1_tqViQRm0B2B2uUYjV9ASUWUiVzfCYrAOZZqQ7WV4rAEtSlRRJYd4_Cs>
X-ME-Proxy-Cause: dmFkZTFhdIeCN2gl5TILkaQsQGZYzrSVeJ1STTFFaneR7rRUsCBkZP+oZkaL+b5cSkwPyH
    tI87+pcXujbNXbe1UveMBuD6GFkjmDpzmmglTiCqyjNGrthHltpnUtEnOvIwFEJzMi2VmE
    BhPb3eSxigVYiaDkNyz0TAirih9AvMZDea6NQiT2Eec5Ipn7xN0pCgbvY9LQY6ZZdDIDac
    Tr1JeGr5bKZdr3peD90A8OLj2Y1c+n2YCYbas/5g8sWr9FXGo3Dz0lrRKwK6d9ef+DTvTy
    RSGLHneAqiqiE3mNtnicA3eHN2ap1QvM1UrsMBWs3eJ541b+IzjZTaYbtW+MSmvkHplSZq
    Sd1SlZGKXk5r2OSp15BqUySLQUIUp8BmjS6ud1A7JNPySxXR84hEJuAzraXFVv2MHCj11O
    i3TWfukNX+FT6tc+Dhqb/K/NjJb2YBVdjrxlLGgq6lgqtuZTRXi2RlA41kSDrT1LRweN+y
    /Ns7i8zTZ6iJKCPsS6oCD6i1XYCW29ro6bZIv0DOrbOEzXfI6NpsF2zrNUmcnplqWq8B31
    WMzVmzyWMrUOPmlavNmm2zgEkoPCkUnp4KiTGTL4dZsUeHV2w3KFlZous5sQ4K1qsfvEWU
    z1Gjd4u9641F3SksYXjAeXrpC+ntT9EkdPUVhvQM7XkdzHyFmmtQ2f9vVLOw
X-ME-Proxy: <xmx:_Fo7aq0uMqF0263cHmSobRe2dkpXNgUrumBI_G3ab5T21NvVvJB21Q>
    <xmx:_Fo7amDLj69s3IVaI2udJfg4_m-sIza2x6T2af4tW8Qmqyl-_pPHig>
    <xmx:_Fo7ak3DCUuKDLys0PI0_lCxnEVtqJBOtF5rHmjP9XDtqKQ5YIxBSA>
    <xmx:_Fo7aosIMGWl7NaNslKcXHVIWUwXaksG6p5JGKrQL-43zEAy2n9lIQ>
    <xmx:_Fo7at9wYau-IsaKHXmjpoXOuEngay1ff3OASsi6PvKFgLJ3E0vFfrxI>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 24 Jun 2026 00:20:11 -0400 (EDT)
Date: Tue, 23 Jun 2026 21:19:09 -0700
From: Boris Burkov <boris@bur.io>
To: Sun YangKai <sunk67188@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: change block group reclaim_mark to bool
Message-ID: <20260624041909.GA2011094@zen.localdomain>
References: <20260624040232.30420-1-sunk67188@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624040232.30420-1-sunk67188@gmail.com>

On Wed, Jun 24, 2026 at 12:02:27PM +0800, Sun YangKai wrote:
> The reclaim_mark field in struct btrfs_block_group was a u64 that was
> incremented when marking block groups for reclaim during sweeping, but
> the actual counter value was never used - only the zero/non-zero state
> mattered for determining if a block group needed reclaim.
> 
> Convert it to a bool to properly reflect its usage and reduce memory
> footprint by 8 bytes. Update assignments to use true/false instead of
> increment and zero.
> 

LGTM, thanks.
Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: Sun YangKai <sunk67188@gmail.com>
> ---
>  fs/btrfs/block-group.c | 2 +-
>  fs/btrfs/block-group.h | 7 ++++++-
>  fs/btrfs/space-info.c  | 2 +-
>  3 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index 9e937407d12a9..5829c806c4d48 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -3923,7 +3923,7 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
>  		old_val += num_bytes;
>  		cache->used = old_val;
>  		cache->reserved -= num_bytes;
> -		cache->reclaim_mark = 0;
> +		cache->reclaim_mark = false;
>  		space_info->bytes_reserved -= num_bytes;
>  		space_info->bytes_used += num_bytes;
>  		space_info->disk_used += num_bytes * factor;
> diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
> index 790c2d467af57..942befdf75df7 100644
> --- a/fs/btrfs/block-group.h
> +++ b/fs/btrfs/block-group.h
> @@ -263,6 +263,12 @@ struct btrfs_block_group {
>  
>  	enum btrfs_block_group_size_class size_class:8;
>  
> +	/*
> +	 * Mark this blockgroup is not used for allocation
> +	 * between two reclaim sweeps.

nit: this grammar doesn't parse great to me. Maybe drop "Mark"?
or change it to "We identified this for reclaim on a previous pass, so
it stably needs reclaim across passes" or something like that.

> +	 */
> +	bool reclaim_mark;
> +
>  	/*
>  	 * Number of extents in this block group used for swap files.
>  	 * All accesses protected by the spinlock 'lock'.
> @@ -281,7 +287,6 @@ struct btrfs_block_group {
>  	struct list_head active_bg_list;
>  	struct work_struct zone_finish_work;
>  	struct extent_buffer *last_eb;
> -	u64 reclaim_mark;
>  };
>  
>  static inline u64 btrfs_block_group_end(const struct btrfs_block_group *block_group)
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index e6641597b321e..39a28e1bec8ad 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -2156,7 +2156,7 @@ static bool do_reclaim_sweep(struct btrfs_space_info *space_info, int raid)
>  			will_reclaim = true;
>  			reclaim = true;
>  		}
> -		bg->reclaim_mark++;
> +		bg->reclaim_mark = true;
>  		spin_unlock(&bg->lock);
>  		if (reclaim)
>  			btrfs_mark_bg_to_reclaim(bg);
> -- 
> 2.54.0
> 

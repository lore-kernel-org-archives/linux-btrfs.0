Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127AbcEQNUs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 09:20:48 -0400
Date: Tue, 17 May 2016 15:20:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v10 10/21] btrfs: try more times to alloc metadata
 reserve space
Message-ID: <20160517132016.GQ511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1459492512-31435-11-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459492512-31435-11-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 02:35:01PM +0800, Qu Wenruo wrote:
> @@ -5815,6 +5817,23 @@ out_fail:
>  	}
>  	if (delalloc_lock)
>  		mutex_unlock(&BTRFS_I(inode)->delalloc_mutex);
> +	/*
> +	 * The number of metadata bytes is calculated by the difference
> +	 * between outstanding_extents and reserved_extents. Sometimes though
> +	 * reserve_metadata_bytes() fails to reserve the wanted metadata bytes,
> +	 * indeed it has already done some work to reclaim metadata space, hence
> +	 * both outstanding_extents and reserved_extents would have changed and
> +	 * the bytes we try to reserve would also has changed(may be smaller).
> +	 * So here we try to reserve again. This is much useful for online
> +	 * dedupe, which will easily eat almost all meta space.
> +	 *
> +	 * XXX: Indeed here 3 is arbitrarily choosed, it's a good workaround for
> +	 * online dedupe, later we should find a better method to avoid dedupe
> +	 * enospc issue.
> +	 */
> +	if (unlikely(ret == -ENOSPC && loops++ < 3))
> +		goto again;
> +

This does not seem right and needs to be addressed properly before I
consider adding the patchset to for-next. I don't have idea how to fix
it.

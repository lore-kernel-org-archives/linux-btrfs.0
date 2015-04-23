Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33034 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbbDWMQb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 08:16:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YlG3R-0003mD-QR
	for linux-btrfs@vger.kernel.org; Thu, 23 Apr 2015 14:16:29 +0200
Received: from p4ff58852.dip0.t-ipconnect.de ([79.245.136.82])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 14:16:29 +0200
Received: from holger.hoffstaette by p4ff58852.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 14:16:29 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH] Btrfs: fix race when reusing stale extent buffers that
 leads to BUG_ON
Date: Thu, 23 Apr 2015 12:16:21 +0000 (UTC)
Message-ID: <pan.2015.04.23.12.16.21@googlemail.com>
References: <1429784928-12665-1-git-send-email-fdmanana@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 23 Apr 2015 11:28:48 +0100, Filipe Manana wrote:

> There's a race between releasing extent buffers that are flagged as stale
> and recycling them that makes us it the following BUG_ON at
> btrfs_release_extent_buffer_page:
> 
>     BUG_ON(extent_buffer_under_io(eb))
> 
> The BUG_ON is triggered because the extent buffer has the flag
> EXTENT_BUFFER_DIRTY set as a consequence of having been reused and made
> dirty by another concurrent task.

Awesome analysis!

> @@ -4768,6 +4768,25 @@ struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
>  			       start >> PAGE_CACHE_SHIFT);
>  	if (eb && atomic_inc_not_zero(&eb->refs)) {
>  		rcu_read_unlock();
> +		/*
> +		 * Lock our eb's refs_lock to avoid races with
> +		 * free_extent_buffer. When we get our eb it might be flagged
> +		 * with EXTENT_BUFFER_STALE and another task running
> +		 * free_extent_buffer might have seen that flag set,
> +		 * eb->refs == 2, that the buffer isn't under IO (dirty and
> +		 * writeback flags not set) and it's still in the tree (flag
> +		 * EXTENT_BUFFER_TREE_REF set), therefore being in the process
> +		 * of decrementing the extent buffer's reference count twice.
> +		 * So here we could race and increment the eb's reference count,
> +		 * clear its stale flag, mark it as dirty and drop our reference
> +		 * before the other task finishes executing free_extent_buffer,
> +		 * which would later result in an attempt to free an extent
> +		 * buffer that is dirty.
> +		 */
> +		if (test_bit(EXTENT_BUFFER_STALE, &eb->bflags)) {
> +			spin_lock(&eb->refs_lock);
> +			spin_unlock(&eb->refs_lock);
> +		}
>  		mark_extent_buffer_accessed(eb, NULL);
>  		return eb;
>  	}

After staring at this (and the Lovecraftian horrors of free_extent_buffer())
for over an hour and trying to understand how and why this could even remotely
work, I cannot help but think that this fix would shift the race to the much
smaller window between the test_bit and the first spin_lock.
Essentially you subtly phase-shifted all participants and make them avoid the
race most of the time, yet I cannot help but think it's still there (just much
smaller), and could strike again with different scheduling intervals.

Would this be accurate?

-h


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38300 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726210AbeG3Ivo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jul 2018 04:51:44 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F27C6AF52
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jul 2018 07:18:06 +0000 (UTC)
Subject: Re: [PATCH 1/1] btrfs: locking: Allow btrfs_tree_lock() to return
 error to avoid deadlock
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180730061723.13290-1-wqu@suse.com>
 <20180730061723.13290-2-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <66cf31bb-126f-68d7-83ee-c4214c6129c1@suse.com>
Date: Mon, 30 Jul 2018 10:18:05 +0300
MIME-Version: 1.0
In-Reply-To: <20180730061723.13290-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.07.2018 09:17, Qu Wenruo wrote:
> -void btrfs_tree_lock(struct extent_buffer *eb)
> +int btrfs_tree_lock(struct extent_buffer *eb)
>  {
> -	WARN_ON(eb->lock_owner == current->pid);
> +	if (unlikely(eb->lock_owner == current->pid)) {
> +		WARN(1,
> +"tree block %llu already locked by current (pid=%llu), refuse to lock",
> +		     eb->start, current->pid);
> +		return -EUCLEAN;
> +	}

If this happens it should point to a logical bug in which case we need
to halt the kernel. Furthermore this seems the wrong abstraction level
at which to solve the problem. eb->lock_owner is a runtime
characteristic of the eb, yet when it has an unexpected value you return
EUCLEAN which is an error for an on-disk error.

I don't think it's productive to try and solve every possible
fuzz-inspired corruption. In the worst case this corruption should be
caught a lot earlier rather than when we are locking an in-memory
structure.

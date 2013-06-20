Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757030Ab3FTQ0R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 12:26:17 -0400
Date: Thu, 20 Jun 2013 09:26:15 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use a percpu to keep track of possibly pinned
 bytes
Message-ID: <20130620162615.GB32674@lenny.home.zabbo.net>
References: <1371670655-18309-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1371670655-18309-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> @@ -3380,6 +3382,10 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
>  	if (!found)
>  		return -ENOMEM;
>  
> +	ret = percpu_counter_init(&found->total_bytes_pinned, 0);
> +	if (ret)
> +		return ret;
> +

Leaks *found if percpu_counter_init() fails.

> -	if (space_info->bytes_pinned + delayed_rsv->size < bytes) {
> +	bytes_pinned = percpu_counter_sum(&space_info->total_bytes_pinned);
> +	if (bytes_pinned + delayed_rsv->size < bytes) {

This stood out as being different from the rest of the comparisons.

Why manually sum the counters instead of letting _compare() optimize it
away if it can?  _compare(&, bytes - delayed_rsv->size)?

- z

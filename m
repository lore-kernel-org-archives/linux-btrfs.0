Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbbJSOgS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 10:36:18 -0400
Date: Mon, 19 Oct 2015 16:35:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Byongho Lee <bhlee.kernel@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs: compress: put variables defined per compress
 type in struct to make cache friendly
Message-ID: <20151019143504.GB27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1444799124-12093-1-git-send-email-bhlee.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444799124-12093-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 14, 2015 at 02:05:24PM +0900, Byongho Lee wrote:
> Below variables are defined per compress type.
>  - struct list_head comp_idle_workspace[BTRFS_COMPRESS_TYPES]
>  - spinlock_t comp_workspace_lock[BTRFS_COMPRESS_TYPES]
>  - int comp_num_workspace[BTRFS_COMPRESS_TYPES]
>  - atomic_t comp_alloc_workspace[BTRFS_COMPRESS_TYPES]
>  - wait_queue_head_t comp_workspace_wait[BTRFS_COMPRESS_TYPES]
> 
> BTW, while accessing one compress type of these variables, the next or
> before address is other compress types of it.
> So this patch puts these variables in a struct to make cache friendly.
> 
> Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Thanks.

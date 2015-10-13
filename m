Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932499AbbJMQ3o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 12:29:44 -0400
Date: Tue, 13 Oct 2015 18:28:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Byongho Lee <bhlee.kernel@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: compress: put variables defined per compress type
 in struct to make cache friendly
Message-ID: <20151013162834.GM27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1444752806-3549-1-git-send-email-bhlee.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444752806-3549-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 14, 2015 at 01:13:26AM +0900, Byongho Lee wrote:
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

Nice.

> +static struct {
> +	struct list_head idle_workspace;
> +	spinlock_t workspace_lock;
> +	int num_workspace;
> +	atomic_t alloc_workspace;
> +	wait_queue_head_t workspace_wait;
> +} comp[BTRFS_COMPRESS_TYPES];

The name became too generic, please rename it to btrfs_comp_ws.
btrfs_comp_workspaces would be too long. I won't mind trimming the
members to 'ws' instead of 'workspace' so this does not result in too
wild code formatting. The use of the workspaces is localized only to the
compression code so it will not be confusing.

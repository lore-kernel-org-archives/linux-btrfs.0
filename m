Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59509 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S944195AbdEZQdg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 12:33:36 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BEA7BAC03
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 16:33:34 +0000 (UTC)
Date: Fri, 26 May 2017 18:32:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 1/2] btrfs: Separate space_info create/update
Message-ID: <20170526163235.GE30842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1495434950-20674-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1495434950-20674-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 22, 2017 at 09:35:49AM +0300, Nikolay Borisov wrote:
> +static int create_space_info(struct btrfs_fs_info *info, u64 flags,
> +			     struct btrfs_space_info **new)
> +{
> +
> +	struct btrfs_space_info *space_info;
> +	int i;
> +	int ret;
> +
> +	space_info = kzalloc(sizeof(*space_info), GFP_NOFS);
> +	if (!space_info)
> +		return -ENOMEM;
> +
> +	ret = percpu_counter_init(&space_info->total_bytes_pinned, 0,
> +				 GFP_KERNEL);
> +	if (ret) {
> +		kfree(space_info);
> +		return ret;
> +	}
> +
> +	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
> +		INIT_LIST_HEAD(&space_info->block_groups[i]);
> +	init_rwsem(&space_info->groups_sem);
> +	spin_lock_init(&space_info->lock);
> +	space_info->flags = flags & BTRFS_BLOCK_GROUP_TYPE_MASK;
> +	space_info->force_alloc = CHUNK_ALLOC_NO_FORCE;
> +	init_waitqueue_head(&space_info->wait);
> +	INIT_LIST_HEAD(&space_info->ro_bgs);
> +	INIT_LIST_HEAD(&space_info->tickets);
> +	INIT_LIST_HEAD(&space_info->priority_tickets);
> +
> +	ret = kobject_init_and_add(&space_info->kobj, &space_info_ktype,
> +				    info->space_info_kobj, "%s",
> +				    alloc_name(space_info->flags));
> +	if (ret) {

JFTR, I've added the percpu_counter_destroy line here, that went through
another patch ("btrfs: fix memory leak in update_space_info failure
path").

> +		kfree(space_info);
> +		return ret;
> +	}
> +
> +	*new = space_info;
> +	list_add_rcu(&space_info->list, &info->space_info);
> +	if (flags & BTRFS_BLOCK_GROUP_DATA)
> +		info->data_sinfo = space_info;
> +
> +	return ret;
> +}

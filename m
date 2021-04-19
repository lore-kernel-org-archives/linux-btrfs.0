Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B62B3C433B4
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Apr 2021 17:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55214611F0
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Apr 2021 17:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237548AbhDSRU7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Apr 2021 13:20:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:45686 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbhDSRU6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Apr 2021 13:20:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0DC5AB30A;
        Mon, 19 Apr 2021 17:20:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8E8EFDA732; Mon, 19 Apr 2021 19:18:09 +0200 (CEST)
Date:   Mon, 19 Apr 2021 19:18:09 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>,
        Filipe Manana <fdmanana@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH v5 3/3] btrfs: zoned: automatically reclaim zones
Message-ID: <20210419171809.GQ7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>,
        Filipe Manana <fdmanana@suse.com>,
        Anand Jain <anand.jain@oracle.com>
References: <cover.1618817864.git.johannes.thumshirn@wdc.com>
 <f4548d6db76cb1168266d1a216563441308b615b.1618817864.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4548d6db76cb1168266d1a216563441308b615b.1618817864.git.johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 19, 2021 at 04:41:02PM +0900, Johannes Thumshirn wrote:
> +void btrfs_reclaim_bgs_work(struct work_struct *work)
> +{
> +	struct btrfs_fs_info *fs_info =
> +		container_of(work, struct btrfs_fs_info, reclaim_bgs_work);
> +	struct btrfs_block_group *bg;
> +	struct btrfs_space_info *space_info;
> +	int ret;
> +
> +	if (!test_bit(BTRFS_FS_OPEN, &fs_info->flags))
> +		return;
> +
> +	if (!btrfs_exclop_start(fs_info, BTRFS_EXCLOP_BALANCE))
> +		return;
> +
> +	mutex_lock(&fs_info->reclaim_bgs_lock);
> +	spin_lock(&fs_info->unused_bgs_lock);
> +	while (!list_empty(&fs_info->reclaim_bgs)) {
> +		bg = list_first_entry(&fs_info->reclaim_bgs,
> +				      struct btrfs_block_group,
> +				      bg_list);
> +		list_del_init(&bg->bg_list);
> +
> +		space_info = bg->space_info;
> +		spin_unlock(&fs_info->unused_bgs_lock);
> +
> +		/* Don't want to race with allocators so take the groups_sem */
> +		down_write(&space_info->groups_sem);
> +
> +		spin_lock(&bg->lock);
> +		if (bg->reserved || bg->pinned || bg->ro) {
> +			/*
> +			 * We want to bail if we made new allocations or have
> +			 * outstanding allocations in this block group.  We do
> +			 * the ro check in case balance is currently acting on
> +			 * this block group.
> +			 */
> +			spin_unlock(&bg->lock);
> +			up_write(&space_info->groups_sem);
> +			goto next;
> +		}
> +		spin_unlock(&bg->lock);
> +
> +		/* Get out fast, in case we're unmounting the FS. */
> +		if (btrfs_fs_closing(fs_info)) {
> +			up_write(&space_info->groups_sem);
> +			goto next;
> +		}
> +
> +		ret = inc_block_group_ro(bg, 0);
> +		up_write(&space_info->groups_sem);
> +		if (ret < 0)
> +			goto next;
> +
> +		btrfs_info(fs_info, "reclaiming chunk %llu", bg->start);

This could state the bg usage ratio, bg->used / bg->length .

> +		trace_btrfs_reclaim_block_group(bg);
> +		ret = btrfs_relocate_chunk(fs_info, bg->start);
> +		if (ret)
> +			btrfs_err(fs_info, "error relocating chunk %llu",
> +				  bg->start);
> +
> +next:
> +		btrfs_put_block_group(bg);
> +		spin_lock(&fs_info->unused_bgs_lock);
> +	}
> +	spin_unlock(&fs_info->unused_bgs_lock);
> +	mutex_unlock(&fs_info->reclaim_bgs_lock);
> +	btrfs_exclop_finish(fs_info);
> +}

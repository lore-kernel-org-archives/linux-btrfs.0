Return-Path: <SRS0=i7A4=AU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4BE2C433E0
	for <linux-btrfs@archiver.kernel.org>; Thu,  9 Jul 2020 16:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DD95207FB
	for <linux-btrfs@archiver.kernel.org>; Thu,  9 Jul 2020 16:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgGIQdH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 12:33:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:43384 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbgGIQdH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Jul 2020 12:33:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5D9D6AD74;
        Thu,  9 Jul 2020 16:33:06 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CED83DAB7F; Thu,  9 Jul 2020 18:32:46 +0200 (CEST)
Date:   Thu, 9 Jul 2020 18:32:46 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 2/3] btrfs: qgroup: try to flush qgroup space when we
 get -EDQUOT
Message-ID: <20200709163246.GB15161@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200708062447.81341-1-wqu@suse.com>
 <20200708062447.81341-3-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708062447.81341-3-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jul 08, 2020 at 02:24:46PM +0800, Qu Wenruo wrote:
> -int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
> +static int try_flush_qgroup(struct btrfs_root *root)
> +{
> +	struct btrfs_trans_handle *trans;
> +	int ret;
> +
> +	/*
> +	 * We don't want to run flush again and again, so if there is a running
> +	 * one, we won't try to start a new flush, but exit directly.
> +	 */
> +	ret = mutex_trylock(&root->qgroup_flushing_mutex);
> +	if (!ret) {
> +		mutex_lock(&root->qgroup_flushing_mutex);
> +		mutex_unlock(&root->qgroup_flushing_mutex);

This is abuse of mutex, for status tracking "is somebody flushing" and
for waiting until it's over.

We have many root::status bits (the BTRFS_ROOT_* namespace) so that
qgroups are flushing should another one. The bit atomically set when it
starts and cleared when it ends.

All waiting tasks should queue in a normal wait_queue_head.

> +		return 0;
> +	}
> +
> +	ret = btrfs_start_delalloc_snapshot(root);
> +	if (ret < 0)
> +		goto unlock;
> +	btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);
> +
> +	trans = btrfs_join_transaction(root);
> +	if (IS_ERR(trans)) {
> +		ret = PTR_ERR(trans);
> +		goto unlock;
> +	}
> +
> +	ret = btrfs_commit_transaction(trans);
> +unlock:
> +	mutex_unlock(&root->qgroup_flushing_mutex);

And also the whole wait/join/commit combo is in one huge mutex, that's
really an anti-pattern.

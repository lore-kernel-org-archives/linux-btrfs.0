Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47456 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754091AbeGBIhw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 04:37:52 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2D413AD48
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Jul 2018 08:37:51 +0000 (UTC)
Subject: Re: [PATCH v2] btrfs: tree-checker: Verify block_group_item
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180702083414.13670-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <933bbbb4-157b-c966-17ce-b246aa056ff2@suse.com>
Date: Mon, 2 Jul 2018 11:37:50 +0300
MIME-Version: 1.0
In-Reply-To: <20180702083414.13670-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  2.07.2018 11:34, Qu Wenruo wrote:
> +	if (hweight64(flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) > 1) {
> +		block_group_err(fs_info, leaf, slot,
> +"invalid profile flags, have 0x%llx (%lu bits set) expect no more than 1 bit set",
> +			flags & BTRFS_BLOCK_GROUP_PROFILE_MASK,
> +			hweight64(flags & BTRFS_BLOCK_GROUP_PROFILE_MASK));

Shouldn't this also be a hweight64() != 1 check ?

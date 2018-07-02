Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35074 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752136AbeGBOtF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 10:49:05 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E54F2AF40
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Jul 2018 14:49:03 +0000 (UTC)
Date: Mon, 2 Jul 2018 16:48:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: tree-checker: Verify block_group_item
Message-ID: <20180702144856.GA3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180702083414.13670-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180702083414.13670-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2018 at 04:34:14PM +0800, Qu Wenruo wrote:
> As reported in https://bugzilla.kernel.org/show_bug.cgi?id=199849,
> a crafted image with invalid block group items could make free space cache
> code to cause panic.
> 
> We could early detect such invalid block group item by checking:
> 1) Size (key)
>    We have a up limit on block group item (10G)

> +	if (key->offset > 10ULL * SZ_1G) {
> +		block_group_err(fs_info, leaf, slot,
> +			"invalid block group size, have %llu expect (0, %llu)",
> +				key->offset, 10ULL * SZ_1G);

Can you please make this magic constant a define and explain in a
comment how it's calculated? Thanks.

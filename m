Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33474 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727982AbeINSEV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 14:04:21 -0400
Date: Fri, 14 Sep 2018 14:49:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: remove level==0 check in balance_level
Message-ID: <20180914124958.GA5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1536703587-94565-4-git-send-email-bo.liu@linux.alibaba.com>
 <1536861359-55509-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1536861359-55509-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2018 at 01:55:59AM +0800, Liu Bo wrote:
> btrfs_search_slot()
>    if (level != 0)
>       setup_nodes_for_search()
>           balance_level()
> 
> It is just impossible to have level=0 in balance_level.
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: David Sterba <dsterba@suse.com>

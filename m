Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54652 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726359AbeILR5E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 13:57:04 -0400
Date: Wed, 12 Sep 2018 14:52:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove level==0 check in balance_level
Message-ID: <20180912125238.GM2154@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1536703587-94565-4-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1536703587-94565-4-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 12, 2018 at 06:06:23AM +0800, Liu Bo wrote:
> btrfs_search_slot()
>    if (level != 0)
>       setup_nodes_for_search()
>           balance_level()
> 
> It is just impossible to have level=0 in balance_level.

While this is true, what do you think about adding ASSERT(level > 0) ?
This is to catch accidentally passing level 0.

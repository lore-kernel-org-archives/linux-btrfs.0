Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:53655 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728197AbeIMAgV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 20:36:21 -0400
Date: Wed, 12 Sep 2018 12:30:18 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove level==0 check in balance_level
Message-ID: <20180912193017.pnuqtnhhc6e6x4ld@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <1536703587-94565-4-git-send-email-bo.liu@linux.alibaba.com>
 <20180912125238.GM2154@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180912125238.GM2154@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 12, 2018 at 02:52:38PM +0200, David Sterba wrote:
> On Wed, Sep 12, 2018 at 06:06:23AM +0800, Liu Bo wrote:
> > btrfs_search_slot()
> >    if (level != 0)
> >       setup_nodes_for_search()
> >           balance_level()
> > 
> > It is just impossible to have level=0 in balance_level.
> 
> While this is true, what do you think about adding ASSERT(level > 0) ?
> This is to catch accidentally passing level 0.

Sounds good, will update it.

thanks,
-liubo

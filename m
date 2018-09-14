Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35014 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726905AbeINSOQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 14:14:16 -0400
Date: Fri, 14 Sep 2018 14:59:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: skip set_page_dirty if eb is dirty
Message-ID: <20180914125952.GC5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1536703587-94565-1-git-send-email-bo.liu@linux.alibaba.com>
 <1536860682-41012-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1536860682-41012-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2018 at 01:44:42AM +0800, Liu Bo wrote:
> As long as @eb is marked with EXTENT_BUFFER_DIRTY, all of its pages
> are dirty, so no need to set pages dirty again.
> 
> Ftrace showed that the loop took 10us on my dev box, so removing this
> can save us at least 10us if eb is already dirty.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: David Sterba <dsterba@suse.com>

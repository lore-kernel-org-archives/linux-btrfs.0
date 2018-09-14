Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34250 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727672AbeINSJg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 14:09:36 -0400
Date: Fri, 14 Sep 2018 14:55:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: assert page dirty bit
Message-ID: <20180914125512.GB5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1536703587-94565-2-git-send-email-bo.liu@linux.alibaba.com>
 <1536860768-42604-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1536860768-42604-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2018 at 01:46:08AM +0800, Liu Bo wrote:
> Just in case that someone breaks the rule that pages are dirty as long
> as eb is dirty.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: David Sterba <dsterba@suse.com>

I've reordered the patches so the assert comes first, before the actual
conditional dirtying.

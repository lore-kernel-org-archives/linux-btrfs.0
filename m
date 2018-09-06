Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37380 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730231AbeIFUP0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Sep 2018 16:15:26 -0400
Date: Thu, 6 Sep 2018 17:39:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: remove confusing tracepoint in
 btrfs_add_reserved_bytes
Message-ID: <20180906153904.GA24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1536111445-126664-1-git-send-email-bo.liu@linux.alibaba.com>
 <1536112527-16758-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1536112527-16758-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 05, 2018 at 09:55:27AM +0800, Liu Bo wrote:
> Here we're not releasing any space, but transferring bytes from
> ->bytes_may_use to ->bytes_reserved.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
> v2: Add missing commit log.

I've enhanced the changlog a bit how the tracepoint got there.

Reviewed-by: David Sterba <dsterba@suse.com>

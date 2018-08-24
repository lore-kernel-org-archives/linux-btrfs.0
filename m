Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41582 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726353AbeHXPxy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Aug 2018 11:53:54 -0400
Date: Fri, 24 Aug 2018 14:19:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: btrfs_get_extent: put btrfs_free_path ahead
Message-ID: <20180824121916.GQ24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1534980978-91392-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534980978-91392-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 23, 2018 at 07:36:17AM +0800, Liu Bo wrote:
> trace_btrfs_get_extent() has nothing to do with path, place
> btrfs_free_path ahead so that we can unlock path on error.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: David Sterba <dsterba@suse.com>

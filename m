Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49570 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753577AbdGNMdY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 08:33:24 -0400
Date: Fri, 14 Jul 2017 14:32:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix unexpected return value of bio_readpage_error
Message-ID: <20170714123209.GG2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170713220050.22720-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170713220050.22720-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 13, 2017 at 03:00:50PM -0700, Liu Bo wrote:
> With blk_status_t, in bio_readpage_error() may return 1 as now
> ->submit_bio_hook() may not set %ret if it runs without problem.

Huh, that is pretty subtle, good catch. Also it's good the patch can be
applied independent of the blk_status_t changes, so I don't need to do 2
branches and pull requests.

> This fixes that unexpected return value by changing
> btrfs_check_repairable() to return a bool instead of updating %ret.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34237 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750749AbeABQbj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Jan 2018 11:31:39 -0500
Date: Tue, 2 Jan 2018 17:29:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove unused wait in btrfs_stripe_hash
Message-ID: <20180102162932.GW3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171222232301.17979-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171222232301.17979-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 22, 2017 at 04:23:01PM -0700, Liu Bo wrote:
> In fact nobody is waiting on @wait's waitqueue, it can be safely
> removed.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

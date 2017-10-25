Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38742 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750903AbdJYNOy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Oct 2017 09:14:54 -0400
Date: Wed, 25 Oct 2017 15:13:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs: free btrfs_device in place
Message-ID: <20171025131304.GX3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171010215103.20828-2-bo.li.liu@oracle.com>
 <20171024050254.32593-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171024050254.32593-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 23, 2017 at 11:02:54PM -0600, Liu Bo wrote:
> It's pointless to defer it to a kthread helper as we're not under a
> special context.
> 
> For reference, commit 1f78160ce1b1 ("Btrfs: using rcu lock in the
> reader side of devices list") introduced RCU freeing for device
> structures.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> Reviewed-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

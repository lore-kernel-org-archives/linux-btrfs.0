Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43392 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727141AbeHOPgg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 11:36:36 -0400
Date: Wed, 15 Aug 2018 14:44:25 +0200
From: David Sterba <dsterba@suse.cz>
To: zhong jiang <zhongjiang@huawei.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/3] fs/btrfs/disk-io: change
 btrfs_destroy_delayed_refs to be void function
Message-ID: <20180815124425.GM24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1533736075-8691-1-git-send-email-zhongjiang@huawei.com>
 <1533736075-8691-2-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1533736075-8691-2-git-send-email-zhongjiang@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 08, 2018 at 09:47:53PM +0800, zhong jiang wrote:
> btrfs_destroy_delayed_refs defines the variable "ret" for return value, but
> it is not modified after initialization. Further, I find that any of the
> callees do not handle the return value.  So it is safe to drop the
> unneeded value "ret".

The callers care about the return values, not the callees. My point in
the previous patch iterations was to make sure that none of the callees,
ie. the functions that are called by btrfs_destroy_delayed_refs, do not
lack error handling.

And I found one that does, btrfs_pin_extent, near the end of the while
loop. So, there's more work and I can't apply this patch until it's
fixed, which may make this patch obsolete as the return value would be
actually needed.

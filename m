Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37836 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726705AbeHTQ7f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Aug 2018 12:59:35 -0400
Date: Mon, 20 Aug 2018 15:43:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Chris Mason <clm@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] btrfs: use after free in btrfs_quota_enable()
Message-ID: <20180820134342.GX24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180820082533.rs3yh4agza6epz7j@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180820082533.rs3yh4agza6epz7j@kili.mountain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 20, 2018 at 11:25:33AM +0300, Dan Carpenter wrote:
> The issue here is that btrfs_commit_transaction() frees "trans" on both
> the error and the success path.  So the problem would be if
> btrfs_commit_transaction() succeeds, and then qgroup_rescan_init()
> fails.  That means that "ret" is non-zero and "trans" is non-NULL and it
> leads to a use after free inside the btrfs_end_transaction() macro.
> 
> Fixes: 340f1aa27f36 ("btrfs: qgroups: Move transaction management inside btrfs_quota_enable/disable")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks.

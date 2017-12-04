Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42691 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751436AbdLDUda (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Dec 2017 15:33:30 -0500
Date: Mon, 4 Dec 2017 21:31:30 +0100
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix missing error return in btrfs_drop_snapshot
Message-ID: <20171204203130.GC3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171204181145.10335-1-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171204181145.10335-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 04, 2017 at 01:11:45PM -0500, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> If btrfs_del_root fails in btrfs_drop_snapshot, we'll pick up the
> error but then return 0 anyway due to mixing err and ret.
> 
> Fixes: 79787eaab4612 ("btrfs: replace many BUG_ONs with proper error handling")
> Cc: <stable@vger.kernel.org> # v3.4+
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59382 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932130AbdDEMlX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Apr 2017 08:41:23 -0400
Date: Wed, 5 Apr 2017 14:40:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: update scrub_parity to use u64 stripe_len
Message-ID: <20170405124038.GC4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1491252333-3667-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1491252333-3667-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 03, 2017 at 01:45:33PM -0700, Liu Bo wrote:
> Commit 3d8da6781760 ("Btrfs: fix divide error upon chunk's stripe_len")
> changed stripe_len in struct map_lookup to u64, but didn't update
> stripe_len in struct scrub_parity.
> 
> This updates the type and switches to div64_u64_rem to match u64 divisor.
> 
> Cc: David Sterba <dsterba@suse.cz>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

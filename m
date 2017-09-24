Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48623 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753122AbdIXWTI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Sep 2017 18:19:08 -0400
Date: Mon, 25 Sep 2017 00:17:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix memory leak in raid56
Message-ID: <20170924221733.GW29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170922181118.16878-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170922181118.16878-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 22, 2017 at 12:11:18PM -0600, Liu Bo wrote:
> The local bio_list may have pending bios when doing cleanup, it can
> end up with memory leak if they don't get free'd.

I was wondering if we could make a common helper that would call
rbio_orig_end_io and while (..) put_bio(), but __raid56_parity_recover
does not fit the pattern. Still might be worth, but the patch is ok as
is.

Reviewed-by: David Sterba <dsterba@suse.com>

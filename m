Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53847 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752650AbeFUOBA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 10:01:00 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7DFC4AE91
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jun 2018 14:00:59 +0000 (UTC)
Date: Thu, 21 Jun 2018 15:58:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: check-integrity: Fix NULL pointer dereference for
 degraded mount
Message-ID: <20180621135809.GQ24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180620073858.10794-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180620073858.10794-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2018 at 03:38:58PM +0800, Qu Wenruo wrote:
> Commit f8f84b2dfda5 ("btrfs: index check-integrity state hash by a dev_t")
> changed how btrfsic how we index device state hash.
> 
> Now we need to access device->bdev->bd_dev, while for degraded mount
> it's completely possible to have device->bdev as NULL, thus it will
> trigger a NULL pointer dereference at mount time.
> 
> Fix it by checking if the device is degraded before accessing
> device->bdev->bd_dev.
> 
> There are a lot of other places accessing device->bdev->bd_dev, however
> the other call sites have either checked device->bdev, or the
> device->bdev is passed from btrfsic_map_block(), so it won't cause harm.
> 
> Fixes: f8f84b2dfda5 ("btrfs: index check-integrity state hash by a dev_t")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to misc-next. As it is a fix it could go to 4.18 but I'd rather
have a good reason for that because it's in a debugging feature.

> ---
> Please note there are still quite some problem about check-integrity,
> including:
> 1) Warning for degraded mount
> 2) Meaningless empty lines output
> 
> This patch will only fix the obvious NULL pointer dereference exposed by
> btrfs/027 with "check_int" mount option.

Ok.

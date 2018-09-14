Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36468 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726900AbeINVhd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 17:37:33 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CD31BAFB2
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 16:22:20 +0000 (UTC)
Date: Fri, 14 Sep 2018 18:22:20 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: use ->devices list instead of ->alloc_list in
 btrfs_trim_fs
Message-ID: <20180914162220.GS5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180906211816.12121-1-jeffm@suse.com>
 <20180906211816.12121-2-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180906211816.12121-2-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 06, 2018 at 05:18:14PM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> btrfs_trim_fs iterates over the fs_devices->alloc_list while holding
> the device_list_mutex.  The problem is that ->alloc_list is protected
> by the chunk mutex.  We don't want to hold the chunk mutex over
> the trim of the entire file system.  Fortunately, the ->dev_list
> list is protected by the dev_list mutex and while it will give us
> all devices, including read-only devices, we already just skip the
> read-only devices.  Then we can continue to take and release the chunk
> mutex while scanning each device.
> 
> Fixes: 499f377f49f (btrfs: iterate over unused chunk space in FITRIM)
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

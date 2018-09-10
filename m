Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60196 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726603AbeIJXDH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Sep 2018 19:03:07 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1DFB1AF7D
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2018 18:07:49 +0000 (UTC)
Date: Mon, 10 Sep 2018 20:07:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] cleanup couple of device-related functions' retval
Message-ID: <20180910180731.GX24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180903094614.2667-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180903094614.2667-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 03, 2018 at 12:46:11PM +0300, Nikolay Borisov wrote:
> Currently btrfs_find_device_by_path, btrfs_find_device_missing_or_by_path and 
> btrfs_find_device_by_devspec are called in a chain and they all return an 
> integer value to signal error and at the same time use one of their parameters
> as an output. This patch set refactors those functions starting from the 
> bottom, gradually making them return a pointer to btrfs_device. This is 
> sufficient to convey an error when it occurs as well as return the actual 
> device we are looking for. One added benefit is that the ioctl-specific positive
> return value BTRFS_ERROR_DEV_MISSING_NOT_FOUND is now returned from 
> btrfs_rm_device rather than from some internal function. 
> 
> Additionally I'll be sending a patch to progs, adding a test ensuring that 
> BTRFS_ERROR_MISSING_NOT_FOUND is returned appropriately. 
> 
> This survived both my btrfs-progs test as well as xfstest run. No functional 
> changes.
> 
> 
> Nikolay Borisov (3):
>   btrfs: Make btrfs_find_device_by_path return struct btrfs_device
>   btrfs: Make btrfs_find_device_missing_or_by_path return directly a
>     device
>   btrfs: Make btrfs_find_device_by_devspec return btrfs_device directly

Added to misc-next, thanks.

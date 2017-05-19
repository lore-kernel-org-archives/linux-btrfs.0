Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27328 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754330AbdESAN2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 20:13:28 -0400
Date: Thu, 18 May 2017 17:11:35 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: Fix restoring image from multi devices
 fs into single device
Message-ID: <20170519001135.GG23822@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170517014121.8499-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170517014121.8499-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 17, 2017 at 02:41:21AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We correctly build an image from a multiple devices filesystem but when
> restoring the image into a single device we were missing updating the
> number of devices in the superblock to the value 1 (we already took care
> of setting the number of stripes to 1 for each chunk item and setting
> the device id for each chunk item to match the device id from the super
> block).
> 
> This missing update of the number of devices makes it impossible to mount
> the restored filesystem on recent kernels, more specifically since the
> linux kernel commit 99e3ecfcb9f4ca35192d20a5bea158b81f600062
> ("Btrfs: add more validation checks for superblock"), that produce the
> following message in the dmesg/syslog:
> 
> [21097.542047] BTRFS error (device sdi): super_num_devices 2 mismatch with num_devices 1 found here
> [21097.543972] BTRFS error (device sdi): failed to read chunk tree: -22
> [21097.720360] BTRFS error (device sdi): open_ctree failed
> 
> So fix this by updating the number of devices to 1 in the superblock.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo

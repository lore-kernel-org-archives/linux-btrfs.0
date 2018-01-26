Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:33542 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751508AbeAZOCT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 09:02:19 -0500
Received: by mail-qt0-f195.google.com with SMTP id d8so1481711qtm.0
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 06:02:18 -0800 (PST)
Date: Fri, 26 Jan 2018 09:02:17 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix unexpected cow in run_delalloc_nocow
Message-ID: <20180126140216.fk2tdxfedv7u6mn3@destiny>
References: <20180125180256.10844-2-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180125180256.10844-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 25, 2018 at 11:02:49AM -0700, Liu Bo wrote:
> Fstests generic/475 provides a way to fail metadata reads while
> checking if checksum exists for the inode inside run_delalloc_nocow(),
> and csum_exist_in_range() interprets error (-EIO) as inode having
> checksum and makes its caller enters the cow path.
> 
> In case of free space inode, this ends up with a warning in
> cow_file_range().
> 
> The same problem applies for btrfs_cross_ref_exist() since it may also
> read metadata in between.
> 
> With this, run_delalloc_nocow() bails out when errors occur at the two
> places.
> 
> cc: <stable@vger.kernel.org> v2.6.28+
> Fixes: 17d217fe970d ("Btrfs: fix nodatasum handling in balancing code")
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

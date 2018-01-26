Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33625 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751758AbeAZOXe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 09:23:34 -0500
Received: by mail-qt0-f196.google.com with SMTP id d8so1647633qtm.0
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 06:23:34 -0800 (PST)
Date: Fri, 26 Jan 2018 09:23:32 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix unexpected -EEXIST when creating new inode
Message-ID: <20180126142331.iyigcgucqqtwcj63@destiny>
References: <20180125180256.10844-9-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180125180256.10844-9-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 25, 2018 at 11:02:56AM -0700, Liu Bo wrote:
> The highest objectid, which is assigned to new inode, is decided at
> the time of initializing fs roots.  However, in cases where log replay
> gets processed, the btree which fs root owns might be changed, so we
> have to search it again for the highest objectid, otherwise creating
> new inode would end up with -EEXIST.
> 
> cc: <stable@vger.kernel.org> v4.4-rc6+
> Fixes: f32e48e92596 ("Btrfs: Initialize btrfs_root->highest_objectid when loading tree root and subvolume roots")
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---

Eesh that's bad.

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

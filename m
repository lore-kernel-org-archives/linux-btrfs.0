Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:46146 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751875AbeAZOEm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 09:04:42 -0500
Received: by mail-qt0-f176.google.com with SMTP id o35so1423154qtj.13
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 06:04:41 -0800 (PST)
Date: Fri, 26 Jan 2018 09:04:40 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix crash due to not cleaning up tree log block's
 dirty bits
Message-ID: <20180126140439.pvkjyuirtilvu5ze@destiny>
References: <20180125180256.10844-4-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180125180256.10844-4-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 25, 2018 at 11:02:51AM -0700, Liu Bo wrote:
> In cases that the whole fs flips into readonly status due to failures in
> critical sections, then log tree's blocks are still dirty, and this leads
> to a crash during umount time, the crash is about use-after-free,
> 
> umount
>  -> close_ctree
>     -> stop workers
>     -> iput(btree_inode)
>        -> iput_final
>           -> write_inode_now
> 	     -> ...
> 	       -> queue job on stop'd workers
> 
> cc: <stable@vger.kernel.org> v3.12+
> Fixes: 681ae50917df ("Btrfs: cleanup reserved space when freeing tree log on error")
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

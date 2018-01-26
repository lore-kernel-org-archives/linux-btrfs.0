Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:38793 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752449AbeAZOII (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 09:08:08 -0500
Received: by mail-qt0-f196.google.com with SMTP id z10so1495302qti.5
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 06:08:08 -0800 (PST)
Date: Fri, 26 Jan 2018 09:05:56 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix btrfs_evict_inode to handle abnormal inodes
 correctly
Message-ID: <20180126140555.amcizfkyk3kjqfaw@destiny>
References: <20180125180256.10844-6-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180125180256.10844-6-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 25, 2018 at 11:02:53AM -0700, Liu Bo wrote:
> This regression is introduced in
> commit 3d48d9810de4 ("btrfs: Handle uninitialised inode eviction").
> 
> There are two problems,
> 
> a) it is ->destroy_inode() that does the final free on inode, not
>    ->evict_inode(),
> b) clear_inode() must be called before ->evict_inode() returns.
> 
> This could end up hitting BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
> in evict() because I_CLEAR is set in clear_inode().
> 
> Fixes: commit 3d48d9810de4 ("btrfs: Handle uninitialised inode eviction")
> Cc: <stable@vger.kernel.org> # v4.7-rc6+
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

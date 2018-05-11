Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:38900 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752729AbeEKOUg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 10:20:36 -0400
Received: by mail-qk0-f193.google.com with SMTP id b39-v6so4466732qkb.5
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 07:20:36 -0700 (PDT)
Date: Fri, 11 May 2018 10:20:34 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v3 07/11] Btrfs: don't return ino to ino cache if inode
 item removal fails
Message-ID: <20180511142034.z75mx5csjxrq2pvo@destiny>
References: <cover.1526025007.git.osandov@fb.com>
 <0e9c1fa80282b022c459fa763f5a0f364b5e7ee2.1526025007.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0e9c1fa80282b022c459fa763f5a0f364b5e7ee2.1526025007.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 12:56:12AM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> In btrfs_evict_inode(), if btrfs_truncate_inode_items() fails, the inode
> item will still be in the tree but we still return the ino to the ino
> cache. That will blow up later when someone tries to allocate that ino,
> so don't return it to the cache.
> 
> Fixes: 581bb050941b ("Btrfs: Cache free inode numbers in memory")
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

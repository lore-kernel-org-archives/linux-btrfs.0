Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34915 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932114AbeE2HIk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 03:08:40 -0400
Subject: Re: [PATCH 0/2] UUID tree fs_info cleanup
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180529070154.20560-1-lufq.fnst@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <aee91be7-8879-d5d2-8863-83d0e90ec953@suse.com>
Date: Tue, 29 May 2018 10:08:37 +0300
MIME-Version: 1.0
In-Reply-To: <20180529070154.20560-1-lufq.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.05.2018 10:01, Lu Fengqi wrote:
> Just remove the redundant fs_info argument from uuid_tree functions
> because these functions have already taken transaction which has a
> reference to the fs_info.
> 
> No functional change.
> 
> Lu Fengqi (2):
>   btrfs: Remove fs_info argument from btrfs_uuid_tree_add
>   btrfs: Remove fs_info argument from btrfs_uuid_tree_rem
> 
>  fs/btrfs/ctree.h       |  6 ++----
>  fs/btrfs/inode.c       |  5 ++---
>  fs/btrfs/ioctl.c       |  9 ++++-----
>  fs/btrfs/transaction.c |  7 +++----
>  fs/btrfs/uuid-tree.c   | 10 +++++-----
>  fs/btrfs/volumes.c     |  5 ++---
>  6 files changed, 18 insertions(+), 24 deletions(-)

Reviewed-by: Nikolay Borisov <nborisov@suse.com>



Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58631 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbeILRj4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 13:39:56 -0400
Subject: Re: [PATCH 0/6] btrfs-progs: lowmem: bug fixes and inode_extref
 repair
To: damenly.su@gmail.com, linux-btrfs@vger.kernel.org
Cc: suy.fnst@cn.fujitsu.com
References: <20180912192046.5861-1-suy.fnst@cn.fujitsu.com>
From: Su Yue <Damenly_Su@gmx.com>
Message-ID: <5ca64cd2-2117-f626-e56c-2e8e5e040c9e@gmx.com>
Date: Wed, 12 Sep 2018 20:35:29 +0800
MIME-Version: 1.0
In-Reply-To: <20180912192046.5861-1-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry for the noise, Please ignore this patchset.
Will send v2.

On 2018/9/13 3:20 AM, damenly.su@gmail.com wrote:
> From: Su Yue <suy.fnst@cn.fujitsu.com>
> 
> This patchset can be fetched from my github(based on v4.17.1):
> https://github.com/Damenly/btrfs-progs/tree/lowmem_extref
> 
> The patchset aims to support check and repair errors about
> inode_extref in lowmem mode.
> 
> patch[1-2] let btrfs_unlink() detect inode_extref.
> patch[3] fixes a minor bug in check_dir_item due to my careless
> 	 long ago.
> patch[4] fixes a bug about inconsistent path in check_fs_roots()
> 	 under repair.
> patch[5] fixes a corner case about traversal of inode items.
> patch[6] enable inode_extref repair support and remove unnecessary
> 	 checks.
> patch[7] add a test image, it can verify above patches except
> 	 patch[3].
> 
> 
> Su Yue (6):
>    btrfs-progs: adjust arguments of btrfs_lookup_inode_extref()
>    btrfs-progs: make btrfs_unlink() lookup inode_extref
>    btrfs-progs: lowmem check: find dir_item by di_key in check_dir_item()
>    btrfs-progs: lowmem: search key of root again after check_fs_root()
>      under repair
>    btrfs-progs: lowmem: continue to check item in last slot while
>      checking inodes
>    btrfs-progs: lowmem: optimization and repair for check_inode_extref()
> 
>   check/mode-lowmem.c | 148 +++++++++++++++++++++++++++++++++++---------
>   ctree.h             |   6 +-
>   inode-item.c        |   6 +-
>   inode.c             |  14 ++++-
>   4 files changed, 139 insertions(+), 35 deletions(-)
> 

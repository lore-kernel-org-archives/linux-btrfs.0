Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:8229 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751041AbeACJNL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jan 2018 04:13:11 -0500
Subject: Re: [PATCH 0/5] Cleanups for later btrfs_alloc_chunk() rework
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
References: <20180103071306.11500-1-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <7133e03e-ed26-c9e6-99dc-3a6cd2b9b32c@cn.fujitsu.com>
Date: Wed, 3 Jan 2018 17:17:30 +0800
MIME-Version: 1.0
In-Reply-To: <20180103071306.11500-1-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/03/2018 03:13 PM, Qu Wenruo wrote:
> Just small cleanups for incoming btrfs_alloc_chunk() rework, which is
> designed to allow btrfs_alloc_chunk() to be able to alloc meta chunk,
> even current meta chunks are already full.
> 
> The cleanups are quite small, most of them are just removing unnecessary
> parameters, and make some function static.
> 
> Qu Wenruo (5):
>    btrfs-progs: Use bool parameter to determine if we're allocating data
>      extent
>    btrfs-progs: volumes: Make find_free_dev_extent_start static
>    btrfs-progs: volumes: Remove unnecessary trans parameter
>    btrfs-progs: volumes: Remove unnecessary parameters when allocating
>      device extent
>    btrfs-progs: Remove unnecessary parameter for btrfs_add_block_group
> 

The series looks good to me.
Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

>   cmds-check.c   |  4 ++--
>   convert/main.c |  4 +---
>   ctree.h        |  7 +++----
>   extent-tree.c  | 31 ++++++++++++++++---------------
>   mkfs/main.c    | 14 ++++----------
>   volumes.c      | 35 ++++++++++++++---------------------
>   6 files changed, 40 insertions(+), 55 deletions(-)
> 



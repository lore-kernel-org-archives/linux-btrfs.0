Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:20798 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751068AbeC0Hd2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:33:28 -0400
Subject: Re: [PATCH 00/10] Simplify function interfaces
To: Nikolay Borisov <nborisov@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1522135172-8276-1-git-send-email-nborisov@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <00908c0b-c777-9f2a-80fd-39dbbf8d6731@cn.fujitsu.com>
Date: Tue, 27 Mar 2018 15:38:53 +0800
MIME-Version: 1.0
In-Reply-To: <1522135172-8276-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/27/2018 03:19 PM, Nikolay Borisov wrote:
> A bunch of functions in lowmem mode take an 'ext_ref' parameter only to pass it
> down the call chain where it eventually is consumed. Turns out the functions
> which actually check the parameter are find_inode_ref and check_inode_item, the
> are only passing it down to them. At the same time those functions can get a
> reference to fs_info and do the check in them at the appropriate time.
> 
> This patchset cleanups the interface of various function by dropping the
> ext_ref argument and moving the actual query of the EXTREF feature closer to
> where it's being used.
> 
> The final patch just changes signature of __btrfs_fs_incompat to better match
> the logic of the code and be identical to its kernel counterpart. All in all
> this series doesn't introduce any functional changes per-se.
> 
> Nikolay Borisov (10):
>    btrfs-progs: Drop ext_ref parameter from find_inode_ref
>    btrfs-progs: Drop ext_ref param from check_dir_item
>    btrfs-progs: Drop ext_ref argument from check_inode_item
>    btrfs-progs: Drop unused ext_ref parameter from process_one_leaf
>    btrfs-progs: Remove ext_ref param from check_fs_first_inode
>    btrfs-progs: Remove ext_ref param from walk_down_tree
>    btrfs-progs: Drop ext_ref param from check_fs_first_inode
>    btrfs-progs: Drop ext_ref arument from check_fs_root
>    btrfs-progs: Remove ext_ref local variable from check_fs_roots_lowmem
>    btrfs-progs: Make __btrfs_fs_incompat return bool
> 

Nice work.
For all,
Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

>   check/mode-lowmem.c | 63 +++++++++++++++++++++++------------------------------
>   ctree.h             |  2 +-
>   2 files changed, 28 insertions(+), 37 deletions(-)
> 



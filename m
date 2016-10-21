Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34731 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750974AbcJUH4y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Oct 2016 03:56:54 -0400
Date: Fri, 21 Oct 2016 09:56:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 00/14] Btrfsck low memory mode with fs/subvol tree
 check
Message-ID: <20161021075652.GY11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 21, 2016 at 11:15:50AM +0800, Qu Wenruo wrote:
> Lu Fengqi (12):
>   btrfs-progs: move btrfs_extref_hash() to hash.h
>   btrfs-progs: check: introduce function to find dir_item
>   btrfs-progs: check: introduce function to check inode_ref
>   btrfs-progs: check: introduce function to check inode_extref
>   btrfs-progs: check: introduce function to find inode_ref
>   btrfs-progs: check: introduce a function to check dir_item
>   btrfs-progs: check: introduce function to check file extent
>   btrfs-progs: check: introduce function to check inode item
>   btrfs-progs: check: introduce function to check fs root
>   btrfs-progs: check: introduce function to check root ref
>   btrfs-progs: check: introduce low_memory mode fs_tree check
>   btrfs-progs: check: fix the return value bug of cmd_check()
> 
> Qu Wenruo (1):
>   btrfs-progs: check: Enhance leaf traversal function to handle missing
>     inode item
> 
> Wang Xiaoguang (1):
>   btrfs-progs: check: skip shared node or leaf check for low_memory mode

I've seen minor issues through the patchset, suitable for cleanups, but
the rest looks good enough to be merged. I did a high level review and
could have missed something, so the low-mem mode status remains.

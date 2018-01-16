Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35613 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750752AbeAPPYx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Jan 2018 10:24:53 -0500
Date: Tue, 16 Jan 2018 16:22:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: correct wrong comment about magic number of
 index_cnt
Message-ID: <20180116152243.GH13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180112030803.28341-1-suy.fnst@cn.fujitsu.com>
 <20180112030803.28341-2-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180112030803.28341-2-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 12, 2018 at 11:08:03AM +0800, Su Yue wrote:
> There is no function named btrfs_get_inode_index_count.
> Explanation for magic number index_cnt=2 in btrfs_new_inode() is
> actually located in btrfs_set_inode_index_count().
> 
> So replace 'btrfs_get_inode_index_count' in the comment by
> 'btrfs_set_inode_index_count'.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Added to 4.16 queue, thanks.

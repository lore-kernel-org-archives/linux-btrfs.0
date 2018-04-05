Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42561 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751259AbeDERQe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Apr 2018 13:16:34 -0400
Date: Thu, 5 Apr 2018 19:14:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: rename btrfs_get_block_group_info and make it
 static
Message-ID: <20180405171404.GN2635@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180402092411.14960-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180402092411.14960-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 02, 2018 at 05:24:11PM +0800, Su Yue wrote:
> The function btrfs_get_block_group_info() was introduced by the
> commit 5af3e8cce8b7 ("Btrfs: make filesystem read-only when submitting
>  barrier fails") which used it in disk-io.c.
> 
> However, the function is only called in ioctl.c now.
> Its parameter type btrfs_ioctl_space_info* is only for ioctl.
> 
> So, make it static and rename it to be original name
> get_block_group_info.
> 
> No functional change.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Added to next, thanks.

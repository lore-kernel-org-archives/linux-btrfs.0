Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758527AbaGXNNv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 09:13:51 -0400
Date: Thu, 24 Jul 2014 15:13:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/10] Btrfs: Fix the problem that the replace destroys
 the seed filesystem
Message-ID: <20140724131349.GZ1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 24, 2014 at 11:37:06AM +0800, Miao Xie wrote:
> The seed filesystem was destroyed by the device replace, the reproduce
> method is:
>  # mkfs.btrfs -f <dev0>
>  # btrfstune -S 1 <dev0>
>  # mount <dev0> <mnt>
>  # btrfs device add <dev1> <mnt>
>  # umount <mnt>
>  # mount <dev1> <mnt>
>  # btrfs replace start -f <dev0> <dev2> <mnt>
>  # umount <mnt>
>  # mount <dev0> <mnt>
> 
> It is because we erase the super block on the seed device. It is wrong,
> we should not change anything on the seed device.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

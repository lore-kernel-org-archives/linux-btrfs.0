Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952AbbHZP70 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 11:59:26 -0400
Date: Wed, 26 Aug 2015 17:58:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] btrfs-progs: use open_btrfs_dir for btrfs device
 command
Message-ID: <20150826155850.GB10756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1440579753.git.zhaolei@cn.fujitsu.com>
 <88fb97835205d1faa824e695128eeff5927eeda1.1440579753.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <88fb97835205d1faa824e695128eeff5927eeda1.1440579753.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 26, 2015 at 05:04:23PM +0800, Zhao Lei wrote:
> We can use open_btrfs_dir() to check whether target dir is
> in btrfs's mount point before open, instead of checking it in kernel
> space of ioctl, and return fuzzy error message.
> 
> Before patch:
>   # (/mnt/tmp is not btrfs mountpoint)
>   #
>   # btrfs device add -f /dev/sda13 /mnt/tmp
>   ERROR: error adding the device '/dev/sda13' - Inappropriate ioctl for device
>   #
> 
> After patch:
>   # btrfs device add -f /dev/sda13 /mnt/tmp
>   ERROR: not btrfs filesystem: /mnt/tmp
>   #
> 
> Similar fix for device remove and device usage.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.

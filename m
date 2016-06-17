Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161311AbcFQPPH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 11:15:07 -0400
Date: Fri, 17 Jun 2016 17:15:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, bo.li.liu@oracle.com,
        takeuchi_satoru@jp.fujitsu.com
Subject: Re: [PATCH V2] Btrfs-progs: Initialize stripesize to the value of
 sectorsize
Message-ID: <20160617151542.GD4915@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466141874-15854-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466141874-15854-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 17, 2016 at 11:07:54AM +0530, Chandan Rajendra wrote:
> stripesize should ideally be set to the value of sectorsize. However
> previous versions of btrfs-progs/mkfs.btrfs had set stripesize to a
> value of 4096. On machines with PAGE_SIZE other than 4096, This could
> lead to the following scenario,
> 
> - /dev/loop0, /dev/loop1 and /dev/loop2 are mounted as a single
>   filesystem. The filesystem was created by an older version of mkfs.btrfs
>   which set stripesize to 4k.
> - losetup -a
>    /dev/loop0: [0030]:19477 (/root/disk-imgs/file-0.img)
>    /dev/loop1: [0030]:16577 (/root/disk-imgs/file-1.img)
>    /dev/loop2: [64770]:3423229 (/root/disk-imgs/file-2.img)
> - /etc/mtab lists only /dev/loop0
> - losetup /dev/loop4 /root/disk-imgs/file-1.img
>   The new mkfs.btrfs invoked as 'mkfs.btrfs -f /dev/loop4' succeeds even
>   though /dev/loop1 has already been mounted and has
>   /root/disk-imgs/file-1.img as its backing file.
> 
> The above behaviour occurs because check_super() function returns an
> error code (due to stripesize not being set to 4096) and hence
> check_mounted_where() function treats /dev/loop1 as a disk containing a
> filesystem other than Btrfs.
> 
> Hence as a workaround this commit allows 4096 as a valid stripesize.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Applied, thanks.

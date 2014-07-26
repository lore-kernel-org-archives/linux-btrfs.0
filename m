Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:57579 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaGZHA1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Jul 2014 03:00:27 -0400
Message-ID: <53D35341.4080502@libero.it>
Date: Sat, 26 Jul 2014 09:05:37 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH not for integration] btrfs-devlist: dumps btrfs_device
 and btrfs_fs_devices from kernel
References: <1406291632-29582-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1406291632-29582-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/25/2014 02:33 PM, Anand Jain wrote:
> This would dump the following info:
> 
> fs_address dev_address dev_root_addr root_fsid
> fsid name uuid (seed_fsid@seed_addr sprout_fsid@sprout_addr) 
> 	(fs_num_devices fs_open_devices fs_rw_devices fs_missing_devices fs_total_devices) fs_total_rw_bytes fs_num_can_discard
> 	devid gen total_bytes disk_total_bytes bytes_used type io_align io_width sector_size fmode 
> 	not_fs_Mounted|not_fs_Seeding|not_fs_Rotating
> 	not_Writable|not_MD|not_Missing|not_Discard|not_Replace_tgt|not_Run_pending|not_Nobarriers|not_Stat_valid|not_Bdev
> 
> Applies on Chris integration branch now

Hi Anand,

why not export these information via sysfs ? 

BR
G.Baroncelli

> 
> Anand Jain (1):
>   btrfs: introduce BTRFS_IOC_GET_DEVS
> 
>  fs/btrfs/super.c           |  86 +++++++++++++++++++++++++++
>  fs/btrfs/volumes.c         | 145 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/volumes.h         |   3 +
>  include/uapi/linux/btrfs.h |  53 ++++++++++++++++-
>  4 files changed, 286 insertions(+), 1 deletion(-)
> 
> Anand Jain (1):
>   btrfs-progs: introduce btrfs-devlist
> 
>  .gitignore      |   1 +
>  Makefile        |   4 +-
>  btrfs-devlist.c | 268 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  ioctl.h         |  52 +++++++++++
>  4 files changed, 323 insertions(+), 2 deletions(-)
>  create mode 100644 btrfs-devlist.c
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

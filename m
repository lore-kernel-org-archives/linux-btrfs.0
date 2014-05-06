Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:44368 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaEFSIN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 14:08:13 -0400
Message-ID: <536925A7.4000201@libero.it>
Date: Tue, 06 May 2014 20:10:47 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
CC: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: [RFC PATCH 0/2] Kernel space btrfs missing device detection.
References: <1399357993-9254-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1399357993-9254-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

instead of extending the BTRFS_IOCTL_DEV_INFO ioctl, why do not add a field under /sys/fs/btrfs/<UUID>/ ? Something like /sys/fs/btrfs/<UUID>/missing_device

BR
G.Baroncelli

On 05/06/2014 08:33 AM, Qu Wenruo wrote:
> Original btrfs will not detection any missing device since there is
> no notification mechanism for fs layer to detect missing device in
> block layer.
> 
> However we don't really need to notify fs layer upon dev remove,
> probing in dev_info/rm_dev ioctl is good enough since they are the
> only two ioctls caring about missing device.
> 
> This patchset will do ioctl time missing dev detection and return
> device missing status in dev_info ioctl using a new member in
> btrfs_ioctl_dev_info_args with a backward compatible method.
> 
> Cc: Anand Jain <Anand.Jain@oracle.com> Qu Wenruo (2): btrfs: Add
> missing device check in dev_info/rm_dev ioctl btrfs: Add new member
> of btrfs_ioctl_dev_info_args.
> 
> fs/btrfs/ioctl.c           |  4 ++++ fs/btrfs/volumes.c         | 25
> ++++++++++++++++++++++++- fs/btrfs/volumes.h         |  2 ++ 
> include/uapi/linux/btrfs.h |  5 ++++- 4 files changed, 34
> insertions(+), 2 deletions(-)
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

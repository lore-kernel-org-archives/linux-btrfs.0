Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:33828 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3FKOYW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 10:24:22 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 6E7FE7C0054
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Jun 2013 08:24:22 -0600 (MDT)
Date: Tue, 11 Jun 2013 10:24:20 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Anand Jain <anand.jain@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] btrfs: add framework to read fs info and dev info
 from the kernel
Message-ID: <20130611142420.GB658@localhost.localdomain>
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
 <1370876355-16584-1-git-send-email-anand.jain@oracle.com>
 <1370876355-16584-3-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1370876355-16584-3-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 10, 2013 at 08:59:15AM -0600, Anand Jain wrote:
> This adds two ioctl BTRFS_IOC_GET_FSIDS and BTRFS_IOC_GET_DEVS
> which reads the btrfs_fs_devices and btrfs_device structure
> from the kernel respectively.
> 
> The information in these structure are useful to report the
> device/fs information in line with the kernel operations and
> thus immediately addresses the problem that 'btrfs fi show'
> command reports the stale information after device device add
> remove operation is performed. That is because btrfs fi show
> reads the disks directly.
> 
> Further the frame-work provided here would help to enhance
> the btrfs-progs/library to read the other fs information and
> its device information. Also the frame work provided here is
> easily extensible to retrieve any other structure as future
> needs.
> 
> v1->v2:
>   .code optimized
>   .get the device generation number as well, so that
>    btrfs-progs could print using print_one_uuid
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

In fact NACK altogether on this patch, you can get the same info out with the
TREE_SEARCH ioctl, just do that in btrfs-progs and don't add yet another ioctl.
Thanks,

Josef

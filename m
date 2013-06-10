Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:36656 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab3FJTke (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 15:40:34 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 32B0F9A0320
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 13:40:33 -0600 (MDT)
Date: Mon, 10 Jun 2013 15:40:30 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Anand Jain <anand.jain@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] btrfs: add framework to read fs info and dev info
 from the kernel
Message-ID: <20130610194030.GB10307@localhost.localdomain>
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

Please submit an xfstest along with this to test the new functionality so we
have something to test it with.  Make sure it runs properly if your patches are
not in place since they obviously won't be for most people.  Once you have an
xfstest I can properly test these patches.  Thanks,

Josef 

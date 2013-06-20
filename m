Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:42785 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736Ab3FTMYf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 08:24:35 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id F32B09A06B8
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 06:24:34 -0600 (MDT)
Date: Thu, 20 Jun 2013 08:24:32 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 4/4] Btrfs-progs: exhance btrfs-image to restore image
 onto multiple disks
Message-ID: <20130620122432.GA4288@localhost.localdomain>
References: <1371729930-22497-1-git-send-email-bo.li.liu@oracle.com>
 <1371729930-22497-5-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1371729930-22497-5-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 20, 2013 at 08:05:30PM +0800, Liu Bo wrote:
> This adds a 'btrfs-image -m' option, which let us restore an image that
> is built from a btrfs of multiple disks onto several disks altogether.
> 
> This aims to address the following case,
> $ mkfs.btrfs -m raid0 sda sdb
> $ btrfs-image sda image.file
> $ btrfs-image -r image.file sdc
> ---------
> so we can only restore metadata onto sdc, and another thing is we can
> only mount sdc with degraded mode as we don't provide informations of
> another disk.  And, it's built as RAID0 and we have only one disk,
> so after mount sdc we'll get into readonly mode.
> 

Um that shouldn't be happening, the restore will mask out the RAID parts of the
chunk tree and it should work just fine.  Are you using the most recent version
of btrfs-image?  If this is happening it's a bug and we need to fix it, but I've
restored several file systems from users with raid0/10 file systems onto a
single disk and it's worked just fine.  Thanks,

Josef

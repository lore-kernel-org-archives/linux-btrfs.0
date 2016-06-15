Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43826 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753287AbcFOKUk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 06:20:40 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5FAEHIU062525
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 06:20:39 -0400
Received: from e28smtp08.in.ibm.com (e28smtp08.in.ibm.com [125.16.236.8])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23jgmnnb0a-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 06:20:39 -0400
Received: from localhost
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 15 Jun 2016 15:50:36 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 658213940060
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 15:50:31 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u5FAKOXv19530166
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 15:50:24 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u5FAKS5Q026211
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 15:50:30 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] Btrfs: let super_stripesize match with sectorsize
Date: Wed, 15 Jun 2016 15:50:17 +0530
In-Reply-To: <1561797.nA26SuRYQT@localhost.localdomain>
References: <1465940023-27773-1-git-send-email-bo.li.liu@oracle.com> <1561797.nA26SuRYQT@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2040012.GtZQCNmHYt@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, June 15, 2016 09:12:28 AM Chandan Rajendra wrote:
> Hello Liu Bo,
> 
> We have to fix the following check in check_super() as well,
> 
>        if (btrfs_super_stripesize(sb) != 4096) {
>                 error("invalid stripesize %u", btrfs_super_stripesize(sb));
>                 goto error_out;
>         }
> 
> i.e. btrfs_super_stripesize(sb) must be equal to
> btrfs_super_sectorsize(sb).
> 
> However in btrfs-progs (mkfs.c to be precise) since we had stripesize
> hardcoded to 4096, setting stripesize to the value of sectorsize in
> mkfs.c will cause the following to occur when mkfs.btrfs is invoked for
> devices with existing Btrfs filesystem instances,
> 
> NOTE: Assume we have changed the stripesize validation in btrfs-progs'
> check_super() to,
> 
>         if (btrfs_super_stripesize(sb) != btrfs_super_sectorsize(sb)) {
>                 error("invalid stripesize %u", btrfs_super_stripesize(sb));
>                 goto error_out;
>         }
> 
> 
> main()
>  for each device file passed as an argument,
>    test_dev_for_mkfs()
>      check_mounted
>        check_mounted_where
>          btrfs_scan_one_device
>            btrfs_read_dev_super
>              check_super() call will fail for existing filesystems which
> have stripesize set to 4k. All existing filesystem instances will fall into
> this category.
> 
> This error value is pushed up the call stack and this causes the device to
> not get added to the fs_devices_mnt list in check_mounted_where(). Hence we
> would fail to correctly check the mount status of the multi-device btrfs
> filesystems.
> 


We can end up in the following scenario,
- /dev/loop0, /dev/loop1 and /dev/loop2 are mounted as a single
  filesystem. The filesystem was created by an older version of mkfs.btrfs
  which set stripesize to 4k. 
- losetup -a
   /dev/loop0: [0030]:19477 (/root/disk-imgs/file-0.img)  
   /dev/loop1: [0030]:16577 (/root/disk-imgs/file-1.img)  
   /dev/loop2: [64770]:3423229 (/root/disk-imgs/file-2.img)  
- /etc/mtab lists only /dev/loop0
- "losetup /dev/loop4 /root/disk-imgs/file-1.img"
   The new mkfs.btrfs invoked as 'mkfs.btrfs -f /dev/loop4' succeeds even
   though /dev/loop1 has already been mounted and has
   /root/disk-imgs/file-1.img as its backing file.

So IMHO the only solution is to have the stripesize check in check_super() to
allow both '4k' and 'sectorsize' as valid values i.e.

        if ((btrfs_super_stripesize(sb) != 4096)
	    && (btrfs_super_stripesize(sb) != btrfs_super_sectorsize(sb))) {
                error("invalid stripesize %u", btrfs_super_stripesize(sb));
                goto error_out;
        }
-- 
chandan


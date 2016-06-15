Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11567 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801AbcFODmj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 23:42:39 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5F3e3IU093878
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 23:42:39 -0400
Received: from e28smtp05.in.ibm.com (e28smtp05.in.ibm.com [125.16.236.5])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23jgmn93yf-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 23:42:38 -0400
Received: from localhost
	by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 15 Jun 2016 09:12:36 +0530
Received: from d28relay07.in.ibm.com (d28relay07.in.ibm.com [9.184.220.158])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id B5E913940061
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 09:12:33 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay07.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u5F3gXP427852900
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 09:12:33 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u5F3gWm7030490
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 09:12:33 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] Btrfs: let super_stripesize match with sectorsize
Date: Wed, 15 Jun 2016 09:12:28 +0530
In-Reply-To: <1465940023-27773-1-git-send-email-bo.li.liu@oracle.com>
References: <1465940023-27773-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <1561797.nA26SuRYQT@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, June 14, 2016 02:33:43 PM Liu Bo wrote:
> Right now stripesize is set to 4096 while sectorsize is set to
> max(4096, pagesize).  However, kernel requires super_stripesize
> to match with sectorsize.
> 
> Reported-by: Eryu Guan <guaneryu@gmail.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  mkfs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mkfs.c b/mkfs.c
> index a3a3c14..8d00766 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1482,6 +1482,8 @@ int main(int argc, char **argv)
>  	}
> 
>  	sectorsize = max(sectorsize, (u32)sysconf(_SC_PAGESIZE));
> +	stripesize = sectorsize;
> +
>  	saved_optind = optind;
>  	dev_cnt = argc - optind;
>  	if (dev_cnt == 0)

Hello Liu Bo,

We have to fix the following check in check_super() as well,

       if (btrfs_super_stripesize(sb) != 4096) {
                error("invalid stripesize %u", btrfs_super_stripesize(sb));
                goto error_out;
        }

i.e. btrfs_super_stripesize(sb) must be equal to
btrfs_super_sectorsize(sb).

However in btrfs-progs (mkfs.c to be precise) since we had stripesize
hardcoded to 4096, setting stripesize to the value of sectorsize in
mkfs.c will cause the following to occur when mkfs.btrfs is invoked for
devices with existing Btrfs filesystem instances,

NOTE: Assume we have changed the stripesize validation in btrfs-progs'
check_super() to,

        if (btrfs_super_stripesize(sb) != btrfs_super_sectorsize(sb)) {
                error("invalid stripesize %u", btrfs_super_stripesize(sb));
                goto error_out;
        }


main()
 for each device file passed as an argument,
   test_dev_for_mkfs()
     check_mounted
       check_mounted_where
         btrfs_scan_one_device
           btrfs_read_dev_super
             check_super() call will fail for existing filesystems which have
             stripesize set to 4k. All existing filesystem instances will fall
             into this category.

This error value is pushed up the call stack and this causes the device to not
get added to the fs_devices_mnt list in check_mounted_where(). Hence we would
fail to correctly check the mount status of the multi-device btrfs
filesystems.

I will try to figure out a solution to this problem.

-- 
chandan


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36689 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3FYIfg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Jun 2013 04:35:36 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5P8ZZ7d002848
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Jun 2013 08:35:35 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5P8ZYeD027407
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Jun 2013 08:35:35 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5P8ZYCN003534
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Jun 2013 08:35:34 GMT
Message-ID: <51C9575A.1000403@oracle.com>
Date: Tue, 25 Jun 2013 16:39:54 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 12/13] btrfs-progs: obtain used_bytes in BTRFS_IOC_FS_INFO
 ioctl
In-Reply-To: <1371801485-14571-5-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1371801485-14571-1-git-send-email-anand.jain@oracle.com>
 <1371801485-14571-5-git-send-email-anand.jain@oracle.com>


kindly ignore this patch, the feature now is implemented
without adding any _new_ ioctl or _new_ parameters.

Thanks, Anand


On 06/21/2013 03:58 PM, Anand Jain wrote:
> btrfs-progs has to read fs info from the kernel to
> read the latest info instead of reading it from the disks,
> which generally is a stale info after certain critical
> operation.
>
> getting used_bytes parameter will help to fix
>        btrfs filesystem show --kernel
> to show the current info of the fs
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>   ioctl.h | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/ioctl.h b/ioctl.h
> index a40a4a1..d035201 100644
> --- a/ioctl.h
> +++ b/ioctl.h
> @@ -169,7 +169,8 @@ struct btrfs_ioctl_fs_info_args {
>   	__u64 max_id;				/* out */
>   	__u64 num_devices;			/* out */
>   	__u8 fsid[BTRFS_FSID_SIZE];		/* out */
> -	__u64 reserved[124];			/* pad to 1k */
> +	__u64 used_bytes;			/* out */
> +	__u64 reserved[123];			/* pad to 1k */
>   };
>
>   /* balance control ioctl modes */
>

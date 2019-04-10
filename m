Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 411B4C10F14
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 15:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1045E2082E
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 15:11:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MiDuJv8a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733053AbfDJPLn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 11:11:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46810 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733021AbfDJPLm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 11:11:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3AF3o1S133576;
        Wed, 10 Apr 2019 15:11:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=pvviq/8w+OCF5ey3WMTxmPBlvXnn7k03Hvzq+b0NS8k=;
 b=MiDuJv8aSM4uArz0jiPL3Vbgeu2spaO7tOm0gyTPG4+oLTBwIUlqXL6g9BHHFVFuWBfW
 ArFCUik5cooUlkA5DKERWKlrKh8mhxCeT+ykCyrpB/Hzc6uZM0QpZtNY0Zo/k3vHmeKu
 gihk/hIPjLBi2EkEYRGk2daOSl5KQo9F/+S2a/GRp50HDpUAomxiNu5lotxEPvMJzoDl
 W4spmZnmXKp6jzVOM72BjPn9e/+bbmNqH8SK2gy92sXO9EDDdSnjpeunMBDDsTbkslPC
 bdY2ApAzBSXay4hhwyp37Tn2lE9bTiwaNZB3LAWW8UHQISwOELZJyZdIasJQr5oQIvnq 0w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2rpkht3sbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Apr 2019 15:11:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3AFBbUj016952;
        Wed, 10 Apr 2019 15:11:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2rpj5b8ac9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Apr 2019 15:11:37 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3AFBZ71002787;
        Wed, 10 Apr 2019 15:11:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Apr 2019 08:11:35 -0700
Date:   Wed, 10 Apr 2019 08:11:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] errno.h: Export EFSCORRUPTED error number
Message-ID: <20190410151134.GG1177@magnolia>
References: <20190410083508.21091-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410083508.21091-1-wqu@suse.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9223 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904100107
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9223 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904100107
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 10, 2019 at 04:35:07PM +0800, Qu Wenruo wrote:
> Xfs and Ext* uses EFSCORRUPTED to indicate filesystem corruption.
> They both map EFSCORRUPTED to EUCLEAN.
> 
> Btrfs/Ubifs/fscrypto all use EUCLEAN directly to indicate filesystem
> corruption.

I don't know if you (btrfs folks specifically) care but ext* and xfs
also use EFSBADCRC to signal unrecovered checksum validation failures.
Can we promote both of them to asm-generic/errno.h at the same time?

#define EFSBADCRC   EBADMSG

--D

> And block layer is going to distinguish filesystem corruption with
> oridinary EIO error, it's a good idea to export the initial EFSCORRUPTED
> declaration to <linux/errno.h> so all filesystems and block layer can
> take advantage of this easier-to-read error number.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/ext2/ext2.h                   | 1 -
>  fs/ext4/ext4.h                   | 1 -
>  fs/xfs/xfs_linux.h               | 1 -
>  include/uapi/asm-generic/errno.h | 3 +++
>  4 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index 10ab238de9a6..03d0ca8fae42 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -369,7 +369,6 @@ struct ext2_inode {
>   */
>  #define	EXT2_VALID_FS			0x0001	/* Unmounted cleanly */
>  #define	EXT2_ERROR_FS			0x0002	/* Errors detected */
> -#define	EFSCORRUPTED			EUCLEAN	/* Filesystem is corrupted */
>  
>  /*
>   * Mount flags
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 82ffdacdc7fa..f906b5cbf96d 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3248,6 +3248,5 @@ extern const struct iomap_ops ext4_iomap_ops;
>  #endif	/* __KERNEL__ */
>  
>  #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
> -#define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
>  
>  #endif	/* _EXT4_H */
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index edbd5a210df2..36e5c6549f15 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -125,7 +125,6 @@ typedef __u32			xfs_nlink_t;
>  
>  #define ENOATTR		ENODATA		/* Attribute not found */
>  #define EWRONGFS	EINVAL		/* Mount with wrong filesystem type */
> -#define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
>  #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
>  
>  #define SYNCHRONIZE()	barrier()
> diff --git a/include/uapi/asm-generic/errno.h b/include/uapi/asm-generic/errno.h
> index cf9c51ac49f9..ebd6e7e76a98 100644
> --- a/include/uapi/asm-generic/errno.h
> +++ b/include/uapi/asm-generic/errno.h
> @@ -98,6 +98,9 @@
>  #define	EINPROGRESS	115	/* Operation now in progress */
>  #define	ESTALE		116	/* Stale file handle */
>  #define	EUCLEAN		117	/* Structure needs cleaning */
> +
> +#define EFSCORRUPTED	EUCLEAN	/* Filesystem is corrupted */
> +
>  #define	ENOTNAM		118	/* Not a XENIX named type file */
>  #define	ENAVAIL		119	/* No XENIX semaphores available */
>  #define	EISNAM		120	/* Is a named type file */
> -- 
> 2.21.0
> 

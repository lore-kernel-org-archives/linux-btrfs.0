Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE8E1C10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 03:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 835F820883
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 03:25:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PVryQMvG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfDHDZY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Apr 2019 23:25:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53614 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfDHDZY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2019 23:25:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x383OE7L124984;
        Mon, 8 Apr 2019 03:25:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=NhnZQRIvSMZrVNvTdUsCDTSkksfBzIZXFVjlMqJ7bA8=;
 b=PVryQMvGA30tjsQiivFM+bHFAGnMYBVO0ocJYnx4x2+tj3YYXY0xzG7l74FjZSQTH9bg
 s3dI+FgHrTHMy4fBjWnVpbGf8w07/Sr/u56VvIp0r26ZO7cZB9cSGUdF9MPC8SnP5EQ0
 E1hWExeB9Ze8yFHHr5YHjO9f8bcx5RGNyCzH7VvX1iC67pecV5AqWA22aqQS8WRJcRwJ
 7PlBW5ekTAt8Nqh/ySQLOsgNjCdf3VDJjGXr95iINJAAVE3+b4S/ofpdIHXQIPXROA/T
 m9O3TrxTy314P3oBDf7RNKWBg4Y5H3FHtvS+Vghfux/BT01Iy4veNB8W5mCDcbSYCku/ 3w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2rpkhskqy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Apr 2019 03:25:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x383Nu8L168003;
        Mon, 8 Apr 2019 03:25:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2rpkehg6fn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Apr 2019 03:25:19 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x383PItu010871;
        Mon, 8 Apr 2019 03:25:19 GMT
Received: from [10.190.130.106] (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Apr 2019 20:25:18 -0700
Subject: Re: [PATCH 0/4] property fixes and cleanups
To:     dsterba@suse.cz
Cc:     linux-btrfs@vger.kernel.org
References: <20190403165134.12378-1-anand.jain@oracle.com>
From:   Anand Jain <Anand.Jain@oracle.com>
Message-ID: <cad4c802-b335-6c2b-fc59-5d817ad70835@oracle.com>
Date:   Mon, 8 Apr 2019 11:25:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190403165134.12378-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9220 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904080029
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9220 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904080029
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 4/4/19 12:51 AM, Anand Jain wrote:
> Both mainline and misc-5.2 fails the test case that transaction
> generation number must be unaltered if the property validation fails.
> 
> For example:
> btrfs in dump-super /dev/sdb | grep ^generation; \
> btrfs prop set /btrfs compression lz; sync; \
> btrfs in dump-super /dev/sdb | grep ^generation
> generation		53
> ERROR: failed to set compression for /btrfs: Invalid argument
> generation		54
> 
> Which the patch in the mailing list fixes and based on misc-5.2
>    [PATCH 4/4 RESEND] btrfs: fix property validate fail should not increment
> 
> But, now I notice that the reason for which the original code failed
> is different from the reason for which misc-5.2 failed. Former failed
> because the malformed 'lz' was only abled to be caught by handle->apply(),
> and in latter we were calling the start_transaction() too early before the
> handle->validation() which few of the patches in misc-5.1 did. My bad.
> 
> As per your misc-5.2 branch please drop the following patches as I have
> better fixes as in this patch.
> 
> 584aebf26bbf btrfs: merge btrfs_setxattr and do_setxattr
> ab54ee38fff7 btrfs: don't create transaction in btrfs_setxattr
> 0cbf560f72e1 btrfs: start transaction in btrfs_xattr_handler_set
> db0f220e98eb btrfs: start transaction in btrfs_set_acl
> 56e9e992c00a btrfs: start transaction in btrfs_set_prop_trans
> 3e2299ea6a8b btrfs: refactor btrfs_set_prop and add btrfs_set_prop_trans
> 737e67ce0f3f btrfs: merge _btrfs_set_prop helpers
> 
> And please apply the patches as in this set.
> 
> Anand Jain (4):
>    btrfs: rename __btrfs_set_prop to btrfs_set_prop_trans
>    btrfs: rename __btrfs_set_acl to do_set_acl
>    btrfs: fix zstd compression parameter
>    btrfs: fix vanished compression property after failed set
> 
>   fs/btrfs/acl.c   | 12 +++++-------
>   fs/btrfs/props.c | 23 ++++++++++-------------
>   2 files changed, 15 insertions(+), 20 deletions(-)
> 

Ping?

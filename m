Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 353B4C282CC
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 07:31:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0499021924
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 07:31:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SEkZUIeW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfBHHbf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 02:31:35 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56504 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfBHHbf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2019 02:31:35 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x187SeDU191638;
        Fri, 8 Feb 2019 07:31:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=i1ywLoqoov+t4cb/MWXl+dq52wtRBgwyj9EbrzJ1ehc=;
 b=SEkZUIeWlRKeNXwR1f+uPHYVmspr4W+M0iPTIlRPBxpuWy2SBwfwS1Sb9uQuZDk/QbrR
 Pvn/nXzVUhdF93WsEQk1iFK0RW5XjDbbGE7Qzlrf5VqSOR3mesaYYplHaVz+L0jeCVsK
 8rWZM8uiCFIzFCU1bFi5AsNkFGbYWv2rff93Xuh88s0bedRgrS4zZTT7cfUg5OP0DXxU
 lZKq27/P4XPV3aXTLe+5kOUkVVKBmV8zLxdqvuAJNzvwDf8m/URnWWJLbj4CRo3Yi4rk
 WFMPbC3Li7hvXwkhA5VFignSRw1PLL39kd4xzZKZHiU9JJfv+aI870f4cY6/G8PnneKa HQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2qd97fb2b5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Feb 2019 07:31:31 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x187VUsE001130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Feb 2019 07:31:30 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x187VTAs004776;
        Fri, 8 Feb 2019 07:31:29 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Feb 2019 23:31:29 -0800
Subject: Re: [PATCH 0/5] Misc props.c cleanups
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1549609355-11053-1-git-send-email-anand.jain@oracle.com>
 <b8e25617-15ff-0a5e-7d9d-d2ad7e070887@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <bdcbdf67-d2eb-b5bc-06d1-d26f8fe1f7f9@oracle.com>
Date:   Fri, 8 Feb 2019 15:31:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <b8e25617-15ff-0a5e-7d9d-d2ad7e070887@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9160 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902080055
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2/8/19 3:15 PM, Nikolay Borisov wrote:
> 
> 
> On 8.02.19 г. 9:02 ч., Anand Jain wrote:
>> While adding the readmirror property found few cleanup things which
>> can be fixed. As these aren't part of upcoming readmirror property
>> I am sending these separately. Except for 1/5 rest fixes are in
>> props.c. 1/5 is in volume.c.
>>
>> Anand Jain (5):
>>    btrfs: fix comment its device list mutex not volume lock
>>    btrfs: kill __btrfs_set_prop()
>>    btrfs: reorg functions to drop forward declaration
>>    btrfs: drop redundant forward declaration in props.c
>>    btrfs: trivial, fix c coding style
>>
>>   fs/btrfs/ioctl.c   |  10 +--
>>   fs/btrfs/props.c   | 201 ++++++++++++++++++++++++-----------------------------
>>   fs/btrfs/props.h   |   6 +-
>>   fs/btrfs/volumes.c |   2 +-
>>   fs/btrfs/xattr.c   |   2 +-
>>   5 files changed, 100 insertions(+), 121 deletions(-)
>>
> 
> Allow me to suggest to introduce another patch with the following hunk:
> 
> diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
> index ea78c3d6dcfc..37e9af2a9f8c 100644
> --- a/fs/btrfs/xattr.c
> +++ b/fs/btrfs/xattr.c
> @@ -229,12 +229,11 @@ int btrfs_setxattr(struct btrfs_trans_handle *trans,
>          if (btrfs_root_readonly(root))
>                  return -EROFS;
> 
> -       if (trans)
> -               return do_setxattr(trans, inode, name, value, size, flags);
> -
> -       trans = btrfs_start_transaction(root, 2);
> -       if (IS_ERR(trans))
> -               return PTR_ERR(trans);
> +       if (!trans) {
> +               trans = btrfs_start_transaction(root, 2);
> +               if (IS_ERR(trans))
> +                       return PTR_ERR(trans);
> +       }
> 
>          ret = do_setxattr(trans, inode, name, value, size, flags);
>          if (ret)
> 
> 
> This just inverts the logic for !trans and makes the code a bit more
> linear and (IMO) easier to follow.
> 


Thanks for the comments.

But we still have to break the linear flow for the case of
  trans != NULL. Where we don't do the
    inode_inc_iversion(inode);
and the rest part.

-Anand



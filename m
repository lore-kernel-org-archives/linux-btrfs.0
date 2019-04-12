Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CB28C10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 09:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2ABEC205F4
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 09:33:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jEUec5I3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfDLJdi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 05:33:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35806 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfDLJdi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 05:33:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C9TA9C167212
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 09:33:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=YkIaCK8rAp+72qmQyrLQUfj0ZYrUC7LfiO4Q2tQrEjQ=;
 b=jEUec5I39yn4CKv1VTAyMqOu2RuX3Y65109ncdYtZCzaTkrGVGfTbzQbRFD3eOrzQLW2
 TxS0THbCqhh73UJR/TIH6GmP4osx7yu9Ty2RPqKfw/NNoDDC3JMdDTcAD3cPGH3wgUDD
 liniOanNi0X9F/5k61PUk6aouxx/Tlrk7PWB6PaFT5AlODyAXHdjmafVcrw+2C+XWgeO
 3o8h2FfgdD1GkrDuujZst7K4BkxQ9xXTz72biWd+m7vkTFnhUBSSrhUJFoKTQ6XVKkhb
 UNqG1WnznGUyl+HD7Udwx5nCVCeuFB6Zh0UhJxJWuI+OqBqlQm+u2lOSzE5YGaweiBqq 1Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2rpmrqnem0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 09:33:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C9Vi0B135144
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 09:33:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2rt9uq2khk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 09:33:36 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3C9XYhc010891
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 09:33:35 GMT
Received: from [10.190.130.106] (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Apr 2019 02:33:34 -0700
Subject: Re: [PATCH 0/6] cleanup property and extended attribute set
To:     linux-btrfs@vger.kernel.org
References: <20190412080259.5192-1-anand.jain@oracle.com>
From:   Anand Jain <Anand.Jain@oracle.com>
Message-ID: <6e44349e-f357-c8a3-016b-4c09e96d52d8@oracle.com>
Date:   Fri, 12 Apr 2019 17:33:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190412080259.5192-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9224 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=991
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904120063
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9224 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904120063
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

just a note: this is based on misc-next.

On 12/4/19 4:02 PM, Anand Jain wrote:
> In an attempt to stream line the property and extended attribute set here
> are the few cleanup patches.
> 
>   1/6 to 3/6 are mostly non functional cleanups (except for the conversion
>    to non static function in 3/6) and can be merged together.
>   4/6 removes the readonly root check in btrfs_setxattr() more details in
>    the change log.
>   5/6 as now we have btrfs_setxattr() and btrfs_setxattr_trans() for the
>    threads with transaction and without transaction respectively, so this
>    patch uses them.
>   6/6 as 5/6 as diverted the threads with transaction to btrfs_setxattr(),
>    now btrfs_setxattr_trans() can drop the trans arg.
> 
> Anand Jain (6):
>    btrfs: rename btrfs_setxattr to btrfs_setxattr_trans
>    btrfs: rename do_setxattr to btrfs_setxattr
>    btrfs: declare btrfs_setxattr as a non static function
>    btrfs: remove redundant readonly root check in btrfs_setxattr_trans
>    btrfs: split thread with trans to use btrfs_setxattr
>    btrfs: cleanup btrfs_setxattr_trans drop trans arg
> 
>   fs/btrfs/acl.c   |  6 +++++-
>   fs/btrfs/props.c | 25 +++++++++++++++++++------
>   fs/btrfs/xattr.c | 25 ++++++++++---------------
>   fs/btrfs/xattr.h |  7 ++++---
>   4 files changed, 38 insertions(+), 25 deletions(-)
> 


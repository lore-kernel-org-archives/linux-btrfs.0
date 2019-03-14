Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7474BC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 09:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C585205F4
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 09:09:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="al9UYnwy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfCNJJD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 05:09:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52682 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbfCNJJC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 05:09:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2E8ww0G064937;
        Thu, 14 Mar 2019 09:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Oxp6xxQsLBsXZYo46HM5Cp9IJG17Ksu4v0BJoVKbG4s=;
 b=al9UYnwyDRjcHje+hpsv1LSNCw8v2lUppxtZ4mdlLEg3GpsWd9v9/V70nC7UYHTjT0b2
 gCx3qF4ZcOZBIGTpbglk4mNe8d/QLoeiD+ng93kJFYpFEjaqU7RZNGdV75pdtAwRWmCy
 ogVvj9+UqQF72sny6GpND6+VgY0W5KmoXeSbXhJGWLzfj0ptnYTKvF2FWL3RzGN8TtOM
 2GruWe3ivvHXB0i69wRU4WE8EdLZeohum5Ja7VUi3LcrYKGxPxq7ocyGBe52UcI6qeEu
 eBnxIoYPpjQAb5DcrNaKkHgOsA++Bkgf9xbv+me9Nq4JLMpbQboqf0hQRDCtYSLUj1Pj pw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2r464rqqd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Mar 2019 09:08:58 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2E98vvo010338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Mar 2019 09:08:58 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2E98v68029946;
        Thu, 14 Mar 2019 09:08:57 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Mar 2019 09:08:57 +0000
Subject: Re: [PATCH 3/4] btrfs: open code btrfs_set_prop in inherit_prop
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1552539906-29703-1-git-send-email-anand.jain@oracle.com>
 <1552539906-29703-4-git-send-email-anand.jain@oracle.com>
 <b31f898f-e561-326f-733c-25d92f549009@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <02796a8f-5e37-3295-bd93-805fce46ccb5@oracle.com>
Date:   Thu, 14 Mar 2019 17:08:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <b31f898f-e561-326f-733c-25d92f549009@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9194 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903140063
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/14/19 4:57 PM, Nikolay Borisov wrote:
> 
> 
> On 14.03.19 г. 7:05 ч., Anand Jain wrote:
>> When an inode inherits property from its parent, we call btrfs_set_prop().
>> btrfs_set_prop() does an elaborate checks, which is not required in the
>> context of inheriting a property. Instead just open-code only the required
>> items from btrfs_set_prop() and then call btrfs_setxattr() directly. So
>> now the only user of btrfs_set_prop() is gone, (except for the wraper
>> function btrfs_set_prop_trans()).
> 
> Um, no:
> 
> git grep -P '(?<!__)btrfs_set_prop' fs/btrfs/
> fs/btrfs/ioctl.c:               ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
> fs/btrfs/ioctl.c:               ret = btrfs_set_prop(inode, "btrfs.compression",
> fs/btrfs/ioctl.c:               ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
> fs/btrfs/props.c:int btrfs_set_prop(struct inode *inode,
> fs/btrfs/props.h:int btrfs_set_prop(struct inode *inode,
> fs/btrfs/xattr.c:       return btrfs_set_prop(inode, name, value, size, flags);
> 
> 
> Rebase the patch on misc-next and remove the last sentence
> since it's factually wrong.

  Oh. This is based on misc-5.2.
  Oops I should have mentioned.

Thanks. Anand

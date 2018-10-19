Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D10ECC67863
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 00:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A94D20C0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 00:48:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Oe5DzcQU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A94D20C0E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbeJSIv6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 04:51:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43366 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbeJSIv6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 04:51:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9J0cpDM159648;
        Fri, 19 Oct 2018 00:48:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=yAG7Rd3PSRwoAFNE+aPta8+0uHHGYzYEVVm+PD6zZkU=;
 b=Oe5DzcQUGAFa3z2dnSz0M1ENFAcDIuQ0uKLjxFdtMTLS3QEhlnVaIFaCVWhG8pcKjbhh
 d6mAobRLS9FmC7lKNpee0dTTYVLOkH9aPv5lyII5NiaDXB06ggbIOBLr/+O7GICiCBS2
 U4VQsk9y1Ivn9+B6zCj5cTb7EXiQluNqrhPyKV3eK3ItKyewafEACfOF49jzwC2m4N3B
 itklCWdBKVYRZFsbqL5T3zCFkqSEZUGVzIjE/q8uCo8q8FVf97UjFcsDGkBiKtF0JDUl
 Xu1yfAIxzFxFqVtp0DEM0AAZm5Yg5RnAC1ps7ZbdfFjrwYp60OzqGPNlxJFMetIP8pUA YA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2n39brse8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Oct 2018 00:48:18 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9J0mCtC021733
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Oct 2018 00:48:12 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9J0mC8g012442;
        Fri, 19 Oct 2018 00:48:12 GMT
Received: from [192.168.0.120] (/202.156.136.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Oct 2018 17:48:11 -0700
Subject: Re: reproducible builds with btrfs seed feature
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtTPwQnzwkpk=4ZsZXfWTC7HymYETxp-9xUU_tsvOTW0ZQ@mail.gmail.com>
 <11171664-790c-40ff-3925-1c179ab8e74b@oracle.com>
 <CAJCQCtSfuLTsxXfEkmz59PrOJ3LrXmGNG+_NKS_LPk9dHTgkug@mail.gmail.com>
 <d63839e6-6d76-2457-cbe5-7e5a60181d23@oracle.com>
 <CAJCQCtTu0pjAY8k3L=YK0CCv7MvDepUBafMDqf1mBvJbNdFnkg@mail.gmail.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <d4363456-241d-8631-df21-8a6fe8af72b1@oracle.com>
Date:   Fri, 19 Oct 2018 08:47:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTu0pjAY8k3L=YK0CCv7MvDepUBafMDqf1mBvJbNdFnkg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9050 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810190005
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/19/2018 02:02 AM, Chris Murphy wrote:
> On Tue, Oct 16, 2018 at 10:08 PM, Anand Jain <anand.jain@oracle.com> wrote:
> 
> 
>>
>>   So a possible solution for the reproducible builds:
>>     usual mkfs.btrfs dev
>>     Write the data
>>     unmount; create btrfs-image with uuid/fsid/time sanitized; mark it as a
>> seed (RO).
>>     check/verify the hash of the image.
> 
> Gotcha. Generation/transid needs to be included in that list. Imagine
> a fast system vs a slow system. The slow system certainly will end up
> with with higher transid's for the latest completed transactions.

  In a scripted build environment the transid could remain same, as 
there won't extra sync or mount -o transid changes.. etc.

> But also, I don't know how the kernel code chooses block numbers,
> either physical (chunk allocation) or logical (extent allocation) and
> if that could be made deterministic. Same for inode assignment.

  The above list may not be complete. To avoid the disk size,type 
related changes one can choose to create a mkfs on a file instead of 
disk. But the point I am trying to make with bytenr is if a tool uses 
certain items which are not explicitly EXPORTED/ioctl, that means it can 
change without notice, unless these tools are inline with the btrfs 
kernel changes it would break.

> Another question that comes up later when creating the sprout by
> removing the seed device, is how a script can know when all block
> groups have successfully copied from seed to sprout, and that the
> sprout can be unmounted.

  Oh.
    mount -o loop seed.img /seed  <-- this will be RO
    btrfs device add /dev/sprout /seed <-- new FSID on the same mount 
point, /dev/sprout will have new SB with new FSID, and sprout device 
count will include the seed device. And originally this was RW already 
but we broke it somewhere. But not a big deal as we can use remount.
    mount -o remount,rw /dev/sprout /seed <-- this is RW. Only _new_ 
writes goes to /dev/sprout, and sprout still needs seed to mount.
    btrfs device delete <seed-devid> /seed <-- this will transfer all 
seed blocks to /dev/sprout.

    Now /dev/sprout is an independent RW FS with the contents from the 
seed and its total device count is now 1.

Thanks, Anand
> 
> 
> 

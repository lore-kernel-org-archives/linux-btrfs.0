Return-Path: <SRS0=iEal=RZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333B2C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 06:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBBEF213F2
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 06:08:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ks5ZIOMo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbfCVGIc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Mar 2019 02:08:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46154 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727632AbfCVGIb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Mar 2019 02:08:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2M5sNVY104692;
        Fri, 22 Mar 2019 06:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=cyxMk3EVj9e1VvTvSVK1hbV4vfwVXDEchdqL+/Ah0U4=;
 b=Ks5ZIOMoBQGB/i3oMRqBIB7N/2i1QeGrDCg8htGuPx5j/kBZkbBJV8RtXaSsZhrsdIFr
 E3SEYku1lxuYP2TSXsGH/2FxN/Bjq3WsKtYJCPVCo+BJ6Dk5YnqryaHrZvfDAslS6Slj
 BZu7q96da5GvmAMZr7AEjOHV+Ml80VAoO7GmnAkperVzss4R20VQ7JixBO1nu6ULhRpH
 z4IjAsDz3n+/VN87qnf8prP6MbVnCcvkHmTlWVpQ1i4myrchGH84pqFC23rmx5GferBH
 k/SAflWZaivHDFYaIH602YsvxlVHlDeHWnIB1pMHVO0C5HcBkY3fHFU6T0O2yofZloWT 5g== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2r8rjv45tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Mar 2019 06:08:25 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2M68J2G022018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Mar 2019 06:08:19 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2M68I9Y010768;
        Fri, 22 Mar 2019 06:08:18 GMT
Received: from [10.186.49.135] (/10.186.49.135)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Mar 2019 23:08:17 -0700
Subject: Re: [PATCH RFC 0/5] readmirror feature
To:     Steven Davies <btrfs-list@steev.me.uk>
Cc:     linux-btrfs@vger.kernel.org
References: <1552989624-29577-1-git-send-email-anand.jain@oracle.com>
 <d7b84e2bcb9920d011e585391b70020e@steev.me.uk>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <2cdc8fc6-797a-d420-3aaa-a15e06c677d5@oracle.com>
Date:   Fri, 22 Mar 2019 14:08:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <d7b84e2bcb9920d011e585391b70020e@steev.me.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9202 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903220046
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/22/19 12:26 AM, Steven Davies wrote:
> On 2019-03-19 10:00, Anand Jain wrote:
>> RFC patch as of now, appreciate your comments. This patch set has
>> been tested.
>>
>> Function call chain  __btrfs_map_block()->find_live_mirror() uses
>> thread pid to determine the %mirror_num when the mirror_num=0.
>>
>> The pid based mirror_num extrapolation has following disadvantages
>>  . A large single-process read IO will read only from one disk.
>>  . In a worst scenario all processes read accessing the FS could have
>>        either odd or even pid, the read IO gets skewed.
>>  . There is no deterministic way of knowing/controlling which copy will
>>        be used for reading.
>>  . May see performance variations for a given set of multi process
>>        workload ran at different times.
>>
>> So we need other types of readmirror policies.
>>
>> This patch introduces a framework so that we can add more policies, and
>> converts the existing %pid into as a configurable parameter using the
>> property. And also provides a transient readmirror mount option, so that
>> this property can be applied for the read io during mount and for
>> readonly FS.
> 
> Is it possible to set this property at mkfs time?

  Possible.

>>  For example:
>>    btrfs property set <mnt> readmirror pid
>>    btrfs property set <mnt> readmirror ""
>>    btrfs property set <mnt> readmirror devid<n>
>>
>>    mount -o readmirror=pid <mnt>
>>    mount -o readmirror=devid<n> <mnt>
> 
> This is an edge case but should we be allowed to set more than one 
> device as a read mirror in a 3+ device array? In theory there could be 
> two fast disks and one slow disk where all stripes are guaranteed to be 
> on at least one fast disk.

  Right. We need to evolve the device grouping part to get this.

> I'll test these patches out when I have some spare time over the next 
> few weeks. Do you have a tree I can pull / what are the patches based on?

   Thanks for the tests. Sure will upload and send the link.

> Way beyond this patch series, considering a 3+ device raid1 array with 
> mixed fast and slow disks perhaps there could also be a write preference 
> for disks to fill up the fast disks first.

   Right.

Thanks
Anand

> Steven Davies

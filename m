Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F792C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 00:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6C222146E
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 00:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CIl0+ctE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfDCAea (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 20:34:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34140 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfDCAea (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 20:34:30 -0400
X-Greylist: delayed 5478 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Apr 2019 20:34:28 EDT
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x330EA12153936;
        Wed, 3 Apr 2019 00:34:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=dMXwhWKuSD45Qoa6cuJD8pN92busyCmV/h1mlzYw7LQ=;
 b=CIl0+ctEqdvoCUZY01mu4X4nCEzKUbIHxLbU+pd0GO71JQEvv8Sd1Rb7jtaXXeDxVVqd
 vUF4UIRRs8y/u1wj5U/Xp/0JDiI1eN3ufO4HJStGKw3fwHOaHDS0bI5A4ey4sU/XfvpM
 uWzTEdHgElE20sUjIa5TGciGj5UVJZRt6RNMQ4FDTsXlv9TPaXqPqrp2GEAZTcGlo0Jq
 1AnzrCnssvp3LwC10X8xmtAMhmdVrY/+8daOhGwSDKJ0XvkzNCLXkQksx0Sm7Rm2xrvx
 cD9AvM1saSVh6Oq7Nfqq5pmUVqaVjLs3F28k1t5iHjGjJIZYKrthxwSsnFnzAuVlUx8n 2A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2rj0dnn25n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 00:34:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x330VGFm129053;
        Wed, 3 Apr 2019 00:32:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2rm8f524g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 00:32:26 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x330WQ0M029700;
        Wed, 3 Apr 2019 00:32:26 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Apr 2019 17:32:26 -0700
Subject: Re: [PATCH] fstests: btrfs/048: amend property validation cases
To:     Nikolay Borisov <n.borisov.lkml@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <20190402100742.8355-1-anand.jain@oracle.com>
 <20190402100742.8355-3-anand.jain@oracle.com>
 <903ccfcc-dfaf-3543-c29c-9d0c91125b75@gmail.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <62f07675-128d-d68d-90e6-65044ec78e8a@oracle.com>
Date:   Wed, 3 Apr 2019 08:32:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <903ccfcc-dfaf-3543-c29c-9d0c91125b75@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9215 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904030000
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9215 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904030000
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2/4/19 8:51 PM, Nikolay Borisov wrote:
> 
> 
> On 2.04.19 г. 13:07 ч., Anand Jain wrote:
>> Add more property validation cases which are fixed by the patches [1]
>>   [1]
>>    btrfs: fix property validate fail should not increment generation
>>    btrfs: open code btrfs_set_prop in inherit_prop
>>    btrfs: fix vanished compression property after failed set
>>    btrfs: fix zstd compression parameter
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> (As this fstest patch depends on the kernel patches,
>>   this patch isn't sent to fstests mailing list yet).
>>
> 
> Doesn't matter, it's fine to have a test merged before respective kernel
> patches have landed. 

  Ok.

> In fact there is one btrfs test (can't remember
> which one) authored by you which is failing, yet the respective kernel
> patches have never been sent to the mailing list.

  fstests is also a good place to record known issues. Otherwise we can
  create a group of known-issues with in fstests. What do you think?
  Currently we have these two fstests failing because its fix is not
  yet in the kernel.

btrfs/172:
  Exposed bug: Punch hole fails at ENOSPC only for the misaligned offset.
  Because punch hole has to zero a partial block in case of misaligned
  offset. Do you know how to fix? Of late I started believing its a
  limitation rather than bug. If we agree we can decompose and reuse
  btrfs/172 for something else.

btrfs/154:
  Exposed bug: Reappeared missing device fakes its assembly to the
  volume.
  Fix (as indicated in btrfs/154) V5 is in the mailing list, with
  accepted review comments.

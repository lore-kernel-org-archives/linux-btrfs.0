Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 181B6C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 06:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C81B520675
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 06:54:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cBFi1vW6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbeLQGyw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 01:54:52 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:49420 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbeLQGyw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 01:54:52 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wBH6mw2C101134;
        Mon, 17 Dec 2018 06:54:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Xk/AS0lQUFabkIGQ3kirRYenxyxvJD37bJjSN6c2Hmw=;
 b=cBFi1vW6UgQWGhuDBp/qk0f9J4U3WERl9gJjixEnhI3+6NhLbYAO5JqsXRLfvUKJX8u+
 MZu1peXNp+T2nd4sGze8QrxjE/rarE66p+kBE0Vnvw0ZP8QfVnDA58wCZCFIetYSawIw
 qlSOJy24vqovqufbpdsE5T4tqBGqsp/FY10DwnTgKRu+xiA/JKmVHu6m1LyYm8iVFtnG
 T6dQ9SjxysevKPQrtmk6wZasaQ6KRdKH2IqxXhFSxEdwAZ1rinROCb1tQUjHJ6cSE7Jb
 GLwexDQk7PkzkjHNGUOyZMJ4lm+Sejx/ONlHrwh1GZRCuOT7hing3DY4cXl7jPK3EbDM Ig== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2pcq4dm9v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Dec 2018 06:54:25 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wBH6sJhw030913
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Dec 2018 06:54:20 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wBH6sJ5G023851;
        Mon, 17 Dec 2018 06:54:19 GMT
Received: from [172.20.10.2] (/157.49.131.71)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 16 Dec 2018 22:54:18 -0800
Subject: Re: [PATCH 1/1] btrfs: add kernel scrub log messages
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1545016512-4336-1-git-send-email-anand.jain@oracle.com>
 <9e245d4b-e198-99d4-95b9-d3b1c3b5e11b@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <dc24b823-b74d-5e7e-3cc4-d5c01a0224ad@oracle.com>
Date:   Mon, 17 Dec 2018 14:54:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <9e245d4b-e198-99d4-95b9-d3b1c3b5e11b@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9109 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1812170065
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 12/17/2018 02:39 PM, Nikolay Borisov wrote:
> 
> 
> On 17.12.18 г. 5:15 ч., Anand Jain wrote:
>> scrub kernel messages helps debug and audit, add them to the log.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/scrub.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>> index 902819d3cf41..d7a92521019e 100644
>> --- a/fs/btrfs/scrub.c
>> +++ b/fs/btrfs/scrub.c
>> @@ -3876,6 +3876,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>>   	mutex_unlock(&fs_info->scrub_lock);
>>   
>>   	if (!is_dev_replace) {
>> +		btrfs_info(fs_info, "scrub: devid %llu %s", devid, "started");
> 
> Perhahps those messages needs to be with btrfs_debug, since they are
> only really useful when someone is debugging otherwise we will make
> btrfs rather noisy.

  Not really, its part of audit as well, it should be info. It helps to
  understand the maintenance history of the FS.

Thanks, Anand

>>   		/*
>>   		 * by holding device list mutex, we can
>>   		 * kick off writing super in log tree sync.
>> @@ -3897,6 +3898,10 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>>   	if (progress)
>>   		memcpy(progress, &sctx->stat, sizeof(*progress));
>>   
>> +	if (!is_dev_replace)
>> +		btrfs_info(fs_info, "scrub: devid %llu %s:%d",
>> +			   devid, ret ? "not finished":"finished", ret);
>> +
>>   	mutex_lock(&fs_info->scrub_lock);
>>   	dev->scrub_ctx = NULL;
>>   	scrub_workers_put(fs_info);
>>

Return-Path: <SRS0=zIKm=QA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F5BBC282C3
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 22:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F02FF21872
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 22:30:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hyMujuSR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfAXWar (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Jan 2019 17:30:47 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45600 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfAXWar (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Jan 2019 17:30:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0OMT2wU067525;
        Thu, 24 Jan 2019 22:30:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=nRVA8S0jTdc+p9+XsdDZaku4Yk5S/nt353CqFZMz7V8=;
 b=hyMujuSRRIQeEw0s3fv9fOuZTgUHHrmRj9k7OJ4c2PkqYYReuDMNC3+Y/u5h9LRk6enq
 oCBvrtNIhM63MPxlTF7bqcSluez7DsXlvkANTM26mehoncllY26Iq56X4rwL81v3Q9yX
 7AdPsis59xea019gEfMoFpb9+Wv+lB5G6QqwatvF8RSbpT4cRXu/zZBbL5WIgdUDAzXm
 nqTxOP7M+YWIjj55tZMms+T+5B3KXxNa2j/3+Yjuc1kp+yD1ZcygRdaDFS/21eZmDehA
 5jVonUnLP1PP5D7rJ3FeWT7UM6vAO553UpAdAi2wF6gNUHjHKup+M8OxWVoEYy4zaw5g dw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2q3uav2ntu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jan 2019 22:30:43 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0OMUgQk022498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jan 2019 22:30:42 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0OMUfDA023986;
        Thu, 24 Jan 2019 22:30:41 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Jan 2019 14:30:41 -0800
Subject: Re: [PATCH v2] btrfs: add kernel scrub log messages
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1546503460-3183-1-git-send-email-anand.jain@oracle.com>
 <20190124202112.GB2900@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <2ee736b8-bb33-37cf-7aab-dcf9207ebeb0@oracle.com>
Date:   Fri, 25 Jan 2019 06:30:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190124202112.GB2900@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9146 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901240153
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 01/25/2019 04:21 AM, David Sterba wrote:
> On Thu, Jan 03, 2019 at 04:17:40PM +0800, Anand Jain wrote:
>> scrub kernel messages helps debug and audit, add them to the log.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> v1->v2: fix btrfs_info, using string directly. Add spacing.
> 
>>   fs/btrfs/scrub.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>> index 6dcd36d7b849..aadafc3e52c7 100644
>> --- a/fs/btrfs/scrub.c
>> +++ b/fs/btrfs/scrub.c
>> @@ -3903,6 +3903,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>>   	 */
>>   	nofs_flag = memalloc_nofs_save();
>>   	if (!is_dev_replace) {
>> +		btrfs_info(fs_info, "scrub: devid %llu started", devid);
>>   		/*
>>   		 * by holding device list mutex, we can
>>   		 * kick off writing super in log tree sync.
>> @@ -3925,6 +3926,10 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>>   	if (progress)
>>   		memcpy(progress, &sctx->stat, sizeof(*progress));
>>   
>> +	if (!is_dev_replace)
>> +		btrfs_info(fs_info, "scrub: devid %llu %s:%d",
>> +			devid, ret ? "not finished" : "finished", ret);
> 
> I've checked how the balance status messages are formatted and unified
> them so it's
> 
> +		btrfs_info(fs_info, "scrub: started on devid %llu", devid);
> 
> and
> 
> +               btrfs_info(fs_info, "scrub: %s on devid %llu with status: %d",
> +                       ret ? "not finished" : "finished", devid, ret);

oh that's even better. Thanks David.

> Patch added to misc-next, thanks.





Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 291F7C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E473F2087A
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:16:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QWaMxFhN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E473F2087A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732897AbeKNXT6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 18:19:58 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56360 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727837AbeKNXT5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 18:19:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAED946p117366;
        Wed, 14 Nov 2018 13:16:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=lie09P8T/hHmOhxYXJGzUYoLXzV1vowJTMrMzUdXLE0=;
 b=QWaMxFhN+DId0eP8raDa0O/vQxvemjZMWNHSqj1IERYZLLJCTpKpazotfDOSZAe5jyjG
 wQj/yp9nHqCRrBaWuQ30R3p6LAX4YpvelkE3KP7S06GfWSDVkkQG3IikEmGGgCiLhX60
 AF6fxqg+dm8ctBC3MB9zGsawDq/s3ykEeKoEyxYFBT2nmi8y+zMLUhxU8p00gYg6+T+x
 G1lcz5/d70tCZ427L/hla0sgCIwAmhbBwHi+p5oxmAlzwwoKyZzGjccnJfogHckeR1S2
 e3eazpMpK+4ZRHLtR5fpyZqhYMrNnxuJCCLwKRedzG+LRGdeAl6YvYpQp0uZp/ohzKdd Vw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2nr7cs3b1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Nov 2018 13:16:40 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAEDGY9M011382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Nov 2018 13:16:34 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAEDGX8r018225;
        Wed, 14 Nov 2018 13:16:34 GMT
Received: from [192.168.0.120] (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Nov 2018 05:16:33 -0800
Subject: Re: [PATCH v4.1b 2/3] btrfs: balance: add args info during start and
 resume
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180523063508.18695-3-anand.jain@oracle.com>
 <20180525030547.23367-1-anand.jain@oracle.com>
 <20180531094747.GM3539@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <2deb1ef2-4603-6dc8-bf5d-69e54b94afb4@oracle.com>
Date:   Wed, 14 Nov 2018 21:16:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20180531094747.GM3539@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9076 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811140120
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 05/31/2018 05:47 PM, David Sterba wrote:
> On Fri, May 25, 2018 at 11:05:47AM +0800, Anand Jain wrote:
>> Balance arg info is an important information to be reviewed for the
>> system audit. So this patch adds them to the kernel log.
>>
>> Example:
>> ->btrfs bal start -f -mprofiles=raid1,convert=single,soft -dlimit=10..20,usage=50 /btrfs
>>
>> kernel: BTRFS info (device sdb): balance: start -f -dusage=50,limit=10..20 -msoft,profiles=raid1,convert=single -ssoft,profiles=raid1,convert=single
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> v4->v4.1b: Rename last missed sz to size_buf.
> 
> Please send a full version instead of the incremental bumps to
> individual patches. I try to take the last version but am never sure
> what exactly gets merged.
> 
>> +static u32 describe_balance_args(struct btrfs_balance_args *bargs, char *buf,
>> +				 u32 size_buf)
>> +{
>> +	char *bp = buf;
>> +	u64 flags = bargs->flags;
>> +	char tmp_buf[128];
>> +
>> +	if (!flags)
>> +		return 0;
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_SOFT)
>> +		bp += snprintf(bp, buf - bp + size_buf, "soft,");
> 
> I have some suspicion that this snprintf conscturct is not safe when the
> value of 'buf - bp + size_buf' becomes accidentally negative. A quick
> test showed that a sequence of snprintf and incremented bp does not stop
> writing when the size_buf limit is hit and happily overwrites the
> memory.
> 
> We'd have to check that the negative value is never passed to snprintf.
> The patches are potponed until the issue is resolved, either to verify
> that it's a false alert or the bounds are correctly checked.
> 
> The bug should not be in the original code as the buffer is known to be
> large enough for all the printed bg flags.

  Agreed, possibilities of accidental -ve value for snprintf.
  It followed the original code, but as you said the data length
  is more deterministic there.
  I am fixing this in both new and old original code. Pls find v5.
  Sorry for the delay, I took some time to get a fresh look at it.

Thanks, Anand


> I'm sorry to delay the patches, the log messages are useful, but I want
> to be sure that there are no random memory overwrites introduced.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

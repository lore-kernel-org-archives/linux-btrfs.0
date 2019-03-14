Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E52E4C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 08:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE0F5217F5
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 08:58:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o7UvEH5S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfCNI57 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 04:57:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57052 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfCNI57 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 04:57:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2E8s0np055078;
        Thu, 14 Mar 2019 08:57:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=zvfRCF0tktnewZ78ZF1dpnt3OFpD5EJpOxu6zq2ir+s=;
 b=o7UvEH5SCrU48Gq2vKiOw7OUVwwyPyDIA2CoqNVdLaMTdeqyhnEJqSO9Jpy0CyR0VN6c
 n5XNZkl7HounVLN4QafyU43ZN+F35rmDrUwCSUKrizHYchJf+2Sw5stCvK+/zESKHj3c
 VG4WcyIpsz5ITc+gRAlY6a/kYYk1qP90Zxj+o4dedwnoemKKRH9L/u4rlFxAsPU5t49Q
 fyXB9jdpmiICR3WujeU2kOTiMeUe0NxhFu7sSmeJBWhPKZbJ1LL/nUoqHcO4sk1BDE8P
 wueGXIFatqX2iuGFHcNexp/EnxZeFSiMLbsAdKGj2F7iyC2f+g44c/coUheeLrTh6NRx zQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2r44wufqdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Mar 2019 08:57:33 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2E8vRrD008664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Mar 2019 08:57:27 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2E8vRkK022036;
        Thu, 14 Mar 2019 08:57:27 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Mar 2019 08:57:27 +0000
Subject: Re: [PATCH 2/4] btrfs: fix vanished compression property after failed
 set
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1552539906-29703-1-git-send-email-anand.jain@oracle.com>
 <1552539906-29703-3-git-send-email-anand.jain@oracle.com>
 <e7d5965a-662f-4b94-6806-f6dd698a55c0@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <4b17143a-0f9d-9be3-3cdf-662972f7ef7f@oracle.com>
Date:   Thu, 14 Mar 2019 16:57:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <e7d5965a-662f-4b94-6806-f6dd698a55c0@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9194 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903140062
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/14/19 4:32 PM, Nikolay Borisov wrote:
> 
> 
> On 14.03.19 г. 7:05 ч., Anand Jain wrote:
>> The compression property resets to NULL, instead of the old value if we
>> fail to set the new compression parameter.
>>
>> btrfs prop get /btrfs compression
>>    compression=lzo
>> btrfs prop set /btrfs compression zli
>>    ERROR: failed to set compression for /btrfs: Invalid argument
>> btrfs prop get /btrfs compression
>>
>> This is because the compression property ->validate() is successful for
>> 'zli' as the strncmp() used the len passed from the userland.
>>
>> Fix it by using the expected string length in strncmp().
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> The changelog could be a bit clearer. The failure is due to the fact
> that ->validate succeeds but ->apply fails and the handling code calls
> > 	btrfs_setxattr(trans, inode, handler->xattr_name,
>                NULL, 0, flags);
> 
> However, if you make this patch be the first in the series you obsolete
> the existing patch 1 and fix the issue in this one. I.e 2 birds with 1
> stone.

  Right. I wanted to show the bugs, its reason, and fix separately.

> Also I believe btrfs/048 could use some extension in the part where it
> validates compression properties to test for the bugs discovered/fixed
> in this series.

  Oh. Let me try. Thanks.

-Anand

>> ---
>>   fs/btrfs/props.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
>> index 3cc007e3c7f8..72a06c4d3c70 100644
>> --- a/fs/btrfs/props.c
>> +++ b/fs/btrfs/props.c
>> @@ -275,11 +275,11 @@ static int prop_compression_validate(const char *value, size_t len)
>>   	if (!value)
>>   		return 0;
>>   
>> -	if (!strncmp("lzo", value, len))
>> +	if (!strncmp("lzo", value, 3))
>>   		return 0;
>> -	else if (!strncmp("zlib", value, len))
>> +	else if (!strncmp("zlib", value, 4))
>>   		return 0;
>> -	else if (!strncmp("zstd", value, len))
>> +	else if (!strncmp("zstd", value, 4))
>>   		return 0;
>>   
>>   	return -EINVAL;
>>

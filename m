Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A7CC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 10:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73F6F20693
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 10:49:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dDCZrq+O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbfCMKtS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 06:49:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46128 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfCMKtS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 06:49:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2DAiQpM155666;
        Wed, 13 Mar 2019 10:49:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2018-07-02;
 bh=m+WSd46cwPaTmtuEFSwz2issFilYZGOu0h2Kev9aiVs=;
 b=dDCZrq+O6Cwi+wsuvtPOLbmZv7Wj1OiXbT10lqo4wt8m1aGlXsB2faP0NPpomyGiiY85
 CN0ZmER0fVQDiLEWUSYCuBQgOK2eiR4NpEvuKiHtRLncLt9eTpi3kMHzxw1RUjWZv/4a
 bshPxW8r5NWMCydvNrkjfgULC4mEC4/1I93iXId9C8cPem1fkiOty55Wlf46fxlLOhmV
 vXcBc+wtgznewIiQJdWNk+0I8xEjIHbqprMbGsXto8ktEYQPo8EBscPbQx/W4jpQmmu6
 hgzrX/BslANTc8ywP6CaV8D4z5GlvqVM0PPIqKR7T2qYpWGr6Zx+IFarY4yQzXBHQF7G Iw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2r44wua4sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Mar 2019 10:49:14 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2DAnCJs003792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Mar 2019 10:49:13 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2DAnCH4002103;
        Wed, 13 Mar 2019 10:49:12 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Mar 2019 03:49:12 -0700
Subject: Re: [PATCH 2/2] btrfs: fix vanished compression property after failed
 set
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org, dsterba@suse.com
References: <1552455379-2311-1-git-send-email-anand.jain@oracle.com>
 <1552455379-2311-2-git-send-email-anand.jain@oracle.com>
 <60c3e0c1-52dd-5389-e244-c82776b214a1@oracle.com>
Message-ID: <486f715a-df7b-f242-e78a-295c1102b485@oracle.com>
Date:   Wed, 13 Mar 2019 18:49:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <60c3e0c1-52dd-5389-e244-c82776b214a1@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9193 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903130079
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/13/19 6:33 PM, Anand Jain wrote:
> 
> 
> 
> On 3/13/19 1:36 PM, Anand Jain wrote:
>> The compression property resets to NULL, instead of the old value if we
>> fail to set the new compression parameter.
>>
>> btrfs prop get /btrfs compression
>>    compression=lzo
>> btrfs prop set /btrfs compression zli
>>    ERROR: failed to set compression for /btrfs: Invalid argument
>> btrfs prop get /btrfs compression
>>
>> This is because the compression property ->validate() is successful for
>> 'zli' as the strncmp() used the len passed from the userland.
>>
>> Fix it by using the expected string length in strncmp().
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/props.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
>> index ef6502a94712..7aa362c2fbcf 100644
>> --- a/fs/btrfs/props.c
>> +++ b/fs/btrfs/props.c
>> @@ -277,11 +277,11 @@ static int prop_compression_validate(struct 
>> inode *inode, const char *value,
>>       if (!value)
>>           return 0;
>> -    if (!strncmp("lzo", value, len))
>> +    if (!strncmp("lzo", value, 3))
>>           return 0;
>> -    else if (!strncmp("zlib", value, len))
>> +    else if (!strncmp("zlib", value, 4))
>>           return 0;
>> -    else if (!strncmp("zstd", value, len))
>> +    else if (!strncmp("zstd", value, 4))
>>           return 0;
>>
> 
> 
>    Nack.
> Now some junk value after expected string is not an error.
> such as..
> 
> btrfs prop set /btrfs compression lzo110

  mount(8) compression and the property compression parameter have
  diverged, the compression levels are set able only from
  mount(8) option? We should rather make it consistent?

Thanks, Anand


> Thanks, Anand
> 
>>       return -EINVAL;
>>

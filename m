Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B04C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 08:49:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33B672173C
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 08:49:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QFWP70Yp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfCMItu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 04:49:50 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:57200 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbfCMItu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 04:49:50 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2D8hX2Q085026;
        Wed, 13 Mar 2019 08:49:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=s9p8BEgURN1coR6hgjcXLax4rWm1TEqKP2EGn5N6zyU=;
 b=QFWP70YpXfliTctMmG0QSqiSYdVn6WPKa3LoZc/t8suc044R7AS7dNd1NV5hS35Nx59t
 EEa2+/i5/H/SK2LE4EnI50gd6nZma2Ez9IfUDHm2XaZcvSp3IzDS/wTdS8rdT88ZK4Lr
 LsXjdlBwmtQuXge1aQU5pHuQR9ayv7VUNUvsutWa9jaElNuO9wyO4Qd/KGy9/uRpu6Mi
 HZmVmAD4zpYbCov4Fib+IJ+DM1PpdW7t3m5xmDiTlPmMCC/DJP+G3vRHOJoaeeRxds1/
 iAjTAo4EAIzsE8OnCH11wzguJXMoxewRCdThuK7rMzmEQYL6cXYlwFc+31AjeUHOXi/3 6g== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2r430et0r1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Mar 2019 08:49:45 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2D8nikq016667
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Mar 2019 08:49:44 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2D8nhDT027366;
        Wed, 13 Mar 2019 08:49:43 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Mar 2019 01:49:43 -0700
Subject: Re: [PATCH 2/2] btrfs: fix vanished compression property after failed
 set
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1552455379-2311-1-git-send-email-anand.jain@oracle.com>
 <1552455379-2311-2-git-send-email-anand.jain@oracle.com>
 <4ef1a9bb-141c-c07b-d995-9ac3d0c8f1d2@suse.com>
 <90b86c08-7c3b-d0b1-a895-ebc45af4c059@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <ff110534-776d-738f-bb11-61233cfcd02e@oracle.com>
Date:   Wed, 13 Mar 2019 16:49:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <90b86c08-7c3b-d0b1-a895-ebc45af4c059@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9193 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903130065
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/13/19 3:22 PM, Nikolay Borisov wrote:
> 
> 
> On 13.03.19 г. 9:20 ч., Nikolay Borisov wrote:
>>
>>
>> On 13.03.19 г. 7:36 ч., Anand Jain wrote:
>>> The compression property resets to NULL, instead of the old value if we
>>> fail to set the new compression parameter.
>>>
>>> btrfs prop get /btrfs compression
>>>    compression=lzo
>>> btrfs prop set /btrfs compression zli
>>>    ERROR: failed to set compression for /btrfs: Invalid argument
>>> btrfs prop get /btrfs compression
>>>
>>> This is because the compression property ->validate() is successful for
>>> 'zli' as the strncmp() used the len passed from the userland.
>>>
>>> Fix it by using the expected string length in strncmp().
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>>   fs/btrfs/props.c | 6 +++---
>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
>>> index ef6502a94712..7aa362c2fbcf 100644
>>> --- a/fs/btrfs/props.c
>>> +++ b/fs/btrfs/props.c
>>> @@ -277,11 +277,11 @@ static int prop_compression_validate(struct inode *inode, const char *value,
>>>   	if (!value)
>>>   		return 0;
>>>   
>>> -	if (!strncmp("lzo", value, len))
>>> +	if (!strncmp("lzo", value, 3))
>>>   		return 0;
>>> -	else if (!strncmp("zlib", value, len))
>>> +	else if (!strncmp("zlib", value, 4))
>>>   		return 0;
>>> -	else if (!strncmp("zstd", value, len))
>>> +	else if (!strncmp("zstd", value, 4))
>>>   		return 0;
>>
>> This also makes the len argument to prop_compression_validate redundant
>> and should be removed as well.

  Its part of the 'struct prop_handler', its better to keep it until
  properties have completely evolved.

> 
> As a matter of fact I don't see any value in prop_compression_validate
> since the exact same code is used in prop_compression_apply and einval
> will be returned if an invalid value is passed in.

  I notice too. But its better to keep it until the most of the
  properties have evolved.

  As of now btrfs_set_prop() follows sequence..
    h->validate(prop)
    setxattr(prop)
    h->apply(prop)

  If validate fails its easy to fail exit.

Thanks, Anand


>>
>>>   
>>>   	return -EINVAL;
>>>
>>

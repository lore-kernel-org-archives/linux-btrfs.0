Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0D9C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 01:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B45A12087C
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 01:40:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kYe/QbiW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfCNBk2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 21:40:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48202 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfCNBk2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 21:40:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2E1YxxU123001;
        Thu, 14 Mar 2019 01:40:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=lHQU7AhQgwi51S4clc+q3+ViClH4gUbLy/eoL/QundU=;
 b=kYe/QbiWz6RSqDMCmqy2DB+iqTz/q/l1j0IQ7yKv6PRuqch/gR7faPLMBGW5q9YYs+mp
 thHw/Hmhoz6bVSeKp4bT49nJSxR4+SDkpO0/1iTmmq+FcZ4RTNb/7+JQtnwxsxk0VB6b
 iLt9bloy5l/6uM5d4+4NfEEjNu/zA9C6BT9VJhR5rcthtEhG2SXyb8TvdzD234eCbkL2
 jjQQCE2EYo+OD2NmAIi+ifpHcVqWTNsxiw7fR7niGYpHbIG1fRHmAvbgzjI0FjtOnSY1
 oZ6nGve0O0suPrdTC4K3lx2rc9aoqfcAmLyQ3Ojocpr6Lgrb2EfQjA5GO4tLy1hEN0bT Yw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2r44wueaau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Mar 2019 01:40:24 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2E1eM92016312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Mar 2019 01:40:23 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2E1eLVq028135;
        Thu, 14 Mar 2019 01:40:22 GMT
Received: from [172.20.10.2] (/183.90.36.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Mar 2019 18:40:21 -0700
Subject: Re: [PATCH 2/2] btrfs: fix vanished compression property after failed
 set
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1552455379-2311-1-git-send-email-anand.jain@oracle.com>
 <1552455379-2311-2-git-send-email-anand.jain@oracle.com>
 <60c3e0c1-52dd-5389-e244-c82776b214a1@oracle.com>
 <20190313174539.GG31119@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <501289dd-ab15-d10c-bcce-8efcaf939b79@oracle.com>
Date:   Thu, 14 Mar 2019 09:40:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190313174539.GG31119@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9194 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903140008
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/14/19 1:45 AM, David Sterba wrote:
> On Wed, Mar 13, 2019 at 06:33:50PM +0800, Anand Jain wrote:
>>
>>
>>
>> On 3/13/19 1:36 PM, Anand Jain wrote:
>>> The compression property resets to NULL, instead of the old value if we
>>> fail to set the new compression parameter.
>>>
>>> btrfs prop get /btrfs compression
>>>     compression=lzo
>>> btrfs prop set /btrfs compression zli
>>>     ERROR: failed to set compression for /btrfs: Invalid argument
>>> btrfs prop get /btrfs compression
>>>
>>> This is because the compression property ->validate() is successful for
>>> 'zli' as the strncmp() used the len passed from the userland.
>>>
>>> Fix it by using the expected string length in strncmp().
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>>    fs/btrfs/props.c | 6 +++---
>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
>>> index ef6502a94712..7aa362c2fbcf 100644
>>> --- a/fs/btrfs/props.c
>>> +++ b/fs/btrfs/props.c
>>> @@ -277,11 +277,11 @@ static int prop_compression_validate(struct inode *inode, const char *value,
>>>    	if (!value)
>>>    		return 0;
>>>    
>>> -	if (!strncmp("lzo", value, len))
>>> +	if (!strncmp("lzo", value, 3))
>>>    		return 0;
>>> -	else if (!strncmp("zlib", value, len))
>>> +	else if (!strncmp("zlib", value, 4))
>>>    		return 0;
>>> -	else if (!strncmp("zstd", value, len))
>>> +	else if (!strncmp("zstd", value, 4))
>>>    		return 0;
>>>
>>
>>
>>     Nack.
>> Now some junk value after expected string is not an error.
>> such as..
>>
>> btrfs prop set /btrfs compression lzo110
> 
> This was intentional when the zlib levels were introduced so older
> kernels can understand newer compression specifier but still have a sane
> fallback (ie use the default level). Now it would be better to extend
> the validation to parse the method:level format at least. But as
> mentioned in the other mail, the level needs to be propagated elsewhere
> too so it's not just a change to the validation.
> 

  Compression levels properties can be implemented in a newer set of the
  patches? So I believe this set ok to merge.

  The other way to fix this was to save and rewrite the old parameter,
  but that's not a good idea as well, because when parameter is not valid
  we should rather fail without any update (generation/transid should
  also remain unchanged, there is a bug [1] in the original code which
  shall be fixed separately).

  [1]
  with this patch,
  btrfs in dump-super /dev/sdb | grep "^generation"; btrfs prop set 
/btrfs compression zli; sync; btrfs in dump-super /dev/sdb | grep 
"^generation"

generation		21
ERROR: failed to set compression for /btrfs: Invalid argument
generation		22


Thanks, Anand

Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D7B3C43610
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 08:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2994420831
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 08:07:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qmR8WEs5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2994420831
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbeKTSfk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 13:35:40 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41108 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbeKTSfk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 13:35:40 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAK840pW021644;
        Tue, 20 Nov 2018 08:07:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=XwkSme2DzBknUF2qq714PgF0v6sGsbgosnmaNfS+KV4=;
 b=qmR8WEs53qFWySSbL/sabvZs55NweRGkhjuKYiPa0kyZSFbuWXKYScZ3jaGdZZTJsh3S
 5OIxjrXS1wsjxKHmtPWHs5F++I4rHiZYUXWTMc9pWgSEOMVHj3q658UD/R9DSg/vKGjx
 nn6FN9eanO9PGaun8MQBvZcR736mg4sMJlE5/bD1VS7B+fov6ov35dD1p8lyDTQNFVoo
 GikdI0MiAuE9sW/I48JSbIb5Uz4W2d4Gbo2eX9gtnht9zeVIBoJYb4EklJD6m3QLXxCP
 i6r2zVPvHKKoReQ2lg4pKx/ItuMEKI5J+XSbOpFc1UbvYNJ4tvXKgBQT9vJnCkcC4PHD 5w== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2ntbmqj8ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Nov 2018 08:07:48 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAK87gDs017559
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Nov 2018 08:07:42 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAK87g2S002286;
        Tue, 20 Nov 2018 08:07:42 GMT
Received: from [192.168.0.120] (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Nov 2018 00:07:41 -0800
Subject: Re: [PATCH v5 1/3] btrfs: add helper function describe_block_group()
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1542201432-8617-1-git-send-email-anand.jain@oracle.com>
 <1542201432-8617-2-git-send-email-anand.jain@oracle.com>
 <20181119170233.GG24115@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <fbd00a70-0ed2-450d-65c9-501091c8b9c8@oracle.com>
Date:   Tue, 20 Nov 2018 16:07:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181119170233.GG24115@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9082 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811200074
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Thanks for the review.. more below.

On 11/20/2018 01:02 AM, David Sterba wrote:
> On Wed, Nov 14, 2018 at 09:17:10PM +0800, Anand Jain wrote:
>> Improve on describe_relocation() add a common helper function to describe
>> the block groups.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> Reviewed-by: David Sterba <dsterba@suse.com>
>> ---
>> v4.1->v5: Initialize buf[128] to null.
>> v4->v4.1: Use strcpy(buf, "|NONE"); as in the original
>> v3->v4: Just pass full flag name in the define DESCRIBE_FLAG(flag,..),
>> 	 so that it can be used at couple of more places.
>> 	Rename describe_block_groups() to btrfs_describe_block_groups().
>> 	Drop useless return u32.
>> v3:	Born.
>>
>>   fs/btrfs/relocation.c | 30 +++---------------------------
>>   fs/btrfs/volumes.c    | 43 +++++++++++++++++++++++++++++++++++++++++++
>>   fs/btrfs/volumes.h    |  1 +
>>   3 files changed, 47 insertions(+), 27 deletions(-)
>>
>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>> index 924116f654a1..0373b3cc1d36 100644
>> --- a/fs/btrfs/relocation.c
>> +++ b/fs/btrfs/relocation.c
>> @@ -4184,37 +4184,13 @@ static struct reloc_control *alloc_reloc_control(void)
>>   static void describe_relocation(struct btrfs_fs_info *fs_info,
>>   				struct btrfs_block_group_cache *block_group)
>>   {
>> -	char buf[128];		/* prefixed by a '|' that'll be dropped */
>> -	u64 flags = block_group->flags;
>> +	char buf[128] = {'\0'};
>>   
>> -	/* Shouldn't happen */
>> -	if (!flags) {
>> -		strcpy(buf, "|NONE");
>> -	} else {
>> -		char *bp = buf;
>> -
>> -#define DESCRIBE_FLAG(f, d) \
>> -		if (flags & BTRFS_BLOCK_GROUP_##f) { \
>> -			bp += snprintf(bp, buf - bp + sizeof(buf), "|%s", d); \
>> -			flags &= ~BTRFS_BLOCK_GROUP_##f; \
>> -		}
>> -		DESCRIBE_FLAG(DATA,     "data");
>> -		DESCRIBE_FLAG(SYSTEM,   "system");
>> -		DESCRIBE_FLAG(METADATA, "metadata");
>> -		DESCRIBE_FLAG(RAID0,    "raid0");
>> -		DESCRIBE_FLAG(RAID1,    "raid1");
>> -		DESCRIBE_FLAG(DUP,      "dup");
>> -		DESCRIBE_FLAG(RAID10,   "raid10");
>> -		DESCRIBE_FLAG(RAID5,    "raid5");
>> -		DESCRIBE_FLAG(RAID6,    "raid6");
>> -		if (flags)
>> -			snprintf(bp, buf - bp + sizeof(buf), "|0x%llx", flags);
>> -#undef DESCRIBE_FLAG
>> -	}
>> +	btrfs_describe_block_groups(block_group->flags, buf, sizeof(buf));
>>   
>>   	btrfs_info(fs_info,
>>   		   "relocating block group %llu flags %s",
>> -		   block_group->key.objectid, buf + 1);
>> +		   block_group->key.objectid, buf);
>>   }
>>   
>>   /*
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index f435d397019e..12b3d0625c6a 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -123,6 +123,49 @@ const char *get_raid_name(enum btrfs_raid_types type)
>>   	return btrfs_raid_array[type].raid_name;
>>   }
>>   
>> +void btrfs_describe_block_groups(u64 bg_flags, char *buf, u32 size_buf)
>> +{
>> +	int i;
>> +	int ret;
>> +	char *bp = buf;
>> +	u64 flags = bg_flags;
>> +	u32 size_bp = size_buf;
>> +
>> +	if (!flags) {
>> +		strcpy(bp, "NONE");
>> +		return;
>> +	}
>> +
>> +#define DESCRIBE_FLAG(f, d) \
> 
> Macro arguments should be in ( ) in the body

  Fixed in v6.

>> +	do { \
>> +		if (flags & f) { \
>> +			ret = snprintf(bp, size_bp, "%s|", d); \
>> +			if (ret < 0 || ret >= size_bp) \
>> +				return; \
> 
> Ok, this seems to be safe. snprintf will not write more than size_bp and
> this will be caught if it overflows.
> 
> The return is obscured by the macro, I'd rather make it more visible
> that there is a potential change in the code flow. The proposed change:
> 
> 				goto out_overflow;
> 				...
> 
> and define out_overflow at the end of function. Same for the other
> helper macros.

  makes sense. Thanks for explaining. Fixed in v6.

> Also please align the backslashes of the macro a few tabs to the right.

  Yep done in v6.

Thanks, Anand


>> +			size_bp -= ret; \
>> +			bp += ret; \
>> +			flags &= ~f; \
>> +		} \
>> +	} while (0)

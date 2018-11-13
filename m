Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE86C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 10:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADC692087A
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 10:32:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IAJp6he7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADC692087A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732222AbeKMU3s (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 15:29:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48216 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbeKMU3r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 15:29:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wADATGbA047495;
        Tue, 13 Nov 2018 10:32:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : cc : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=X8jt+hTgog2igP8LYMmTLXIJyIAgIA/hJSEZq6GDet8=;
 b=IAJp6he7czHj5fvDbcZtFShHqUVD+YVnnucZRZcY/haLB8Uq8qrD531dAOUWk+zXlUXC
 9gumKI7CuJ/zrKnTdARvVr7Vm2c8Q3PoAXvpHX5oWX64SDz8O9ElnFdL4gjyR7M5Eql1
 qVrmIFHDwP/whMFL97PDXLRfE+/H4zPrHfzI+k/npzxvglvmd8s9XDsvBejCvIvpfBbc
 ICFcjF0XloNRpr4kJ8sDc5o4YdqbvXGLatTZI4nx8rnUVVGyu3dO7Jm2IFXB70lHPsSQ
 7EX6+LtxAvRVVRt2CE9pes2K9X0V4WgvzsUJAhLndLKm6gXdTUwJmzZSXnzY3ZkjpFrW QA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2nnwg19p0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Nov 2018 10:32:15 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wADAWE0o010561
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Nov 2018 10:32:14 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wADAWErX010582;
        Tue, 13 Nov 2018 10:32:14 GMT
Received: from [192.168.0.120] (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Nov 2018 02:32:13 -0800
Subject: Re: [RFC] BTRFS_DEV_REPLACE_ITEM_STATE_* doesn't match with on disk
To:     David Sterba <dsterba@suse.com>
References: <e932064c-6182-a87c-3475-bf1765b165bc@oracle.com>
 <e19a1d1c-3d93-7b5c-01b1-83c0c53323c8@suse.com>
Cc:     Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <dd4eb64b-0841-1f81-04e1-309212bbbedd@oracle.com>
Date:   Tue, 13 Nov 2018 18:32:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <e19a1d1c-3d93-7b5c-01b1-83c0c53323c8@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9075 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811130099
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


David, Gentle ping.

Thanks, Anand

On 11/12/2018 03:50 PM, Nikolay Borisov wrote:
> 
> 
> On 12.11.18 г. 6:58 ч., Anand Jain wrote:
>>
>> The dev_replace_state defines are miss matched between the
>> BTRFS_IOCTL_DEV_REPLACE_STATE_* and BTRFS_DEV_REPLACE_ITEM_STATE_* [1].
>>
>> [1]
>> -----------------------------
>> btrfs.h:#define BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED        2
>> btrfs.h:#define BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED        3
>> btrfs.h:#define BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED        4
>>
>> btrfs_tree.h:#define BTRFS_DEV_REPLACE_ITEM_STATE_SUSPENDED    2
>> btrfs_tree.h:#define BTRFS_DEV_REPLACE_ITEM_STATE_FINISHED    3
>> btrfs_tree.h:#define BTRFS_DEV_REPLACE_ITEM_STATE_CANCELED    4
>> -----------------------------
>>
>> The BTRFS_DEV_REPLACE_ITEM_STATE_* series is unused in both btrfs.ko and
>> btrfs-progs, the on-disk also follows BTRFS_IOCTL_DEV_REPLACE_STATE_*
>> (we set dev_replace->replace_state using the
>> BTRFS_IOCTL_DEV_REPLACE_STATE_* defines and write to the on-disk).
>>
>>   359         btrfs_set_dev_replace_replace_state(eb, ptr,
>>   360                 dev_replace->replace_state);
>>
>> IMO it should be ok to delete the BTRFS_DEV_REPLACE_ITEM_STATE_*
>> altogether? But how about the userland progs other than btrfs-progs?
>> If not at least fix the miss match as in [2], any comments?
> 
> Unfortunately you are right. This seems to stem from sloppy job back in
> the days of initial dev-replace support. BTRFS_DEV_REPLACE_ITEM_STATE_*
> were added in e922e087a35c ("Btrfs: enhance btrfs structures for device
> replace support"), yet they were never used. And the
> IOCTL_DEV_REPLACE_STATE* were added in e93c89c1aaaa ("Btrfs: add new
> sources for device replace code").
> 
> It looks like the ITEM_STATE* definitions were stillborn so to speak and
> personally I'm in favor of removing them. They shouldn't have been
> merged in the first place and indeed the patch doesn't even have a
> Reviewed-by tag. So it originated from the, I'd say, spartan days of
> btrfs development...
> 
> David,  any code which is using BTRFS_DEV_REPLACE_ITEM_STATE_SUSPENDED
> is inherently broken, so how about we remove those definitions, then
> when it's compilation is broken in the future the author will actually
> have a chance to fix it, though it's highly unlikely anyone is relying
> on those definitions.
> 
> 
>>
>> [2]
>> --------------------------------------
>> diff --git a/include/uapi/linux/btrfs_tree.h
>> b/include/uapi/linux/btrfs_tree.h
>> index aff1356c2bb8..9ffa7534cadf 100644
>> --- a/include/uapi/linux/btrfs_tree.h
>> +++ b/include/uapi/linux/btrfs_tree.h
>> @@ -805,9 +805,9 @@ struct btrfs_dev_stats_item {
>>   #define BTRFS_DEV_REPLACE_ITEM_CONT_READING_FROM_SRCDEV_MODE_AVOID     1
>>   #define BTRFS_DEV_REPLACE_ITEM_STATE_NEVER_STARTED     0
>>   #define BTRFS_DEV_REPLACE_ITEM_STATE_STARTED           1
>> -#define BTRFS_DEV_REPLACE_ITEM_STATE_SUSPENDED         2
>> -#define BTRFS_DEV_REPLACE_ITEM_STATE_FINISHED          3
>> -#define BTRFS_DEV_REPLACE_ITEM_STATE_CANCELED          4
>> +#define BTRFS_DEV_REPLACE_ITEM_STATE_FINISHED          2
>> +#define BTRFS_DEV_REPLACE_ITEM_STATE_CANCELED          3
>> +#define BTRFS_DEV_REPLACE_ITEM_STATE_SUSPENDED         4
>>
>>   struct btrfs_dev_replace_item {
>>          /*
>> --------------------------------------
>>
>>
>> Thanks, Anand
>>

Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB488C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 07:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72B7B2146F
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 07:31:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="frB/VVYJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72B7B2146F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbeKUSFN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 13:05:13 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36696 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbeKUSFM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 13:05:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAL7TNBH141900;
        Wed, 21 Nov 2018 07:31:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=uSANn56gxSC1EyF/iM1sm126dICUUnjNriLf87BYFfw=;
 b=frB/VVYJ+OiA6uSEAg1rwmSFRESA5dmoiQ3Px/SQpGw1G2y2I/BsNhAQRjH6OWnPo67D
 fqFDBGwUyRRNb5Q42e602oQrRDRZ8GvDmD4v40F3MYUG0G7oGd96hfSaGSm2Od39wlFd
 PuEMZFRBTPJYs+isD6Op7i9qM30HvfVsl289r7Bvn+ZSVQHfyWDktVn2VIUuYU15flUl
 yF/36tZSAwpoKus089RxGBt3XLfhPbr5Gny8GWD0gb3ZMbYiiBj5OKrVV2h0LqwnyULv
 BbWB9jy69BHCIyvrGuJz/PxDyCbZzGf1VuTl5mS+Y6GwaipiWV3VgA76VCbxawEEO4Y0 3w== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2ntadtyvxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Nov 2018 07:31:45 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAL7Vip4031609
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Nov 2018 07:31:44 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAL7Vhnq021494;
        Wed, 21 Nov 2018 07:31:43 GMT
Received: from [10.186.50.4] (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Nov 2018 23:31:43 -0800
From:   Anand Jain <anand.jain@oracle.com>
Subject: Re: [RFC] BTRFS_DEV_REPLACE_ITEM_STATE_* doesn't match with on disk
To:     David Sterba <dsterba@suse.com>, dsterba@suse.cz
Cc:     Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <e932064c-6182-a87c-3475-bf1765b165bc@oracle.com>
 <e19a1d1c-3d93-7b5c-01b1-83c0c53323c8@suse.com>
 <dd4eb64b-0841-1f81-04e1-309212bbbedd@oracle.com>
X-Mozilla-News-Host: news://nntp.lore.kernel.org
Message-ID: <fad69f0c-a56e-0cbc-2ae0-85957b8f339e@oracle.com>
Date:   Wed, 21 Nov 2018 15:31:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <dd4eb64b-0841-1f81-04e1-309212bbbedd@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9083 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811210070
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


David, any comments on this please.

Thanks, Anand


On 11/13/2018 06:32 PM, Anand Jain wrote:
> 
> David, Gentle ping.
> 
> Thanks, Anand
> 
> On 11/12/2018 03:50 PM, Nikolay Borisov wrote:
>>
>>
>> On 12.11.18 г. 6:58 ч., Anand Jain wrote:
>>>
>>> The dev_replace_state defines are miss matched between the
>>> BTRFS_IOCTL_DEV_REPLACE_STATE_* and BTRFS_DEV_REPLACE_ITEM_STATE_* [1].
>>>
>>> [1]
>>> -----------------------------
>>> btrfs.h:#define BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED        2
>>> btrfs.h:#define BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED        3
>>> btrfs.h:#define BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED        4
>>>
>>> btrfs_tree.h:#define BTRFS_DEV_REPLACE_ITEM_STATE_SUSPENDED    2
>>> btrfs_tree.h:#define BTRFS_DEV_REPLACE_ITEM_STATE_FINISHED    3
>>> btrfs_tree.h:#define BTRFS_DEV_REPLACE_ITEM_STATE_CANCELED    4
>>> -----------------------------
>>>
>>> The BTRFS_DEV_REPLACE_ITEM_STATE_* series is unused in both btrfs.ko and
>>> btrfs-progs, the on-disk also follows BTRFS_IOCTL_DEV_REPLACE_STATE_*
>>> (we set dev_replace->replace_state using the
>>> BTRFS_IOCTL_DEV_REPLACE_STATE_* defines and write to the on-disk).
>>>
>>>   359         btrfs_set_dev_replace_replace_state(eb, ptr,
>>>   360                 dev_replace->replace_state);
>>>
>>> IMO it should be ok to delete the BTRFS_DEV_REPLACE_ITEM_STATE_*
>>> altogether? But how about the userland progs other than btrfs-progs?
>>> If not at least fix the miss match as in [2], any comments?
>>
>> Unfortunately you are right. This seems to stem from sloppy job back in
>> the days of initial dev-replace support. BTRFS_DEV_REPLACE_ITEM_STATE_*
>> were added in e922e087a35c ("Btrfs: enhance btrfs structures for device
>> replace support"), yet they were never used. And the
>> IOCTL_DEV_REPLACE_STATE* were added in e93c89c1aaaa ("Btrfs: add new
>> sources for device replace code").
>>
>> It looks like the ITEM_STATE* definitions were stillborn so to speak and
>> personally I'm in favor of removing them. They shouldn't have been
>> merged in the first place and indeed the patch doesn't even have a
>> Reviewed-by tag. So it originated from the, I'd say, spartan days of
>> btrfs development...
>>
>> David,  any code which is using BTRFS_DEV_REPLACE_ITEM_STATE_SUSPENDED
>> is inherently broken, so how about we remove those definitions, then
>> when it's compilation is broken in the future the author will actually
>> have a chance to fix it, though it's highly unlikely anyone is relying
>> on those definitions.
>>
>>
>>>
>>> [2]
>>> --------------------------------------
>>> diff --git a/include/uapi/linux/btrfs_tree.h
>>> b/include/uapi/linux/btrfs_tree.h
>>> index aff1356c2bb8..9ffa7534cadf 100644
>>> --- a/include/uapi/linux/btrfs_tree.h
>>> +++ b/include/uapi/linux/btrfs_tree.h
>>> @@ -805,9 +805,9 @@ struct btrfs_dev_stats_item {
>>>   #define 
>>> BTRFS_DEV_REPLACE_ITEM_CONT_READING_FROM_SRCDEV_MODE_AVOID     1
>>>   #define BTRFS_DEV_REPLACE_ITEM_STATE_NEVER_STARTED     0
>>>   #define BTRFS_DEV_REPLACE_ITEM_STATE_STARTED           1
>>> -#define BTRFS_DEV_REPLACE_ITEM_STATE_SUSPENDED         2
>>> -#define BTRFS_DEV_REPLACE_ITEM_STATE_FINISHED          3
>>> -#define BTRFS_DEV_REPLACE_ITEM_STATE_CANCELED          4
>>> +#define BTRFS_DEV_REPLACE_ITEM_STATE_FINISHED          2
>>> +#define BTRFS_DEV_REPLACE_ITEM_STATE_CANCELED          3
>>> +#define BTRFS_DEV_REPLACE_ITEM_STATE_SUSPENDED         4
>>>
>>>   struct btrfs_dev_replace_item {
>>>          /*
>>> --------------------------------------
>>>
>>>
>>> Thanks, Anand
>>>


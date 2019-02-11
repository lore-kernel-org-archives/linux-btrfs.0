Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A9CC169C4
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 09:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C379120823
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 09:30:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nu2jmEE8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfBKJaY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 04:30:24 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:41138 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbfBKJaY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 04:30:24 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1B9O3Vd167634;
        Mon, 11 Feb 2019 09:30:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=WT8TL7ts0gsHG465Q3DBA0h/M8fwhmfroCCnWR8o3Hc=;
 b=nu2jmEE8vBVTAP71kyUrbDflEx8hOdrUD3YUKTRXfP276DJTunU3S2fZRmK2UonzkA95
 wVr9AUnwPaOP+rttfh7eLaF30HFWf+eiqIbz1H3wY5IfgsY18cYc08M2YvzsV70+wDep
 Bw+F4ZEi8JI/2cJGnzsqbZyvCuJMd8f6ZJRvYSaDXsuSF9QP9qHqFi0ykgahnRROkksB
 E+/+7heo1ZCyMv9ub64zmwREM41mB+X313+0zFBrDKht7YC8gMbOuGlpQ8LRBkxX3vf7
 BtdwEPtgDAUnEDjEfk8x9nRhnEOX/i26w/bzK4gWz58N+o8JR68JEDjU9zOzLw8G+YGu tg== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2qhre54hey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Feb 2019 09:30:20 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1B9UFdh000312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Feb 2019 09:30:15 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1B9UF5N004339;
        Mon, 11 Feb 2019 09:30:15 GMT
Received: from [172.20.10.2] (/183.90.37.91)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Feb 2019 01:30:14 -0800
Subject: Re: btrfs as / filesystem in RAID1
To:     Stefan K <shadow_7@gmx.net>, linux-btrfs@vger.kernel.org
References: <33679024.u47WPbL97D@t460-skr>
 <92ae78af-1e43-319d-29ce-f8a04a08f7c5@mendix.com>
 <2159107.RxXdQBBoNF@t460-skr>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <9a6d9777-cbe7-8b62-16b2-a4dc741507e7@oracle.com>
Date:   Mon, 11 Feb 2019 17:30:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <2159107.RxXdQBBoNF@t460-skr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9163 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902110074
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2/7/19 7:04 PM, Stefan K wrote:
> Thanks, with degraded  as kernel parameter and also ind the fstab it works like expected
> 
> That should be the normal behaviour,

  IMO in the long term it will be. But before that we have few items to 
fix around this, such as the serviceability part.

-Anand


> cause a server must be up and running, and I don't care about a device loss, thats why I use a RAID1. The device-loss problem can I fix later, but its important that a server is up and running, i got informed at boot time and also in the logs files that a device is missing, also I see that if you use a monitoring program.
> 
> So please change the normal behavior
> 
> On Friday, February 1, 2019 7:13:16 PM CET Hans van Kranenburg wrote:
>> Hi Stefan,
>>
>> On 2/1/19 11:28 AM, Stefan K wrote:
>>>
>>> I've installed my Debian Stretch to have / on btrfs with raid1 on 2
>>> SSDs. Today I want test if it works, it works fine until the server
>>> is running and the SSD get broken and I can change this, but it looks
>>> like that it does not work if the SSD fails until restart. I got the
>>> error, that one of the Disks can't be read and I got a initramfs
>>> prompt, I expected that it still runs like mdraid and said something
>>> is missing.
>>>
>>> My question is, is it possible to configure btrfs/fstab/grub that it
>>> still boot? (that is what I expected from a RAID1)
>>
>> Yes. I'm not the expert in this area, but I see you haven't got a reply
>> today yet, so I'll try.
>>
>> What you see happening is correct. This is the default behavior.
>>
>> To be able to boot into your system with a missing disk, you can add...
>>      rootflags=degraded
>> ...to the linux kernel command line by editing it on the fly when you
>> are in the GRUB menu.
>>
>> This allows the filesystem to start in 'degraded' mode this one time.
>> The only thing you should be doing when the system is booted is have a
>> new disk present already in place and fix the btrfs situation. This
>> means things like cloning the partition table of the disk that's still
>> working, doing whatever else is needed in your situation and then
>> running btrfs replace to replace the missing disk with the new one, and
>> then making sure you don't have "single" block groups left (using btrfs
>> balance), which might have been created for new writes when the
>> filesystem was running in degraded mode.
>>
>> -- 
>> Hans van Kranenburg
>>
> 

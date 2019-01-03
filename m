Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5223AC43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C9C92073D
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:18:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="3WlVbsEq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbfACISx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 03:18:53 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33262 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfACISx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2019 03:18:53 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x038Dqs1126107;
        Thu, 3 Jan 2019 08:18:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : cc : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=kKxX1iy4Gs5Vousr0i4PQ7eJhTR2OEv728R23DfiQQs=;
 b=3WlVbsEqxTuSOpHalHlXp3+khy5k/l5dhke2s6YHFlY4JfTtUEDALtSKxz+MjkkQ7XIl
 SFggu24utNRqdolkfpUVsvFMvflHscxGU1Q9kDDcZnNs10KefPJa3fY+xNVhEyxQcN1Z
 xf0f0+PbHJqD/CE1+buQBEgg5oOz48htmw6xa28GF+bBl/Hdna1ZXKiNs4EZUo5E6h03
 31/tpbN3sluh+LvZayhGcSTSUxPvcs08s/AJX8nKkKSLTiO4HGkzDrEOlpaknkp1DGGd
 4e7MhKvGyE3E+YXgzIAEyOYJUMQmBZmbi1afQLsg+Rm8c4J3qgsWYnd4NhYjE7qSed5D HQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2pnxee5wa7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jan 2019 08:18:51 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x038Ipfl025661
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Jan 2019 08:18:51 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x038Ipge009563;
        Thu, 3 Jan 2019 08:18:51 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Jan 2019 00:18:51 -0800
Subject: Re: [PATCH 1/1] btrfs: add kernel scrub log messages
To:     dsterba@suse.ce
References: <1545016512-4336-1-git-send-email-anand.jain@oracle.com>
 <20190102172017.GC23615@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Message-ID: <f8578b0b-074a-1759-73a2-a29fb95937dd@oracle.com>
Date:   Thu, 3 Jan 2019 16:18:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190102172017.GC23615@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9124 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901030074
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 01/03/2019 01:20 AM, David Sterba wrote:
> On Mon, Dec 17, 2018 at 11:15:12AM +0800, Anand Jain wrote:
>> scrub kernel messages helps debug and audit, add them to the log.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/scrub.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>> index 902819d3cf41..d7a92521019e 100644
>> --- a/fs/btrfs/scrub.c
>> +++ b/fs/btrfs/scrub.c
>> @@ -3876,6 +3876,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>>   	mutex_unlock(&fs_info->scrub_lock);
>>   
>>   	if (!is_dev_replace) {
>> +		btrfs_info(fs_info, "scrub: devid %llu %s", devid, "started");
my bad, will fix.
> 
> Why do you print a fixed and known string using %s?
> 
>>   		/*
>>   		 * by holding device list mutex, we can
>>   		 * kick off writing super in log tree sync.
>> @@ -3897,6 +3898,10 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>>   	if (progress)
>>   		memcpy(progress, &sctx->stat, sizeof(*progress));
>>   
>> +	if (!is_dev_replace)
>> +		btrfs_info(fs_info, "scrub: devid %llu %s:%d",
>> +			   devid, ret ? "not finished":"finished", ret);
> 
> Spaces around binary operators please: ret ? "not finished" : "finished"

added in v2.
> What's the reason to print the error code here? It is returned from the
> ioctl.

It does not get logged. Help offline debugging.

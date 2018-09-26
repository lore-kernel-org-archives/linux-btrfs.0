Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9884C43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 04:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5653B20833
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 04:07:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rw8gQysI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5653B20833
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbeIZKSu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 06:18:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59670 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbeIZKSt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 06:18:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8Q45Dtw165641;
        Wed, 26 Sep 2018 04:07:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=3Qb9nBrvL1Hb8VuwHQLEGGGjvy6pma6MbHYJbPINCZc=;
 b=rw8gQysIeXWs23JmC92lFyDU+Bn35JXCBEL4rGQqcw8bqvqWMGLswMt3ypqGbboT2lgF
 +CqH86W5G6KEz+tAThXIKzcY1p8hp8fUIDt9u8F5hjbTbA7NHAPZz9Ybj9O5wFYDZKBN
 kXASqmS1uevkY9F31uDJov22P0KNn7FYV9kcDbXcCttzHM0r7vE4K+9cctDr7uypvqRv
 A0GhQaUWQ6NfjU/g195vrN3Gl7JVWi3cqkEDuBDCc2AG4Mrgz7B3FA7gAXm6ln2CevjL
 wsaA7rS44L+tWNMazO5cy34rwx+an/c3f57PkanQH0BRPOTggT1MCW7dd5KQaaVyEnl+ 2Q== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2mnd5tfydb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Sep 2018 04:07:52 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8Q47pl2026584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Sep 2018 04:07:51 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8Q47p9L008004;
        Wed, 26 Sep 2018 04:07:51 GMT
Received: from [10.186.50.4] (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Sep 2018 21:07:50 -0700
Subject: Re: [PATCH v2 1/9] fstests: btrfs: _scratch_mkfs_sized fix min size
 without mixed option
To:     Nikolay Borisov <nborisov@suse.com>, fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Omar Sandoval <osandov@osandov.com>
References: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
 <1537849462-619-2-git-send-email-anand.jain@oracle.com>
 <b054a402-0507-4990-6752-8d75b02a97ed@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <68c6443f-6d2b-ba3a-40e1-994fa5ee32e3@oracle.com>
Date:   Wed, 26 Sep 2018 12:07:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <b054a402-0507-4990-6752-8d75b02a97ed@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9027 signatures=668707
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1809260041
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 09/25/2018 06:51 PM, Nikolay Borisov wrote:
> 
> 
> On 25.09.2018 07:24, Anand Jain wrote:
>> As of now _scratch_mkfs_sized() checks if the requested size is below 1G
>> and forces the --mixed option for the mkfs.btrfs. Well the correct size
>> considering all possible group profiles at which we need to force the
>> mixed option is roughly 256Mbytes. So fix that.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> Have you considered the implications of this w.r.t commit
> d4da414a9a9d ("common/rc: raise btrfs mixed mode threshold to 1GB")
 >
> Initially this threshold was 100mb then Omar changed it to 1g. Does this
> change affect generic/427?

d4da414a9a9d does not explain what was the problem that Omar wanted to 
address, mainly what was the failure about.

And no it does not affect. I have verified generic/427 with kernel 4.1 
and 4.19-rc5 with  btrfs-progs 4.1, 4.9 and latest from kdave they all 
run fine. Good to integrate.

Thanks, Anand

> 
>> ---
>>   common/rc | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/common/rc b/common/rc
>> index d5bb1feee2c3..90dc3002bc3d 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -969,7 +969,10 @@ _scratch_mkfs_sized()
>>   	;;
>>       btrfs)
>>   	local mixed_opt=
>> -	(( fssize <= 1024 * 1024 * 1024 )) && mixed_opt='--mixed'
>> +	# minimum size that's needed without the mixed option.
>> +	# Ref: btrfs-prog: btrfs_min_dev_size()
>> +	# Non mixed mode is also the default option.
>> +	(( fssize < $((256 * 1024 *1024)) )) && mixed_opt='--mixed'
>>   	$MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize $SCRATCH_DEV
>>   	;;
>>       jfs)
>>

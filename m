Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18540 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752848AbcE2U0y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 16:26:54 -0400
Received: from pps.filterd (m0049461.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u4TKNvY8012494
	for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 16:26:53 -0400
Message-Id: <201605292026.u4TKNvY8012494@mx0a-001b2d01.pphosted.com>
Received: from e28smtp01.in.ibm.com (e28smtp01.in.ibm.com [125.16.236.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23784ss5n0-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 16:26:53 -0400
Received: from localhost
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Sun, 29 May 2016 16:47:53 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 4F0901258063
	for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 16:50:09 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay02.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u4TBHiNf14221808
	for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 16:47:44 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u4TBHkXl029145
	for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 16:47:47 +0530
Subject: Re: [PATCH 1/5] Btrfs: test_check_exists: Fix infinite loop when
 searching for free space entries
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
References: <1464332438-19119-1-git-send-email-xufeifei@linux.vnet.ibm.com>
 <201605270750.u4R7n6to033453@mx0a-001b2d01.pphosted.com>
 <0b4d85f8-d981-39a9-8b6b-329d0e648fce@fb.com>
Cc: steve.capper@linaro.org, chandan@mykolab.com, dsterba@suse.com,
        feifeixu.sh@gmail.com
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
Date: Sun, 29 May 2016 19:17:40 +0800
MIME-Version: 1.0
In-Reply-To: <0b4d85f8-d981-39a9-8b6b-329d0e648fce@fb.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2016/5/27 23:43, Josef Bacik wrote:
>
>>  fs/btrfs/free-space-cache.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
>> index 5e6062c..05c9ef8 100644
>> --- a/fs/btrfs/free-space-cache.c
>> +++ b/fs/btrfs/free-space-cache.c
>> @@ -3662,6 +3662,7 @@ have_info:
>>              if (tmp->offset + tmp->bytes < offset)
>>                  break;
>>              if (offset + bytes < tmp->offset) {
>> +                info = tmp;
>>                  n = rb_prev(&info->offset_index);
>>                  continue;
>>              }
>> @@ -3676,6 +3677,7 @@ have_info:
>>              if (offset + bytes < tmp->offset)
>>                  break;
>>              if (tmp->offset + tmp->bytes < offset) {
>> +                info = tmp;
>>                  n = rb_next(&info->offset_index);
>>                  continue;
>>              }
>>
>
> Just make it rb_next(&tmp->offset_index)/rb_prev(&tmp->offset_index) 
> instead of doing the info = tmp thing.  Thanks,
>
> Josef
>
I will change it in v2, thanks
Feifei


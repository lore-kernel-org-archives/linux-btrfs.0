Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25394 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751810AbaKFOhg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Nov 2014 09:37:36 -0500
Message-ID: <545B8725.40909@fb.com>
Date: Thu, 6 Nov 2014 09:35:17 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: don't take the chunk_mutex/dev_list mutex in statfs
 V2
References: <1415023010-12988-1-git-send-email-jbacik@fb.com> <5458A9F1.1070901@cn.fujitsu.com>
In-Reply-To: <5458A9F1.1070901@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/04/2014 05:26 AM, Miao Xie wrote:
> On Mon, 3 Nov 2014 08:56:50 -0500, Josef Bacik wrote:
>> Our gluster boxes get several thousand statfs() calls per second, which begins
>> to suck hardcore with all of the lock contention on the chunk mutex and dev list
>> mutex.  We don't really need to hold these things, if we have transient
>> weirdness with statfs() because of the chunk allocator we don't care, so remove
>> this locking.
>>
>> We still need the dev_list lock if you mount with -o alloc_start however, which
>> is a good argument for nuking that thing from orbit, but that's a patch for
>> another day.  Thanks,
>>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>> ---
>> V1->V2: make sure ->alloc_start is set before doing the dev extent lookup logic.
>
> I am strange that why we need dev_list_lock if we mount with -o alloc_start. AFAIK.
> ->alloc_start is protected by chunk_mutex.
>
> But I think we needn't care that someone changes ->alloc_start, in other words,
> we needn't take chunk_mutex during the whole process, the following case can be
> tolerated by the users, I think.
>
> 	Task1						Task2
> 	statfs
> 	  mutex_lock(&fs_info->chunk_mutex);
> 	  tmp = fs_info->alloc_start;
> 	  mutex_unlock(&fs_info->chunk_mutex);
> 	  btrfs_calc_avail_data_space(fs_info, tmp)
> 	    ...
> 							mount -o remount,alloc_start=xxxx
> 	    ...

Yeah df if you change alloc_start in the middle of it is going to be 
slightly racey, which is fine since I'm going to kill alloc_start soon 
anyway.  Since we have to take the device mutex anyway I guess we could 
do this, but I'm not super worried about it.  Thanks,

Josef


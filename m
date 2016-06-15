Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47556 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbcFOIub (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 04:50:31 -0400
Subject: Re: [PATCH 6/6] fstests: btrfs: test RAID5 device reappear and
 balance
To: Eryu Guan <eguan@redhat.com>
References: <1463495530-425-1-git-send-email-anand.jain@oracle.com>
 <1463495530-425-6-git-send-email-anand.jain@oracle.com>
 <20160612050835.GD5140@eguan.usersys.redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <08937eb8-9a92-7cb7-a3ce-8cc2fb52a6a0@oracle.com>
Date: Wed, 15 Jun 2016 16:51:16 +0800
MIME-Version: 1.0
In-Reply-To: <20160612050835.GD5140@eguan.usersys.redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/12/2016 01:08 PM, Eryu Guan wrote:
> On Tue, May 17, 2016 at 10:32:10PM +0800, Anand Jain wrote:
>> The test does the following:
>> Initialize a RAID5 with some data
>>
>> Re-mount RAID5 degraded with _dev3_ missing and write data.
>> Save md5sum checkpoint1
>>
>> Re-mount healthy RAID5
>>
>> Let balance fix degraded blocks.
>> Save md5sum checkpoint2
>>
>> Re-mount RAID1 degraded now with _dev1_ missing.
>> Save md5sum checkpoint3
>>
>> Verify if all three md5sum matches
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>
> All comments for 5/6 apply here for 6/6 :)

yep. Taken care in v2. Thanks for all the review comments.

Anand

>
> Thanks,
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

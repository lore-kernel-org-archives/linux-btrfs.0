Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw10a-lesia.wadns.net ([196.220.39.109]:47641 "EHLO
	fw10a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753112AbaEUS0q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 14:26:46 -0400
Message-ID: <537CEFD6.9010407@swiftspirit.co.za>
Date: Wed, 21 May 2014 20:26:30 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Anand Jain <Anand.Jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] btrfs: Add missing device check in dev_info/rm_dev
 ioctl
References: <1399357993-9254-1-git-send-email-quwenruo@cn.fujitsu.com> <1399357993-9254-2-git-send-email-quwenruo@cn.fujitsu.com> <5369E818.7000606@oracle.com> <537C19B9.8080203@cn.fujitsu.com> <537C235F.5030303@oracle.com> <537C285F.7080101@cn.fujitsu.com>
In-Reply-To: <537C285F.7080101@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/05/21 06:15 AM, Qu Wenruo wrote:
> [snip]
>>  Further on top of your check_missing patch I am writing
>>  code to to handle disk reappear. I should be sending them
>>  all soon.
> Disk reappear problem is also reproduce here.
>
> I am intersting about how will your patch to deal with.
> Is your patch going to check super genertion to determing previously 
> missing device and
> wipe reappeared superblock?(Wang mentioned it in the mail in Jan.)


With md we have the bitmap feature that helps prevent resynchronising 
the entire disk when doing a "re-add". Wiping the superblock is *better* 
than what we currently have (corruption) - but hopefully the end goal is 
to be able to have it re-add *without* introducing corruption.

>
> IMO the reappear disk problem can also be resolved by not swap 
> tgtdev->uuid and srcdev->uuid,
> which means tgtdev will not use the same uuid of srcdev.
>
> Thanks,
> Qu
>>
>> Thanks, Anand
>>


-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97


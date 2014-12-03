Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53921 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750830AbaLCBRt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 20:17:49 -0500
Message-ID: <547E651A.6080409@cn.fujitsu.com>
Date: Wed, 3 Dec 2014 09:19:22 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 00/10] Implement device scrub/replace for RAID56
References: <1417523971-15553-1-git-send-email-miaox@cn.fujitsu.com> <1417526902.21136.1@mail.thefacebook.com>
In-Reply-To: <1417526902.21136.1@mail.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2 Dec 2014 08:28:22 -0500, Chris Mason wrote:
> 
> 
> On Tue, Dec 2, 2014 at 7:39 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>> This patchset implement the device scrub/replace function for RAID56, the
>> most implementation of the common data is similar to the other RAID type.
>> The differentia or difficulty is the parity process. The basic idea is reading
>> and check the data which has checksum out of the raid56 stripe lock, if the
>> data is right, then lock the raid56 stripe, read out the other data in the
>> same stripe, if no IO error happens, calculate the parity and check the
>> original one, if the original parity is right, the scrub parity passes.
>> or write out the new one. But if the common data(not parity) that we read out
>> is wrong, we will try to recover it, and then check and repair the parity.
>>
>> And in order to avoid making the code more and more complex, we copy some
>> code of common data process for the parity, the cleanup work is in my
>> TODO list.
>>
>> We have done some test, the patchset worked well. Of course, more tests
>> are welcome. If you are interesting to use it or test it, you can pull
>> the patchset from
>>
>>   https://github.com/miaoxie/linux-btrfs.git raid56-scrub-replace
>>
>> Changelog v3 -> v4:
>> - Fix the problem that the scrub's raid bio was cached, which was reported
>>   by Chris.
>> - Remove the 10st patch, the deadlock that was described in that patch doesn't
>>   exist on the current kernel.
>> - Rebase the patchset to the top of integration branch
> 
> Thanks, I'll try this today.  I need to rebase in a new version of the RCU patches, can you please cook one on top of v3.18-rc6 instead?

No problem.

Thanks
Miao

> 
> -chris
> 
> 


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49411 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623AbcDBBis (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Apr 2016 21:38:48 -0400
Subject: Re: Global hotspare functionality
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
References: <20160318193937.GA21352@jek-Latitude-E7440>
 <56FA9420.8020503@oracle.com> <20160329194722.GC27148@jeknote.loshitsa1.net>
 <56FF1D4C.9030200@oracle.com> <20160402013339.GA27630@jeknote.loshitsa1.net>
Cc: linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56FF22A5.5060605@oracle.com>
Date: Sat, 2 Apr 2016 09:38:45 +0800
MIME-Version: 1.0
In-Reply-To: <20160402013339.GA27630@jeknote.loshitsa1.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/02/2016 09:33 AM, Yauhen Kharuzhy wrote:
> On Sat, Apr 02, 2016 at 09:15:56AM +0800, Anand Jain wrote:
>>
>>
>> On 03/30/2016 03:47 AM, Yauhen Kharuzhy wrote:
>>> On Tue, Mar 29, 2016 at 10:41:36PM +0800, Anand Jain wrote:
>>>>
>>>> Hi Yauhen,
>>>>
>>>
>>>>>
>>>>> Issue 2.
>>>>> At start of autoreplacig drive by hotspare, kernel craches in transaction
>>>>> handling code (inside of btrfs_commit_transaction() called by autoreplace initiating
>>>>> routines). I 'fixed' this by removing of closing of bdev in btrfs_close_one_device_dont_free(), see
>>>>> https://bitbucket.org/jekhor/linux-btrfs/commits/dfa441c9ec7b3833f6a5e4d0b6f8c678faea29bb?at=master
>>>>> (oops text is attached also). Bdev is closed after replacing by
>>>>> btrfs_dev_replace_finishing(), so this is safe but doesn't seem
>>>>> to be right way.
>>>>
>>>>   I have sent out V2. I don't see that issue with this,
>>>>   could you pls try ?
>>>
>>> Yes, it reproduced on v4.4.5 kernel. I will try with current
>>> 'for-linus-4.6' Chris' tree soon.
>>>
>>> To emulate a drive failure, I disconnect the drive in VirtualBox, so bdev
>>> can be freed by kernel after releasing of all references to it.
>>
>>    So far the raid group profile would adapt to lower suitable
>>    group profile when device is missing/failed. This appears to
>>    be not happening with RAID56 OR there are stale IO which wasn't
>>    flushed out. Anyway to have this fixed I am moving the patch
>>     btrfs: introduce device dynamic state transition to offline or failed
>>    to the top in v3 for any potential changes.
>>    But firstly we need a reliable test case, or a very carefully
>>    crafted test case which can create this situation
>>
>>    Here below is the dm-error that I am using for testing, which
>>    apparently doesn't report this issue. Could you please try on V3. ?
>>    (pls note the device names are hard coded in the test script
>>    sorry about that) This would eventually be fstests script.
>
> Sure. But I don't see any V3 patches in the list. Are you still
> preparing to send them or I missed something?

  Its out now. There was a little distraction when I was about to send it.


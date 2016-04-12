Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48868 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933814AbcDLOQo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Apr 2016 10:16:44 -0400
Subject: Re: Global hotspare functionality
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
References: <20160318193937.GA21352@jek-Latitude-E7440>
 <56FA9420.8020503@oracle.com> <20160329194722.GC27148@jeknote.loshitsa1.net>
 <56FF1D4C.9030200@oracle.com>
 <CAKWEGV7BOq-_AFaDyAaLd1hs=HVxSf+wka7++U+QG7R=diYT=w@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <570D0339.2010506@oracle.com>
Date: Tue, 12 Apr 2016 22:16:25 +0800
MIME-Version: 1.0
In-Reply-To: <CAKWEGV7BOq-_AFaDyAaLd1hs=HVxSf+wka7++U+QG7R=diYT=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/05/2016 03:32 AM, Yauhen Kharuzhy wrote:
> 2016-04-01 18:15 GMT-07:00 Anand Jain <anand.jain@oracle.com>:
>>>>> Issue 2.
>>>>> At start of autoreplacig drive by hotspare, kernel craches in
>>>>> transaction
>>>>> handling code (inside of btrfs_commit_transaction() called by
>>>>> autoreplace initiating
>>>>> routines). I 'fixed' this by removing of closing of bdev in
>>>>> btrfs_close_one_device_dont_free(), see
>>>>>
>>>>> https://bitbucket.org/jekhor/linux-btrfs/commits/dfa441c9ec7b3833f6a5e4d0b6f8c678faea29bb?at=master
>>>>> (oops text is attached also). Bdev is closed after replacing by
>>>>> btrfs_dev_replace_finishing(), so this is safe but doesn't seem
>>>>> to be right way.
>>>>
>>>>
>>>>    I have sent out V2. I don't see that issue with this,
>>>>    could you pls try ?
>>>
>>>
>>> Yes, it reproduced on v4.4.5 kernel. I will try with current
>>> 'for-linus-4.6' Chris' tree soon.
>>>
>>> To emulate a drive failure, I disconnect the drive in VirtualBox, so bdev
>>> can be freed by kernel after releasing of all references to it.
>>
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
> Hi,
>
> I have reproduced this oops with attached script. I don't use any dm
> layer, but just detach drive at scsi layer as xfstests do (device
> management functions were copy-pasted from it).

  Nice. I was able reproduce this (also found lock dep issue when running
  this, since it was in the original code a separate patch was sent
  ou). The issue was due to that bdev wasn't null, to fix this the
  btrfs_device_enforce_state() is changed quite a bit. V4 is out.

Thanks, Anand


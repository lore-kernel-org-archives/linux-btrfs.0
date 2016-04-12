Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34218 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755266AbcDLAaM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Apr 2016 20:30:12 -0400
Subject: Re: WARN_ON in record_root_in_trans() when deleting freshly renamed
 subvolume
To: Mark Fasheh <mfasheh@suse.de>
References: <57068E64.7000408@googlemail.com>
 <CAL3q7H6U8hDK7+BOqP-u3ogrJaKxED3U839kmT_PU6kbq9U1AA@mail.gmail.com>
 <57079B4D.8080304@googlemail.com> <5707ADCB.9090207@googlemail.com>
 <20160408191855.GK2187@wotan.suse.de> <570AF86B.2060805@cn.fujitsu.com>
 <20160411180926.GL2187@wotan.suse.de>
CC: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>,
        Filipe David Manana <fdmanana@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <570C418F.40906@cn.fujitsu.com>
Date: Tue, 12 Apr 2016 08:30:07 +0800
MIME-Version: 1.0
In-Reply-To: <20160411180926.GL2187@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Mark Fasheh wrote on 2016/04/11 11:09 -0700:
> On Mon, Apr 11, 2016 at 09:05:47AM +0800, Qu Wenruo wrote:
>>
>>
>> Mark Fasheh wrote on 2016/04/08 12:18 -0700:
>>> On Fri, Apr 08, 2016 at 03:10:35PM +0200, Holger Hoffstätte wrote:
>>>> [cc: Mark and Qu]
>>>>
>>>> On 04/08/16 13:51, Holger Hoffstätte wrote:
>>>>> On 04/08/16 13:14, Filipe Manana wrote:
>>>>>> Using Chris' for-linus-4.6 branch, which is 4.5-rc6 + all 4.6 btrfs
>>>>>> patches, it didn't reproduce here:
>>>>>
>>>>> Great, that's good to know (sort of :). Thanks also to Liu Bo.
>>>>>
>>>>>> Are you sure that you are not using some patches not in 4.6?
>>>>
>>>> We have a bingo!
>>>>
>>>> Reverting "qgroup: Fix qgroup accounting when creating snapshot"
>>> >from last Wednesday immediately fixes the problem.
>>>
>>> Not surprising, I had some issues testing it out too. I'm pretty sure this
>>> patch is corrupting memory, I just haven't found where yet though my
>>> educated guess is that the transaction is being reused improperly.
>>> 	--Mark
>>>
>>> --
>>> Mark Fasheh
>>>
>>>
>> Still digging the bug Mark has reported about the patch.
>>
>> Good to have another report, as I can't always reproduce the soft
>> lockup from Mark.
>>
>> It seems that the WARN_ON will bring another clue to fix it.
>>
>> BTW, the memory corruption assumption seems to be quite helpful.
>> I didn't consider in that way, but it seems to be the only reason
>> causing dead spinlock while no other thread spinning and no lockdep
>> warning.
>
> It seems to be the call to commit_cowonly_roots() in your patch which sets
> everything off. If I remove that call I can run all day without a crash.
>
> Btw, I'm not convinced this fixes the qgroup numbers anyway - we are still
> inconsistent even if I don't get a crash.
>
> Have you tested that the actual numbers on your end are coming out ok?
> 	--Mark

Yes, my initial test shows that the snapshot of fs tree doesn't break 
the number anymore.

And commit_cowonly_roots() is the core of the fix, without it the bug 
won't be fixed.

I'm still digging but it seems to be related to missing 
switch_commit_roots() call after commit_cowonly_roots(), but still 
uncertain, as I'm not familiar with the commit codes.

Thanks,
Qu

>
> --
> Mark Fasheh
>
>



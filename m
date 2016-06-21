Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37804 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750885AbcFUJ1g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 05:27:36 -0400
Subject: Re: [PATCH v11 00/13] Btrfs dedupe framework
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        <chandan@linux.vnet.ibm.com>
References: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
 <20160620160354.GR4915@twin.jikos.cz>
 <91d6f331-14de-5d1b-b73e-c24c0bfe950e@cn.fujitsu.com>
 <20160621091342.GS4915@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <b42450d1-d929-7d8d-bbb7-126314002d92@cn.fujitsu.com>
Date: Tue, 21 Jun 2016 17:26:23 +0800
MIME-Version: 1.0
In-Reply-To: <20160621091342.GS4915@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/21/2016 05:13 PM, David Sterba wrote:
> On Tue, Jun 21, 2016 at 08:36:49AM +0800, Qu Wenruo wrote:
>>> I'm looking how well does this patchset merges with the rest, so far
>>> there are excpected conflicts with Chandan's subpage-blocksize
>>> patchset. For the easy parts, we can add stub patches to extend
>>> functions like cow_file_range with parameters that are added by the
>>> other patch.
>>>
>>> Honestly I don't know which patchset to take first. As the
>>> subpage-blockszie is in the core, there are no user visibility and
>>> interface questions, but it must not cause any regressions.
>>>
>>> Dedupe is optional, not default, and we have to mainly make sure it does
>>> not have any impact when turned off.
>>>
>>> So I see three possible ways:
>>>
>>> * merge subpage first, as it defines the API, adapt dedupe
>>
>> Personally, I'd like to merge subpage first.
>>
>> AFAIK, it's more important than dedupe.
>> It affects whether a fs created in 64K page size environment can be
>> mounted on a 4K page size system.
>
> Yeah, but I'm now concerned about the way both will be integrated in the
> development or preview branches, not really the functionality itself.
>
> Now the conflicts are not trivial, so this takes extra time on my side
> and I can't be sure about the result in the end if I put only minor
> efforts to resolve the conflicts ("make it compile"). And I don't want
> to do that too often.
>
> As stated in past discussions, the features of this impact should spend
> one development cycle in for-next, even if it's not ready for merge or
> there are reviews going on.
>
> The subpage patchset is now in a relatively good shape to start actual
> testing, which already revealed some problems.
>
>
I'm completely OK to do the rebase, but since I don't have 64K page size 
machine to test the rebase, we can only test if 4K system is unaffected.

Although not much help, at least it would be better than making it compile.

Also such rebase may help us to expose bad design/unexpected corner case 
in dedupe.
So if it's OK, please let me try to do the rebase.

Thanks,
Qu



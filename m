Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35071 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965166AbbKDBBm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Nov 2015 20:01:42 -0500
Subject: Re: Regression in: [PATCH 4/4] btrfs: qgroup: account shared subtree
 during snapshot delete
To: Mark Fasheh <mfasheh@suse.de>
References: <56367AE8.9030509@profihost.ag> <5636BDA0.4020200@cn.fujitsu.com>
 <20151103192625.GE15575@wotan.suse.de>
CC: Stefan Priebe <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <jbacik@fb.com>, Chris Mason <clm@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <563958F0.6030904@cn.fujitsu.com>
Date: Wed, 4 Nov 2015 09:01:36 +0800
MIME-Version: 1.0
In-Reply-To: <20151103192625.GE15575@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Mark Fasheh wrote on 2015/11/03 11:26 -0800:
> On Mon, Nov 02, 2015 at 09:34:24AM +0800, Qu Wenruo wrote:
>>
>>
>> Stefan Priebe wrote on 2015/11/01 21:49 +0100:
>>> Hi,
>>>
>>> this one: http://www.spinics.net/lists/linux-btrfs/msg47377.html
>>>
>>> adds a regression to my test systems with very large disks (30tb and 50tb).
>>>
>>> btrfs balance is super slow afterwards while heavily making use of cp
>>> --reflink=always on big files (200gb - 500gb).
>>>
>>> Sorry didn't know how to correctly reply to that "old" message.
>>>
>>> Greets,
>>> Stefan
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> Thanks for the testing.
>>
>> Are you using qgroup or just doing normal balance with qgroup disabled?
>>
>> For the latter case, that's should be optimized to skip the dirty
>> extent insert in qgroup disabled case.
>>
>> For qgroup enabled case, I'm afraid that's the design.
>> As relocation will drop a subtree to relocate, and to ensure qgroup
>> consistent, we must walk down all the tree blocks and mark them
>> dirty for later qgroup accounting.
>
> Qu, we're always going to have to walk the tree when deleting it, this is
> part of removing a subvolume. We've walked shared subtrees in this code for
> numerous kernel releases without incident before it was removed in 4.2.
>
> Do you have any actual evidence that this is a major performance regression?
>  From our previous conversations you seemed convinced of this, without even
> having a working subtree walk to test. I remember the hand wringing
> about an individual commit being too heavy with the qgroup code (even though
> I pointed out that tree walk is a restartable transaction).
>
> It seems that you are confused still about how we handle removing a volume
> wrt qgroups.
>
> If you have questions or concerns I would be happy to explain them but
> IMHO your statements there are opinion and not based in fact.

Yes, I don't deny it.
But it's quite hard to prove it, as we need such a huge storage like Stefan.
What I have is only several hundred GB test storage.
Even accounting all my home NAS, I only have 2T, far from the storage 
Stefan has.

And what Stefan report should already give some hint about the 
performance issue.

In your word "it won't be doing anything (ok some kmalloc/free of a very 
tiny object)", it's already slowing down balance, since balance also use 
btrfs_drop_subtree().

You're right about tree walk can happen in several transaction, and 
normally user won't notice anything as subvolume delete is in background.

But in relocating case, it's causing relocation slower than it was,
due to "nothing(kmalloc/free ting objects)".
Yes, you can fix it by avoid memory allocation in qgroup disabled case,
but what will happen if user enabled qgroup?


I'm not saying there is anything wrong about your patch, in fact I'm 
quite happy you solved such problem with so small changes.

But we can't just ignore such "possible" performance issue just because 
old code did the same thing.(Although not the same now, we're marking 
all subtree blocks dirty other than shared one).

Thanks,
Qu

>
> Yes btw, we might have to do more work for the uncommon case of a
> qgroup being referenced by higher level groups but that is clearly not
> happening here (and honestly it's not a common case at all).
> 	--Mark
>
>
> --
> Mark Fasheh
>

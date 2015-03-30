Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:35182 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbbC3PJz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 11:09:55 -0400
Received: by wgdm6 with SMTP id m6so178712228wgd.2
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2015 08:09:54 -0700 (PDT)
Message-ID: <55196740.1000705@gmail.com>
Date: Mon, 30 Mar 2015 17:09:52 +0200
From: Marc Cousin <cousinmarc@gmail.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: snapshot destruction making IO extremely slow
References: <550E7917.5030602@gmail.com> <20150325011937.GB20767@twin.jikos.cz> <55129428.7090508@gmail.com> <20150330142532.GI32051@suse.cz>
In-Reply-To: <20150330142532.GI32051@suse.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 30/03/2015 16:25, David Sterba wrote:
> On Wed, Mar 25, 2015 at 11:55:36AM +0100, Marc Cousin wrote:
>> On 25/03/2015 02:19, David Sterba wrote:
>>> Snapper might add to that if you have
>>>
>>> EMPTY_PRE_POST_CLEANUP="yes"
>>>
>>> as it reads the pre/post snapshots and deletes them if the diff is
>>> empty. This adds some IO stress.
>>
>> I couldn't find a clear explanation in the documentation. Does it mean
>> that when there is absolutely no difference between two snapshots, one
>> of them is deleted ?
> 
> Only the pre-post snapshots, ie. no timeline or other types (eg.
> manually created one).
> 
>> And that snapper does a diff between them to
>> determine that ?
> 
> AFAIK yes.
> 
>> If so, yes, I can remove it, I don't care about that :)
>>
>>>
>>>> The btrfs cleaner is 100% active:
>>>>
>>>>  1501 root      20   0       0      0      0 R 100,0  0,0   9:10.40 [btrfs-cleaner]    
>>>
>>> That points to the snapshot cleaning, but the cleaner thread does more
>>> than that. It may also process delayed file deletion and work scheduled
>>> if 'autodefrag' is on.
>>
>> autodefrag is activated. These are mechanical drives, so I'd rather keep
>> it on, shouldn't I ?
> 
> You should (I do have autogefrag on), unless you applications are
> latency sensitive and you can measure the difference. Autodefrag tends
> to read/write surrounding blocks for random write so it may imply some
> seek penalty if the affected block is far from the others.
> 
>>>> What is "funny" is that the filesystem seems to be working again when
>>>> there is some IO activity and btrfs-cleaner gets to a lower cpu usage
>>>> (around 70%).
>>>
>>> Possibly a behaviour caused by scheduling (both cpu and io), the other
>>> process gets a slice and slows down cleaner that hogs the system.
>>
>> I have almost no IO on these disks during the problem (I had put an
>> iostat on the first email). Only one CPU core at 100% load. That's why I
>> felt it looked more like a locking or serialization issue.
> 
> So it would be good to sample the active threads and see where it's
> spending the time. It could be the somewhere in the rb-tree representing
> extents, but that's a guess.
> 
I just need to be told how to do that :)

Something like a perf top ?

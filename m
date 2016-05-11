Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65031 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932070AbcEKQL1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 12:11:27 -0400
Subject: Re: [PATCH 1/2] Btrfs: fix race between fsync and direct IO writes
 for prealloc extents
To: Chris Mason <clm@fb.com>, Filipe Manana <fdmanana@kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1462802509-1974-1-git-send-email-fdmanana@kernel.org>
 <c1a1a668-07c9-3402-993f-de7b341511e7@fb.com>
 <CAL3q7H6t-64EKDP6MeM3MmNOjBN24OEGPOE17y0pyMYkt9pknA@mail.gmail.com>
 <20160511160547.m2fupj7ecatntuhs@floor.thefacebook.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <7201c7ee-8ef2-63d3-7aa0-1adfd8e495e3@fb.com>
Date: Wed, 11 May 2016 09:10:12 -0700
MIME-Version: 1.0
In-Reply-To: <20160511160547.m2fupj7ecatntuhs@floor.thefacebook.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/11/2016 09:05 AM, Chris Mason wrote:
> On Wed, May 11, 2016 at 04:56:56PM +0100, Filipe Manana wrote:
>> On Wed, May 11, 2016 at 4:41 PM, Josef Bacik <jbacik@fb.com> wrote:
>>> On 05/09/2016 07:01 AM, fdmanana@kernel.org wrote:
>>>>
>>>> From: Filipe Manana <fdmanana@suse.com>
>>>>
>>>> When we do a direct IO write against a preallocated extent (fallocate)
>>>> that does not go beyond the i_size of the inode, we do the write operation
>>>> without holding the inode's i_mutex (an optimization that landed in
>>>> commit 38851cc19adb ("Btrfs: implement unlocked dio write")). This allows
>>>> for a very tiny time window where a race can happen with a concurrent
>>>> fsync using the fast code path, as the direct IO write path creates first
>>>> a new extent map (no longer flagged as a prealloc extent) and then it
>>>> creates the ordered extent, while the fast fsync path first collects
>>>> ordered extents and then it collects extent maps. This allows for the
>>>> possibility of the fast fsync path to collect the new extent map without
>>>> collecting the new ordered extent, and therefore logging an extent item
>>>> based on the extent map without waiting for the ordered extent to be
>>>> created and complete. This can result in a situation where after a log
>>>> replay we end up with an extent not marked anymore as prealloc but it was
>>>> only partially written (or not written at all), exposing random, stale or
>>>> garbage data corresponding to the unwritten pages and without any
>>>> checksums in the csum tree covering the extent's range.
>>>>
>>>> This is an extension of what was done in commit de0ee0edb21f ("Btrfs: fix
>>>> race between fsync and lockless direct IO writes").
>>>>
>>>> So fix this by creating first the ordered extent and then the extent
>>>> map, so that this way if the fast fsync patch collects the new extent
>>>> map it also collects the corresponding ordered extent.
>>>>
>>>
>>> So this seems to just be trading one problem for another bad behavior. Now
>>> instead we'll end up with an ordered extent but possibly not the extent map,
>>> which is fine, but seems ugly, and is a subtle and undocumented behavior
>>> that is going to bite us in the ass in the future.
>>>
>>> I know everybody loves lockless writes, but we need to protect for this
>>> particular case in an explicit way so I don't go change something in the
>>> future and forget about this dependency.  What if we add a rwsem around
>>> adding the extent map and the ordered extent.  In fact we pull this dance
>>> out into a common helper function so everybody who wants to do this just
>>> calls the helper function that is easy to audit and understand, then we just
>>> put a
>>>
>>> down_read(&BTRFS_I(inode)->lets_not_fuck_fsync));
>>> /* Do our extent map + ordered extent dance here */
>>> up_read(&BTRFS_I(inode)->lets_not_fuck_fsync));
>>>
>>> and then where we gather all of this stuff in fsync we do a
>>> down_write/up_write.  This won't affect the buffered write case currently as
>>> we're still protected by the i_mutex, and then makes the direct io case much
>>> cleaner and safer.  Then later on when we want to remove the i_mutex from
>>> the buffered write case we have one less gotcha to worry about.  Thanks,
>>
>> Agreed. I though about something similar initially but I didn't want
>> to increase the size of struct btrfs_inode.
>> Would you mind that if instead of changing this patch I do one on top
>> that introduces that helper function, and makes this and the other
>> place in the dio path that does the same logic use it too?
>
> Once we go down the rwsem path, we might want to look at overall DIO
> locking and see where else it fits in.  We can probably get rid of a few
> warts with it.
>

I hesitate to suggest this, but long term I'd like to look at just using 
our range locking for all of this, and do something like (u64)-1 for the 
end when we are talking the whole file.  That would remove the need for 
a lot of this other locking stuff.  But I imagine that'll cause more 
problems than it solves atm.  Thanks,

Josef


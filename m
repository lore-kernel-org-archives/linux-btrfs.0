Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54706 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727610AbeGPO4p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 10:56:45 -0400
Subject: Re: [PATCH 2nd try v4] btrfs: drop uuid_mutex in
 btrfs_free_extra_devids()
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180528144329.7790-1-anand.jain@oracle.com>
 <20180528154030.GD6649@twin.jikos.cz>
 <6daefb49-195a-71c1-7f9f-4c8b13136e31@oracle.com>
 <b3f91646-39a5-81cd-f2a0-fce91e7991a1@oracle.com>
 <20180529111929.GJ6649@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <6924ea4b-0b20-a93d-dcca-1ed325e21635@oracle.com>
Date: Mon, 16 Jul 2018 22:32:22 +0800
MIME-Version: 1.0
In-Reply-To: <20180529111929.GJ6649@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/29/2018 07:19 PM, David Sterba wrote:
> On Tue, May 29, 2018 at 01:40:34PM +0800, Anand Jain wrote:
>>>>> v3->v4: As we traverse through the seed device, fs_device gets
>>>>> updated with
>>>>>      the child seed fs_devices, so make sure we use the same fs_devices
>>>>>      pointer for the mutex_unlock as used for the mutex_lock.
>>>>
>>>> Well, now that I see the change, shouldn't we always hold the
>>>> device_list_mutex of the fs_devices that's being processed? Ie. each
>>>> time it's switched, the previous is unlocked and new one locked.
>>>
>>>    No David. That's because we organize seed device under its parent
>>>    fs_devices ((fs_devices::seed)::seed)..so on, and they are a local
>>>    cloned copy of the original seed fs_devices. So parent's
>>>    fs_devices::device_list_mutex lock will suffice.
>>
>>    On the 2nd thought, though theoretically you are right. But practically
>>    there isn't any use case which can benefit by using the intricate
>>    locking as you suggested above.
> 
> I don't think it's intricate or complex, just lock the fs_devices that
> can be potentially modified in the following loop.
> 
> Schematically:
> 
> function called with some fs_devices
> 
> again:
> 	lock fs_devices->device_list_mutex
> 	foreach device in fs_devices
> 		if ...
> 			fs_devices counters get changed after device
> 			deletion
> 	endfor
> 
> 	if (fs_devices->seed)
> 		unlock fs_devices->device_list_mutex
> 		fs_devices = fs_devices->seed
> 		lock fs_devices->device_list_mutex      <-- lock the new one
> 		goto again
> 	endif
> 
> 	unlock fs_devices->device_list_mutex            <-- correctly unlock
> endfunc
> 
>>    I am following the following method:-
>>    By holding the parent fs_devices (which is also the mounted fs_devices
>>    lock) it would imply to lock its dependent cloned seed fs_devices, as
>>    to reach the cloned seed device, first we need to traverse from the
>>    parent fs_devices.
> 
> Locking the parent fs_devices might be the right scheme, but if any
> child fs_devices pointer gets passed to a random function that will
> change it, then the locking will not protect it.

If its not holding the parent fs_devices lock then it would a bug and
if its already holding the parent lock then child lock isn't necessary
at all.

Also sent the
   [DOC] BTRFS Volume operations, Device Lists and Locks all in one page
to have a holistic vewi.

Its not too convincing to me the approach of using the per fs_devices
lock when fs_devices::seed is traversed its not necessary.

Thanks, Anand


> This might need a deeper audit how the seeding device is done and maybe
> add some helpers that eg. lock the whole chain so all of them are
> protected.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58228 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753783AbdKFPCY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 10:02:24 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8A555AC0C
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 15:02:22 +0000 (UTC)
Subject: Re: [PATCH 06/11] btrfs: document device locking
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <cover.1509471604.git.dsterba@suse.com>
 <5f3dc05b0b44803e9d20498970f259ead2bfe7de.1509471604.git.dsterba@suse.com>
 <eb745210-9d49-1d74-5715-9fc29f6cb3c1@suse.com>
 <20171106135156.GD28789@suse.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <5661b2a4-3f0d-281e-6472-66cd48e08eca@suse.com>
Date: Mon, 6 Nov 2017 17:02:21 +0200
MIME-Version: 1.0
In-Reply-To: <20171106135156.GD28789@suse.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  6.11.2017 15:51, David Sterba wrote:
> On Thu, Nov 02, 2017 at 12:29:17PM +0200, Nikolay Borisov wrote:
>> On 31.10.2017 19:44, David Sterba wrote:
>>> Overview of the main locks protecting various device-related structures.
>>>
>>> Signed-off-by: David Sterba <dsterba@suse.com>
>>> ---
>>>  fs/btrfs/volumes.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 66 insertions(+)
>>>
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index 75aed8ec64bd..098affc58361 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -145,6 +145,72 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>>>  			     struct btrfs_bio **bbio_ret,
>>>  			     int mirror_num, int need_raid_map);
>>>  
>>> +/*
>>> + * Device locking
>>> + * ==============
>>> + *
>>> + * There are several mutexes that protect manipulation of devices and low-level
>>> + * structures like chunks but not block groups, extents or files
>>
>> This sentence suggests you are describing the various mutexes but it
>> seems you are also describing data structure below i.e.
>> global::fs_devs/btrfs_device::name
> 
> In my understanding, documenting a mutex means defining the context and
> data that are protected in the context. So I can start with the mutex,
> or the data itself, but the mutex makes IMO more sense to start.
> 
> 
>>> + * - uuid_mutex (global lock)
>>> + *
>>> + *   protects the fs_uuids list that tracks all per-fs fs_devices, resulting
>>> + *   from the SCAN_DEV ioctl registration or from mount either implicitly
>>> + *   (the first device) or requested by the device= mount option
>>> + *
>>> + *   the mutex can be very coarse and can cover long-running operations
>>> + *
>>> + *   protects: updates to fs_devices counters like missing devices, rw devices,
>>> + *   seeding, structure cloning, openning/closing devices at mount/umount time
>>
>> Perhaps move the uuid_mutex description after btrfs_device::name. That
>> way mutexes are grouped together and data structures are grouped as well.
> 
> The grouping is by mutex.
> 
>>> + *
>>> + *   global::fs_devs - add, remove, updates to the global list
>>
>> You seem to be describing a data structure here rather than a mutex
> 
> As I read it, this means "if this mutex is taken, it protects
> global::fs_devs in this way".
> 
>>> + *   does not protect: manipulation of the fs_devices::devices list!
>>
>> but this sentence is written as if you've just described a mutex. The
>> end result is that it's not clear what mutex you are referring to here.
> 
> That's the mutex in the section above "- uuid_mutex (global lock)".
> 
>>> + *   btrfs_device::name - renames (write side), read is RCU
>>
>> It's not clear how the write side is protected.
> 
> same answer, it's under the 'uuid_mutex', so the write side is protected
> by that, with exception of reads protected by RCU.
> 
> I wonder what kind of documentation structure do you expect as it seems
> to me you missed it completely. Which is a valuable feedback to me, but
> I don't know how to fix it, other than make the sections more visible
> with underlining or indenting or more whitespace.

Right, I did a fresh read and indeed the structure now makes sense. I
have completely missed the nesting though. Maybe you can nest more
agressively, now every sentence is aligned to the header, perhaps we
want to have it one level deeper? Or use more than one - at the mutex
level ? I don't really have a clear-cut answer for you.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

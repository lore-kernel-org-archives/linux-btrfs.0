Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:36342 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751491AbdJFV1D (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Oct 2017 17:27:03 -0400
Subject: Re: [PATCH v4] btrfs: Remove received_uuid during received snapshot
 ro->rw switch
To: Andrei Borzenkov <arvidjaar@gmail.com>, dsterba@suse.cz,
        Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20171004150039.GE3521@twin.jikos.cz>
 <1507191773-23039-1-git-send-email-nborisov@suse.com>
 <f80cdc51-a077-60fa-01b3-3521c0adfdfb@oracle.com>
 <20171006172415.GW3521@twin.jikos.cz>
 <52a7046b-1ef8-e452-4ca4-d9eda2d8d1a2@mendix.com>
 <e118b4e4-fd52-6ac3-0446-1dd5a7976544@gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <ec221e1c-3cac-d35b-2bb9-fe66675b106e@mendix.com>
Date: Fri, 6 Oct 2017 23:27:01 +0200
MIME-Version: 1.0
In-Reply-To: <e118b4e4-fd52-6ac3-0446-1dd5a7976544@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/06/2017 10:07 PM, Andrei Borzenkov wrote:
> 06.10.2017 20:49, Hans van Kranenburg пишет:
>> On 10/06/2017 07:24 PM, David Sterba wrote:
>>> On Thu, Oct 05, 2017 at 05:03:47PM +0800, Anand Jain wrote:
>>>> On 10/05/2017 04:22 PM, Nikolay Borisov wrote:
>>>>> Currently when a read-only snapshot is received and subsequently its ro property
>>>>> is set to false i.e. switched to rw-mode the received_uuid of that subvol remains
>>>>> intact. However, once the received volume is switched to RW mode we cannot
>>>>> guaranteee that it contains the same data, so it makes sense to remove the
>>>>> received uuid. The presence of the received_uuid can also cause problems when
>>>>> the volume is being send.
>>
>> Are the 'can cause problems when being send' explained somewhere?
>>
> 
> If received_uuid is present, btrfs send will use it instead of subvolume
> uuid. It means btrfs receive may find wrong volume as differential
> stream base. Example that was demonstrated earlier
> 
> 1. A -> B on remote system S. B now has received_uui == A
> 2. A -> C on local system. C now has received_uuid == A
> 3. C is made read-write and changed.
> 4. Create snapshot D from C and do "btrfs send -p C D" to system S. Now
> btrfs receive on S will get base uuid of A and will find B. So any
> changes between B and C are silently lost.

Ah ok, yes, so the 'also' in that sentence just needs to go away. When
there are any modifications, it CAN NOT keep the received_uuid or bad
things will happen. and that's why this whole thread was started.

>>>>
>>>> Wonder if this [1] approach was considered
>>>> [1]
>>>>   - set a flag on the subvolume to indicate its dirtied so that 
>>>> received_uuid can be kept forever just in case if user needs it for some 
>>>> reference at a later point of time.
>>>
>>> Yeah, we need to be careful here. There are more items related to the
>>> recived subvolume, besides received_uuid there's rtransid and rtime so
>>> they might need to be cleared as well.
>>>
>>> I don't remember all the details how the send/receive and uuids
>>> interact. Switching from ro->rw needs to affect the 'received' status,
>>> but I don't know how. The problem is that some information is being lost
>>> although it may be quite important to the user/administrator. In such
>>> cases it would be convenient to request a confirmation via a --force
>>> flag or something like that.
>>
>> On IRC I think we generally recommends users to never do this, and as a
>> best practice always clone the snapshot to a rw subvolume in a different
>> location if someone wants to proceed working with the contents and
>> changing them as opposed to messing with the ro/rw attributes.
>>
>> So, what about option [2]:
>>
>> [2] if a subvolume has a received_uuid, then just do not allow changing
>> it to rw.
>>
> 
> What is reason behind allowing change from ro to rw in the first place?
> What is the use case?

I think this is a case of "well, nobody actually has been thinking of
the use cases ever, we just did something yolo"

Btrfs does not make a difference between snapshots and clones. Other
systems like netapp and zfs do. Btrfs cloud also do that, and just not
expose the ro/rw flag to the outside.

Personally, I would like btrfs to go into that direction, because it
just makes things more clear. This is a snapshot, you cannot touch it.
If you want to make changes, you have to make a rw clone of the snapshot.

The nice thing for btrfs is that you can remove the snapshot after you
made the rw clone, which you cannot do on a NetApp filer. :o)

>> Even if it wouldn't make sense for some reason, it's a nice thought
>> experiment. :)

There we go :)

-- 
Hans van Kranenburg

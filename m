Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:35559 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750916AbdLRNHA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 08:07:00 -0500
Received: by mail-it0-f50.google.com with SMTP id f143so27556126itb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Dec 2017 05:07:00 -0800 (PST)
Subject: Re: Unexpected raid1 behaviour
To: Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
Date: Mon, 18 Dec 2017 08:06:57 -0500
MIME-Version: 1.0
In-Reply-To: <23094.37316.66397.431081@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-12-17 10:48, Peter Grandi wrote:
> "Duncan"'s reply is slightly optimistic in parts, so some
> further information...
> 
> [ ... ]
> 
>> Basically, at this point btrfs doesn't have "dynamic" device
>> handling.  That is, if a device disappears, it doesn't know
>> it.
> 
> That's just the consequence of what is a completely broken
> conceptual model: the current way most multi-device profiles are
> designed is that block-devices and only be "added" or "removed",
> and cannot be "broken"/"missing". Therefore if IO fails, that is
> just one IO failing, not the entire block-device going away.
> The time when a block-device is noticed as sort-of missing is
> when it is not available for "add"-ing at start.
> 
> Put another way, the multi-device design is/was based on the
> demented idea that block-devices that are missing are/should be
> "remove"d, so that a 2-device volume with a 'raid1' profile
> becomes a 1-device volume with a 'single'/'dup' profile, and not
> a 2-device volume with a missing block-device and an incomplete
> 'raid1' profile, even if things have been awkwardly moving in
> that direction in recent years.
> 
> Note the above is not totally accurate today because various
> hacks have been introduced to work around the various issues.
You do realize you just restated exactly what Duncan said, just in a 
much more verbose (and aggressively negative) manner...
> 
>> Thus, if a device disappears, to get it back you really have
>> to reboot, or at least unload/reload the btrfs kernel module,
>> in ordered to clear the stale device state and have btrfs
>> rescan and reassociate devices with the matching filesystems.
> 
> IIRC that is not quite accurate: a "missing" device can be
> nowadays "replace"d (by "devid") or "remove"d, the latter
> possibly implying profile changes:
> 
>    https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Using_add_and_delete
> 
> Terrible tricks like this also work:
> 
>    https://www.spinics.net/lists/linux-btrfs/msg48394.html
While that is all true, none of that _fixes_ the issue of a device 
disappearing and then being reconnected.  In theory, you can use `btrfs 
device replace` to force BTRFS to acknowledge the new name (by 
'replacing' the missing device with the now returned device), but doing 
so is horribly inefficient as to not be worth it unless you have no 
other choice.
> 
>> Meanwhile, as mentioned above, there's active work on proper
>> dynamic btrfs device tracking and management. It may or may
>> not be ready for 4.16, but once it goes in, btrfs should
>> properly detect a device going away and react accordingly,
> 
> I haven't seen that, but I doubt that it is the radical redesign
> of the multi-device layer of Btrfs that is needed to give it
> operational semantics similar to those of MD RAID, and that I
> have vaguely described previously.
Anand has been working on hot spare support, and as part of that has 
done some work on handling of missing devices.
> 
>> and it should detect a device coming back as a different
>> device too.
> 
> That is disagreeable because of poor terminology: I guess that
> what was intended that it should be able to detect a previous
> member block-device becoming available again as a different
> device inode, which currently is very dangerous in some vital
> situations.
How exactly is this dangerous?  The only situation I can think of is if 
a bogus device is hot-plugged and happens to perfectly match all the 
required identifiers, and at that point you've either got someone 
attacking your system who already has sufficient access to do whatever 
the hell they want with it, or you did something exceedingly stupid, and 
both cases are dangerous by themselves.
> 
>> Longer term, there's further patches that will provide a
>> hot-spare functionality, automatically bringing in a device
>> pre-configured as a hot- spare if a device disappears, but
>> that of course requires that btrfs properly recognize devices
>> disappearing and coming back first, so one thing at a time.
> 
> That would be trivial if the complete redesign of block-device
> states of the Btrfs multi-device layer happened, adding an
> "active" flag to an "accessible" flag to describe new member
> states, for example.
No, it wouldn't be trivial, because a complete redesign of part of the 
filesystem would be needed.
> 
> My guess that while logically consistent, the current
> multi-device logic is fundamentally broken from an operational
> point of view, and needs a complete replacement instead of
> fixes.
Then why don't you go write up some patches yourself if you feel so 
strongly about it?

The fact is, the only cases where this is really an issue is if you've 
either got intermittently bad hardware, or are dealing with external 
storage devices.  For the majority of people who are using multi-device 
setups, the common case is internally connected fixed storage devices 
with properly working hardware, and for that use case, it works 
perfectly fine.  In fact, the only people I've seen any reports of 
issues from are either:

1. Testing the behavior of device management (such as the OP), in which 
case, yes it doesn't work if you do things that aren't reasonably 
expected of working hardware.
2. Trying to do multi-device on USB, which is a bad idea regardless of 
what you're using to create a single volume, because USB has pretty 
serious reliability issues.

Neither case is 'normal' usage of a multi-device volume though.  Yes, 
the second case could be better supported, but that's likely going to 
require some help from the block layer, and verification of writes.  As 
far as handling of other marginal hardware, I'm very inclined to say 
that BTRFS should not care.  At the point at which a device is dropping 
off the bus and reappearing with enough regularity for this to be an 
issue, you have absolutely no idea how else it's corrupting your data, 
and support of such a situation is beyond any filesystem (including ZFS).

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:38272 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753629AbdCFN0P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Mar 2017 08:26:15 -0500
Received: by mail-it0-f50.google.com with SMTP id m27so49648846iti.1
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Mar 2017 05:26:14 -0800 (PST)
Subject: Re: raid1 degraded mount still produce single chunks, writeable mount
 not allowed
To: Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
References: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
 <pan$a4f49$5a6ddd0a$2183c48a$5df333ac@cox.net>
 <22712.48434.400550.346157@tree.ty.sabi.co.uk>
 <284e9d01-3e69-705e-dd88-ebe047e2e4b8@gmail.com>
 <22716.25419.146443.191478@tree.ty.sabi.co.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0d731a6d-4677-1d58-9f79-a8d7d2bcac37@gmail.com>
Date: Mon, 6 Mar 2017 08:18:50 -0500
MIME-Version: 1.0
In-Reply-To: <22716.25419.146443.191478@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-03-05 14:13, Peter Grandi wrote:
>>> What makes me think that "unmirrored" 'raid1' profile chunks
>>> are "not a thing" is that it is impossible to remove
>>> explicitly a member device from a 'raid1' profile volume:
>>> first one has to 'convert' to 'single', and then the 'remove'
>>> copies back to the remaining devices the 'single' chunks that
>>> are on the explicitly 'remove'd device. Which to me seems
>>> absurd.
>
>> It is, there should be a way to do this as a single operation.
>> [ ... ] The reason this is currently the case though is a
>> simple one, 'btrfs device delete' is just a special instance
>> of balance [ ... ]  does no profile conversion, but having
>> that as an option would actually be _very_ useful from a data
>> safety perspective.
>
> That seems to me an even more "confused" opinion: because
> removing a device to make it "missing" and removing it
> permanently should be very different operations.
>
> Consider the common case of a 3-member volume with a 'raid1'
> target profile: if the sysadm thinks that a drive should be
> replaced, the goal is to take it out *without* converting every
> chunk to 'single', because with 2-out-of-3 devices half of the
> chunks will still be fully mirrored.
>
> Also, removing the device to be replaced should really not be
> the same thing as balancing the chunks, if there is space, to be
> 'raid1' across remaining drives, because that's a completely
> different operation.
There is a command specifically for replacing devices.  It operates very 
differently from the add+delete or delete+add sequences.  Instead of 
balancing, it's more similar to LVM's pvmove command.  It redirects all 
new writes that would go to the old device to the new one, then copies 
all the data from the old to the new (while properly recreating damaged 
chunks).  it uses way less bandwidth than add+delete, runs faster, and 
is in general much safer because it moves less data around.  If you're 
just replacing devices, you should be using this, not the add and delete 
commands, which are more for reshaping arrays than repairing them.

Additionally, if you _have_ to use add and remove to replace a device, 
if possible, you should add the new device then delete the old one, not 
the other way around, as that avoids most of the issues other than the 
high load on the filesystem from the balance operation.
>
>>> Going further in my speculation, I suspect that at the core of
>>> the Btrfs multidevice design there is a persistent "confusion"
>>> (to use en euphemism) between volumes having a profile, and
>>> merely chunks have a profile.
>
>> There generally is.  The profile is entirely a property of the
>> chunks (each chunk literally has a bit of metadata that says
>> what profile it is), not the volume.  There's some metadata in
>> the volume somewhere that says what profile to use for new
>> chunks of each type (I think),
>
> That's the "target" profile for the volume.
>
>> but that doesn't dictate what chunk profiles there are on the
>> volume. [ ... ]
>
> But as that's the case then the current Btrfs logic for
> determining whether a volume is degraded or not is quite
> "confused" indeed.
Entirely agreed.  Currently, it checks the target profile, when it 
should be checking per-chunk.
>
> Because suppose there is again the simple case of a 3-device
> volume, where all existing chunks have 'raid1' profile and the
> volume's target profile is also 'raid1' and one device has gone
> offline: the volume cannot be said to be "degraded", unless a
> full examination of all chunks is made. Because it can well
> happen that in fact *none* of the chunks was mirrored to that
> device, for example, however unlikely. And viceversa. Even with
> 3 devices some chunks may be temporarily "unmirrored" (even if
> for brief times hopefully).
>
> The average case is that half of the chunks will be fully
> mirrored across the two remaining devices and half will be
> "unmirrored".
>
> Now consider re-adding the third device: at that point the
> volume has got back all 3 devices, so it is not "degraded", but
> 50% of the chunks in the volume will still be "unmirrored", even
> if eventually they will be mirrored on the newly added device.
>
> Note: possibilities get even more interesting with a 4-device
> volume with 'raid1' profile chunks, and similar case involving
> other profiles than 'raid1'.
>
> Therefore the current Btrfs logic for deciding whether a volume
> is "degraded" seems simply "confused" to me, because whether
> there are missing devices and some chunks are "unmirrored" is
> not quite the same thing.
>
> The same applies to the current logic that in a 2-device volume
> with a device missing new chunks are created as "single" profile
> instead of as "unmirrored" 'raid1' profile: another example of
> "confusion" between number of devices and chunk profile.
>
> Note: the best that can be said is that a volume has both a
> "target chunk profile" (one per data, metadata, system chunks)
> and a target number of member devices, and that a volume with a
> number of devices below the target *might* be degraded, and that
> whether a volume is in fact degraded is not either/or, but given
> by the percentage of chunks or stripes that are degraded. This
> is expecially made clear by the 'raid1' case where the chunk
> stripe length is always 2, but the number of target devices can
> be greater than 2. Management of devices and management of
> stripes are in Btrfs, unlike conventional RAID like Linux MD,
> rather different operations needing rather different, if
> related, logic.
>
> My impression is that because of "confusion" between number of
> devices in a volume and status of chunk profile there are some
> "surprising" behaviors in Btrfs, and that will take quite a bit
> to fix, most importantly for the Btrfs developer team to clear
> among themselves the semantics attaching to both. After 10 years
> of development that seems the right thing to do :-).


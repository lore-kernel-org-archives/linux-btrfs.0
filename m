Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:35909 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751160AbdCCNFE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Mar 2017 08:05:04 -0500
Received: by mail-it0-f42.google.com with SMTP id h10so12146450ith.1
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Mar 2017 05:05:03 -0800 (PST)
Subject: Re: raid1 degraded mount still produce single chunks, writeable mount
 not allowed
To: Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
References: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
 <pan$a4f49$5a6ddd0a$2183c48a$5df333ac@cox.net>
 <22712.48434.400550.346157@tree.ty.sabi.co.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <284e9d01-3e69-705e-dd88-ebe047e2e4b8@gmail.com>
Date: Fri, 3 Mar 2017 07:38:36 -0500
MIME-Version: 1.0
In-Reply-To: <22712.48434.400550.346157@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-03-02 19:47, Peter Grandi wrote:
>> [ ... ] Meanwhile, the problem as I understand it is that at
>> the first raid1 degraded writable mount, no single-mode chunks
>> exist, but without the second device, they are created.  [
>> ... ]
>
> That does not make any sense, unless there is a fundamental
> mistake in the design of the 'raid1' profile, which this and
> other situations make me think is a possibility: that the
> category of "mirrored" 'raid1' chunk does not exist in the Btrfs
> chunk manager. That is, a chunk is either 'raid1' if it has a
> mirror, or if has no mirror it must be 'single'.
>
> If a member device of a 'raid1' profile multidevice volume
> disappears there will be "unmirrored" 'raid1' profile chunks and
> some code path must recognize them as such, but the logic of the
> code does not allow their creation. Question: how does the code
> know that a specific 'raid1' chunk is mirrored or not? The chunk
> must have a link (member, offset) to its mirror, do they?
>
> What makes me think that "unmirrored" 'raid1' profile chunks are
> "not a thing" is that it is impossible to remove explicitly a
> member device from a 'raid1' profile volume: first one has to
> 'convert' to 'single', and then  the 'remove' copies back to the
> remaining devices the 'single' chunks that are on the explicitly
> 'remove'd device. Which to me seems absurd.
It is, there should be a way to do this as a single operation.  The 
reason this is currently the case though is a simple one, 'btrfs device 
delete' is just a special instance of balance that prevents new chunks 
being allocated on the device being removed and balances all the chunks 
on that device so they end up on other devices.  It currently does no 
profile conversion, but having that as an option would actually be 
_very_ useful from a data safety perspective.
>
> Going further in my speculation, I suspect that at the core of
> the Btrfs multidevice design there is a persistent "confusion"
> (to use en euphemism) between volumes having a profile, and
> merely chunks have a profile.
There generally is.  The profile is entirely a property of the chunks 
(each chunk literally has a bit of metadata that says what profile it 
is), not the volume.  There's some metadata in the volume somewhere that 
says what profile to use for new chunks of each type (I think), but that 
doesn't dictate what chunk profiles there are on the volume.  This whole 
arrangement is actually pretty important for fault tolerance in general, 
since during a conversion you have _both_ profiles for that chunk type 
at the same time on the same filesystem (new chunks will get allocated 
with the new type though), and the kernel has to be able to handle a 
partially converted FS.
>
> My additional guess that the original design concept had
> multidevice volumes to be merely containers for chunks of
> whichever mixed profiles, so a subvolume could have 'raid1'
> profile metadata and 'raid0' profile data, and another could
> have 'raid10' profile metadata and data, but since handling this
> turned out to be too hard, this was compromised into volumes
> having all metadata chunks to have the same profile and all data
> of the same profile, which requires special-case handling of
> corner cases, like volumes being converted or missing member
> devices.
Actually, the only bits missing that would be needed to do this are 
stuff to segregate the data of given subvolumes completely form each 
other (ie, make sure they can't be in the same chunks at all).  Doing 
that is hard, so we don't have per-subvolume profiles yet.  It's fully 
possible to have a mix of profiles on a given volume though.  Some old 
versions of mkfs actually did this (you'd end up with a small single 
profile chunk of each type on a FS that used different profiles), and 
the filesystem is in exactly that state when converting between profiles 
for a given chunk type.  New chunks will only be generated with one 
profile, but you can have whatever other mix you want essentially (in 
fact, one of the handful of regression tests I run when I'm checking 
patches explicitly creates a filesystem with one data and one system 
chunk of every profile and makes sure the kernel can still access it 
correctly).

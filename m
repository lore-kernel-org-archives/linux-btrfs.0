Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from forward102p.mail.yandex.net ([77.88.28.102]:34722 "EHLO
        forward102p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933376AbeALMeF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Jan 2018 07:34:05 -0500
From: Dark Penguin <darkpenguin@yandex.ru>
Subject: Re: Unexpected raid1 behaviour
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <5A357909.8010206@yandex.ru>
 <5e9df444-0cbc-5854-2058-3435efe78c59@gmail.com>
Message-ID: <5A58A993.8070709@yandex.ru>
Date: Fri, 12 Jan 2018 15:26:59 +0300
MIME-Version: 1.0
In-Reply-To: <5e9df444-0cbc-5854-2058-3435efe78c59@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 18/12/17 16:31, Austin S. Hemmelgarn wrote:
> On 2017-12-16 14:50, Dark Penguin wrote:
>> Could someone please point me towards some read about how btrfs handles
>> multiple devices? Namely, kicking faulty devices and re-adding them.
>>
>> I've been using btrfs on single devices for a while, but now I want to
>> start using it in raid1 mode. I booted into an Ubuntu 17.10 LiveCD and
>> tried to see how does it handle various situations. The experience left
>> me very surprised; I've tried a number of things, all of which produced
>> unexpected results.
> Expounding a bit on Duncan's answer with some more specific info.
>>
>> I create a btrfs raid1 filesystem on two hard drives and mount it.
>>
>> - When I pull one of the drives out (simulating a simple cable failure,
>> which happens pretty often to me), the filesystem sometimes goes
>> read-only. ??? > - But only after a while, and not always. ???
> The filesystem won't go read-only until it hits an I/O error, and it's
> non-deterministic how long it will be before that happens on an idle
> filesystem that only sees read access (because if all the files that are
> being read are in the page cache).
>> - When I fix the cable problem (plug the device back), it's immediately
>> "re-added" back. But I see no replication of the data I've written onto
>> a degraded filesystem... Nothing shows any problems, so "my filesystem
>> must be ok". ???
> One of two things happens in this case, and why there is no re-sync is
> dependent on which happens, but both ultimately have to do with the fact
> that BTRFS assumes I/O errors are from device failures, and are at worst
> transient.  Either:
>
> 1. The device reappears with the same name. This happens if the time it
> was disconnected is less than the kernel's command timeout (30 seconds
> by default).  In this case, BTRFS may not even notice that the device
> was gone (and if it doesn't, then a re-sync isn't necessary, since it
> will retry all the writes it needs to).  In this case, BTRFS assumes the
> I/O errors were temporary, and keeps using the device after logging the
> errors.  If this happens, then you need to manually re-sync things by
> scrubbing the filesystem (or balancing, but scrubbing is preferred as it
> should run quicker and will only re-write what is actually needed).
> 2. The device reappears with a different name.  In this case, the device
> was gone long enough that the block layer is certain it was
> disconnected, and thus when it reappears and BTRFS still holds open
> references to the old device node, it gets a new device node.  In this
> case, if the 'new' device is scanned, BTRFS will recognize it as part of
> the FS, but will keep using the old device node.  The correct fix here
> is to unmount the filesystem, re-scan all devices, and then remount the
> filesystem and manually re-sync with a scrub.
>
>> - If I unmount the filesystem and then mount it back, I see all my
>> recent changes lost (everything I wrote during the "degraded" period).
> I'm not quite sure about this, but I think BTRFS is rolling back to the
> last common generation number for some reason.
>
>> - If I continue working with a degraded raid1 filesystem (even without
>> damaging it further by re-adding the faulty device), after a while it
>> won't mount at all, even with "-o degraded".
> This is (probably) a known bug relating to chunk handling.  In a two
> device volume using a raid1 profile with a missing device, older kernels
> (I don't remember when the fix went in, but I could have sworn it was in
> 4.13) will (erroneously) generate single-profile chunks when they need
> to allocate new chunks.  When you then go to mount the filesystem, the
> check for the degraded mount-ability of the FS fails because there is a
> device missing and single profile chunks.
>
> Now, even without that bug, it's never a good idea t0o run a storage
> array degraded for any extended period of time, regardless of what type
> of array it is (BTRFS, ZFS, MD, LVM, or even hardware RAID).  By keeping
> it in 'degraded' mode, you're essentially telling the system that the
> array will be fixed in a reasonably short time-frame, which impacts how
> it handles the array.  If you're not going to fix it almost immediately,
> you should almost always reshape the array to account for the missing
> device if at all possible, as that will improve relative data safety and
> generally get you better performance than running degraded will.
>>
>> I can't wrap my head about all this. Either the kicked device should not
>> be re-added, or it should be re-added "properly", or it should at least
>> show some errors and not pretend nothing happened, right?..
> BTRFS is not the best at error reporting at the moment.  If you check
> the output of `btrfs device stats` for that filesystem though, it should
> show non-zero values in the error counters (note that these counters are
> cumulative, so they are counts since the last time they were reset (or
> when the FS was created if they have never been reset).  Similarly,
> scrub should report errors, there should be error messages in the kernel
> log, and switching the FS to read-only mode _is_ technically reporting
> an error, as that's standard error behavior for most sensible
> filesystems (ext[234] being the notable exception, they just continue as
> if nothing happened).
>>
>> I must be missing something. Is there an explanation somewhere about
>> what's really going on during those situations? Also, do I understand
>> correctly that upon detecting a faulty device (a write error), nothing
>> is done about it except logging an error into the 'btrfs device stats'
>> report? No device kicking, no notification?.. And what about degraded
>> filesystems - is it absolutely forbidden to work with them without
>> converting them to a "single" filesystem first?..
> As mentioned above, going read-only _is_ a notification that something
> is wrong.  Translating that (and the error counter increase, and the
> kernel log messages) into a user visible notification is not really the
> job of BTRFS, especially considering that no other filesystem or device
> manager does so either (yes, you can get nice notifications from LVM,
> but they aren't _from_ LVM itself, they're from other software that
> watches for errors, and the same type of software works just fine for
> BTRFS too).  If you're this worried about it and don't want to keep on
> top of it yourself by monitoring things manually, you really need to
> look into a tool like monit [1] that can handle this for you.
>
>
> [1] https://mmonit.com/monit/


Thank you! That was a really detailed explanation!

I was using MD for a long time, so I was expecting kind of the same
behaviour - like refusing to add the failed device back without
resyncing, kicking faulty devices from the array, sending email
warnings, being able to use the array in degraded mode with no problems
(in case of RAID1) and so on. But I guess a few things are different in
the btrfs mindset. It behaves more like a filesystem, so it doesn't
force you to ensure data integrity; noticing errors and fixing them is
up to you, like with any normal filesystem.

The test I did was a "try to break btrfs and see if it survives" test,
which mdadm would have passed (probably), but now I understand that
btrfs was not made for that. However, with some error-reporting tools,
it's probably possible to make it reasonably reliable.


-- 
darkpenguin

-- 
darkpenguin

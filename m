Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:33509 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbcAVMLH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jan 2016 07:11:07 -0500
Received: by mail-lf0-f47.google.com with SMTP id m198so45752035lfm.0
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 04:11:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$a0430$c59023ae$8ef223cd$7c2025cc@cox.net>
References: <CAHRikPEe9JVRmBysLQ8r1OhwXsSpfJOXy4EWU8m=egbkt9zE7w@mail.gmail.com>
	<CAJCQCtSyc1YAsVgNcPCeA5fW8cofwqSVuF69acZo+GYm2rUx4A@mail.gmail.com>
	<pan$a0430$c59023ae$8ef223cd$7c2025cc@cox.net>
Date: Fri, 22 Jan 2016 06:11:04 -0600
Message-ID: <CAHRikPGM_oLC1uDFged7QE+GVVab7GRVp=38pxABx7qxtfLKWQ@mail.gmail.com>
Subject: Re: Out of space on small-ish partition, clobber and other methods
 haven't worked
From: Jerry Steinhauer <jerry.steinhauer@singlewire.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks, Duncan for the thorough and thoughtful reply.  We appreciate
that btrfs is stabilizing (emphasis understood).  In our case, we
think the benefits for cow for running on compact flash will outweigh
the potential for a btrfs-specific hiccup.  In this particular case,
these systems do not contain unique data.  The background you give
strengthens our resolve to have in place contingency plans in case of
a hiccup.

We've moved to 4.1 in our production release, and before asking people
here for support in future, we'll try our symptom against the latest
kernel rev available.

 - Jerry




On Thu, Jan 21, 2016 at 4:41 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Chris Murphy posted on Wed, 20 Jan 2016 19:28:35 -0700 as excerpted:
>
>> On Wed, Jan 20, 2016 at 2:22 PM, Jerry Steinhauer
>> <jerry.steinhauer@singlewire.com> wrote:
>>
>>> % rm a.file
>>> rm: cannot remove 'a.file': No space left on device
>>> % cat /dev/null > a.file
>>> -sh: a.file: No space left on device
>
>>> % btrfs fi df /data
>>> System, single: total=32.00MiB, used=4.00KiB
>>> Data+Metadata, single: total=506.00MiB, used=500.39MiB
>>> GlobalReserve, single: total=12.00MiB, used=6.45MiB
>>
>>
>> I see somewhere between 6MiB and 12MiB that should be available for file
>> removal.
>
> I don't.  See that global reserve?  6.45 MiB into its emergency reserve,
> so effectively -6.45 MiB of space available for file removal.
>
> First of all, any time global reserve is used at all the filesystem is in
> very dire straits, and he's 6.45 MiB into the 12.00 MiB global reserve,
> so that alone tells us "we're not in Kansas any more!" =8^0
>
> Second, the btrfs fi show (which you didn't quote) says 540 MiB capacity.
>
> System           32 MiB total, can't be used for anything else
> Data+Metadata   506 MiB total, shared data/metadata as it's a small
> filesystem  (See why I didn't list global reserve here, below.)
>
>
> Total           538 MiB chunked out.  While that's 2 MiB from the
> reported 540 capacity, I don't believe system includes the reserved space
> (for boot loader, etc) at the beginning of the partition.  Between that
> and the limits of the chunk-allocator, he's likely all chunked-out, no
> possibility of allocating further chunks.
>
> Global reserve is normally reserved from metadata, which of course is
> shared data/metadata here, due to the size of the filesystem (which makes
> shared a practical necessity, the problems would be much worse if data
> and metadata chunks were separate!).
>
> So of the 506 MiB in data/metadata, 12 MiB are global reserve.  Which
> means there's only 494 MiB of normal data/metadata space, plus 12 MiB of
> global reserve.
>
> But the DF shows 500.39 MiB of data/metadata used, which means we're
> roughly 6.4 MiB past normal data/metadata usage into the emergency use
> only global reserve, which is indeed (roughly) what global reserve shows,
> 6.45 MiB used.
>
> So as I said, that btrfs is in pretty severely dire straits!  Not only is
> all the available data/metadata space used, but we're well past half way
> into the emergency global reserve as well.  No WONDER there's no space
> left even to delete a file (which because btrfs is COW, copy-on-write,
> requires metadata space even to delete a file, as the metadata block
> containing the original data cannot be rewritten in place and must be
> written elsewhere... thus answering the question of why btrfs needs space
> even on the unlink).
>
>
> As for solutions, there's still a couple things (plus one already tried)
> to try to get out of the situation:
>
> 0) Try clobbering the file, reducing it to zero size, but you did and
> that didn't work.  It might have if the btrfs wasn't already so far into
> global reserve.
>
> 1) As CMurphy says (with two Chris Ms on the list that isn't clear, so
> CMurphy it is), try a later kernel, either 4.1.x or 4.4.  AFAIK there
> were a few patches having to do with ENOSPC errors and allowing file
> deletes to take from global reserve, as the result should be more room
> afterward and that's exactly the sort of thing global reserve is supposed
> to be there for.  Tho it's just a try, no guarantees.
>
> 2) This could be difficult on embedded, but the other option is
> temporarily adding a second device (btrfs device add), to give the
> filesystem a bit of work with.  That takes space as well, but luckily, I
> believe it's system-chunk space, and there's plenty of room there, so it
> should be possible.
>
> The idea is to get enough metadata space to work with to get out of the
> fix by deleting a file or the like (normally, a balance could help as
> well, but that primarily helps to reclaim empty chunks from say data, so
> they can be reassigned to metadata, and since this is shared data/
> metadata, that's unlikely to help).
>
> Then when the filesystem is back to usable and enough has been deleted so
> what's on the temporary second device will fit back on the first device
> again, btrfs device delete the second one.
>
> I'm unfamiliar with how small an added device can be and still be useful
> at that level, or more precisely, how the system chunk shrinks with total
> device size, but the one small data point I have here is a 256 MiB /boot,
> which has a 16 MiB system chunk, so I'm guessing it should shrink at
> least that far.
>
> So let's say 16 MiB system, and it's into global reserve by ~6.5 MiB, so
> we want to give it at least that much more, plus something to work with.
>
> So I'd suggest a 24 MiB or if it's available, 32 MiB, second device, at
> minimum.  Smaller can be tried, with the hope that the system chunk
> shrinks to say 8 MiB or smaller if the device is small enough, but I'm
> not sure it will.
>
> As for actually making available a device on embedded, if there's no USB
> port available and thus the "simple" solution of plugging in a thumb
> drive is out of the question... maybe there's enough memory to create a
> tmpfs and do a loopback file on it, then add that loopback file as the
> temporary second device.  Of course if the power dies or the system
> otherwise crashes when part of the filesystem's on that tmpfs... not good
> news.  And obviously in that case it /better/ be temporary, because you
> can't reboot without losing that tmpfs and with it the loopback.  But if
> there's no other way to get access to a suitable device and the system
> and power is stable enough...
>
>
> So that answers the what to do to exit that state question, and in a
> parenthetical  I answered the question of why it's requiring space to
> unlink -- btrfs is cow, copy-on-write, so even unlinking a file requires
> space to copy the metadata block containing the information about that
> file for the write.  And it makes the third question moot, as we have the
> root cause already -- the cow nature of btrfs.
>
>
> Meanwhile, one more thing to address.  Despite what various distros may
> claim, here on this list, btrfs is considered "stablizING, but not yet
> fully stable or mature."  Production usage, particularly without backups,
> isn't recommended, occasional bugs can be expected, and the standard
> recommendation is using no older than the last two of either current
> kernels or LTS kernels.   With the just released 4.4 being an LTS kernel,
> that makes 4.1 the previous one back and the oldest recommended kernel,
> tho with 4.4 being so new, still being on the LTS before that, 3.18,
> would still be somewhat acceptable if you're already working on updating
> to 4.1.  But before that, while we'll try to support as best we can,
> chances are very good among the first requests is going to be to update
> to something not so ancient.
>
> Under those conditions, honestly, it may be that btrfs isn't yet stable
> enough to be the right choice, particularly for embedded projects that
> are supposed to be field-usable without backups and without available
> technical maintenance for some years.  As I said, we're stabilizing, and
> actually, I'm not sure about the devs (I'm a list regular and btrfs user,
> not a dev) and other list regulars, but it may be that with LTS 4.4 we'll
> extend the informal support scope to three LTS series and thus support
> 3.18 awhile longer, but btrfs is definitely not where /I'd/ recommend
> using btrfs on designed to be field usable without ready backups or
> direct tech supervision embedded, just yet.
>
> OTOH, if it's embedded but with backups and direct tech supervision, then
> btrfs may be just fine, if you're willing to put up with the occasional
> bug and accept that you must be prepared to actually have to use those
> backups, should one of those occasional bugs require it, and if keeping
> generally to the last two LTS (or current) kernel series is acceptable.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:33611 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbcAKWRD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 17:17:03 -0500
Received: by mail-yk0-f181.google.com with SMTP id k129so425397723yke.0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jan 2016 14:17:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$c865f$a56b47b9$50596374$de688f5d@cox.net>
References: <CAHJqNbyXUfzscHteqrQtxJdYKToDNv7_Hw9tVpPuNJYwe=NHxw@mail.gmail.com>
	<CAJCQCtS2ePxA44YCUS=Q7xS1sWszPmzDe13idDVvxwpeqHD05A@mail.gmail.com>
	<pan$c865f$a56b47b9$50596374$de688f5d@cox.net>
Date: Mon, 11 Jan 2016 23:17:01 +0100
Message-ID: <CAHJqNbwTnm-pKyrXQXON+VgT+Yw=LiCJwpTHT-Z2Wq6B1dHduw@mail.gmail.com>
Subject: Re: Purposely using btrfs RAID1 in degraded mode ?
From: Alphazo <alphazo@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Duncan,

Awesome!  Thanks for taking the time to go over the details. This was
a very informative reading.

Alphazo

On Sat, Jan 9, 2016 at 11:08 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Chris Murphy posted on Mon, 04 Jan 2016 10:41:09 -0700 as excerpted:
>
>> On Mon, Jan 4, 2016 at 10:00 AM, Alphazo <alphazo@gmail.com> wrote:
>>
>>> I have tested the above use case with a couple of USB flash drive and
>>> even used btrfs over dm-crypt partitions and it seemed to work fine but
>>> I wanted to get some advices from the community if this is really a bad
>>> practice that should not be used on the long run. Is there any
>>> limitation/risk to read/write to/from a degraded filesystem knowing it
>>> will be re-synced later?
>>
>> As long as you realize you're testing a sort of edge case, but an
>> important one (it should work, that's the point of rw degraded mounts
>> being possible), then I think it's fine.
>>
>> The warning though is, you need to designate a specific drive for the
>> rw,degraded mounts. If you were to separately rw,degraded mount the two
>> drives, the fs will become irreparably corrupt if they are rejoined. And
>> you'll probably lose everything on the volume. The other thing is that
>> to "resync" you have to manually initiate a scrub, it's not going to
>> resync automatically, and it has to read everything on both drives to
>> compare and fix what's missing. There is no equivalent to a write intent
>> bitmap on Btrfs like with mdadm (the information ostensibly could be
>> inferred from btrfs generation metadata similar to how incremental
>> snapshot send/receive works) but that work isn't done.
>
> In addition to what CMurphy says above (which I see you/Alphazo acked),
> be aware that btrfs' chunk-writing behavior isn't particularly well
> suited to this sort of split-raid1 application.
>
> In general, btrfs allocates space in two steps.  First, it allocates
> rather large "chunks" of space, data chunks separately from metadata
> (unless you use --mixed mode, when you first setup the filesystem with
> mkfs.btrfs, then data and metadata are mixed together in the same
> chunks).  Data chunks are typically 1 GiB in size except on filesystems
> over 100 GiB (where they're larger), while metadata chunks are typically
> 256 MiB (as are mixed-mode chunks).
>
> Then btrfs uses space from these chunks until they get full, at which
> point it will attempt to allocate more chunks.
>
> Older btrfs (before kernel 3.17, IIRC) could allocate chunks, but didn't
> know how to deallocate chunks when empty, so a common problem back then
> was that over time, all free space would be allocated to empty data
> chunks, and people would run into ENOSPC errors when metadata chunks ran
> out of space, but more couldn't be created because all the empty space
> was in data chunks.
>
> Newer btrfs automatically reclaims empty chunks, so this doesn't happen
> so often.
>
> But here comes the problem for the use-case you've described.  Btrfs
> can't allocate raid1 chunks if there's only a single device, because
> raid1 requires two devices.
>
> So what's likely to happen is that at some point, you'll be away from
> home and the existing raid1 chunks, either data or metadata, will fill
> up, and btrfs will try to allocate more.  But you'll be running in
> degraded mode with only a single device, and it wouldn't be able to
> allocate raid1 chunks with just that single device.
>
> Oops!  Big problem!
>
> Now until very recently (I believe thru current 4.3), what would happen
> in this case is that btrfs would find that it couldn't create a new chunk
> in raid1 mode, and if operating degraded, would then fall back to
> creating it in single mode.  Which lets you continue writing, so all is
> well.  Except... once you unmounted and attempted to mount the device
> again, still degraded, it would see the single-mode chunks on a
> filesystem that was supposed to have two devices, and would refuse to
> mount degraded,rw again.  You could only mount degraded,ro.  Of course in
> your use-case, you could still wait until you got home and mount
> undegraded again, which would allow you to mount writable.
>
> But a scrub wouldn't sync the single chunks.  For that, after the scrub,
> you'd need to run a filtered balance-convert, to convert the single
> chunks back to raid1.  Something like this (one command):
>
> btrfs balance start -dprofile=single,convert=raid1
> -mprofile=single,convert=raid1
>
> There are very new patches that should solve the problem of not being
> able to mount degraded,rw after single mode chunks are found, provided
> all those single mode chunks actually exist on the found device(s).  I
> think but I'm not sure, that they're in 4.4.  That would give you more
> flexibility in terms of mounting degraded,rw after single chunks have
> been created on the device you have with you, but you'd still need to run
> both a scrub, to sync the raid1 chunks, and a balance, to convert the
> single chunks to raid1 and sync them, once you had both devices connected.
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

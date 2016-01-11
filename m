Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:33162 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457AbcAKQeT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 11:34:19 -0500
Received: by mail-wm0-f43.google.com with SMTP id f206so220140357wmf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jan 2016 08:34:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+9GZUizsH3ToTMf_7mfN1Xgv=5obrCxCRHY+APS4SSGKoWHVA@mail.gmail.com>
References: <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com>
 <CA+9GZUgnmMoLeGsyeo=tFe2GLsDkLEr0umiDovf3P2aBtDA+Xg@mail.gmail.com>
 <CA+9GZUjRWNVShW=6jfCVDTjRdQQCS9T_-cMkOF3s8846uAhn+w@mail.gmail.com>
 <CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
 <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
 <CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com>
 <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
 <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
 <20160109202659.GC6060@carfax.org.uk> <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
 <20160109210429.GD6060@carfax.org.uk> <CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com>
 <5693A8B3.2090508@gmail.com> <CA+9GZUjj8a=drg7--p-f02+QXLo7aWMyZd3O8TA9gTyGWb3MLA@mail.gmail.com>
 <5693B7C0.8010903@gmail.com> <CA+9GZUizsH3ToTMf_7mfN1Xgv=5obrCxCRHY+APS4SSGKoWHVA@mail.gmail.com>
From: "cheater00 ." <cheater00@gmail.com>
Date: Mon, 11 Jan 2016 17:33:58 +0100
Message-ID: <CA+9GZUj92Y2qvgXjQbnavzrc4kM4n_0mBt+yu4CEFjzZJ2+kcQ@mail.gmail.com>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After unmounting:
[251818.992992] BTRFS error (device sdc1): cleaner transaction attach
returned -30

and remounting:
[251837.393750] BTRFS info (device sdc1): disk space caching is enabled

the disk again resizes Data.

On Mon, Jan 11, 2016 at 5:02 PM, cheater00 . <cheater00@gmail.com> wrote:
> I triggered the bug again, attaching log. There were some usb resets,
> but they happened 23 minutes before the fs crashed.
>
> At mount, the output of btrfs fi df -g was like this:
> Data, single: total=2080.01GiB, used=2078.80GiB
> System, DUP: total=0.01GiB, used=0.00GiB
> System, single: total=0.00GiB, used=0.00GiB
> Metadata, DUP: total=5.50GiB, used=3.73GiB
> Metadata, single: total=0.01GiB, used=0.00GiB
> GlobalReserve, single: total=0.50GiB, used=0.00GiB
>
> Now it is:
> Data, single: total=2094.01GiB, used=2092.26GiB
> System, DUP: total=0.01GiB, used=0.00GiB
> System, single: total=0.00GiB, used=0.00GiB
> Metadata, DUP: total=5.50GiB, used=3.79GiB
> Metadata, single: total=0.01GiB, used=0.00GiB
> GlobalReserve, single: total=0.50GiB, used=0.00GiB
>
> The file being copied at the time was 954 MB.
>
>
>
> On Mon, Jan 11, 2016 at 3:10 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2016-01-11 08:11, cheater00 . wrote:
>>>
>>> On Mon, Jan 11, 2016 at 2:05 PM, Austin S. Hemmelgarn
>>> <ahferroin7@gmail.com> wrote:
>>>>
>>>> On 2016-01-09 16:07, cheater00 . wrote:
>>>>>
>>>>>
>>>>> Would like to point out that this can cause data loss. If I'm writing
>>>>> to disk and the disk becomes unexpectedly read only - that data will
>>>>> be lost, because who in their right mind makes their code expect this
>>>>> and builds a contingency (e.g. caching, backpressure, etc)...
>>>>
>>>>
>>>> If a data critical application (mail server, database server, anything
>>>> similar) can't gracefully handle ENOSPC, then that application is broken,
>>>> not the FS.  As an example, set up a small VM with an SMTP server, then
>>>> force the FS the server uses for queuing mail read-only, and see if you
>>>> can
>>>> submit mail, then go read the RFCs for SMTP and see what clients are
>>>> supposed to do when they can't submit mail.  A properly designed piece of
>>>> software is supposed to be resilient against common failure modes of the
>>>> resources it depends on (which includes ENOSPC and read-only filesystems
>>>> for
>>>> anything that works with data on disk).
>>>>>
>>>>>
>>>>>
>>>>> There's no loss of data on the disk because the data doesn't make it
>>>>> to disk in the first place. But it's exactly the same as if the data
>>>>> had been written to disk, and then lost.
>>>>>
>>>> No, it isn't.  If you absolutely need the data on disk, you should be
>>>> calling fsync or fdatasync, and then assuming if those return an error
>>>> that
>>>> none of the data written since the last call has gotten to the disk (some
>>>> of
>>>> it might have, but you need to assume it hasn't).  Every piece of
>>>> software
>>>> in wide usage that requires data to be on the disk does this, because
>>>> otherwise it can't guarantee that the data is on disk.
>>>
>>>
>>> I agree that a lot of stuff goes right in a perfect world. But most of
>>> the time what you're running isn't a mail server used by billions of
>>> users, but instead a bash script someone wrote once that's supposed to
>>> do something, and no one knows how it works.
>>>
>> And that's why no sane person does stuff like that on enterprise level
>> systems.  And even then, if the person writing the bash script actually
>> knows what they're doing, they will be using the 'sync' command to ensure
>> data integrity when they actually need it, or they will write their script
>> in such a way that it gracefully handles a partial run.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37871 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042AbcAKNqP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 08:46:15 -0500
Received: by mail-wm0-f45.google.com with SMTP id f206so269245754wmf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jan 2016 05:46:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+9GZUg-6WrQTgCw_AmVb2qqr4aL4xeWH6mSq1zQ14qbxextzA@mail.gmail.com>
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
 <CA+9GZUg-6WrQTgCw_AmVb2qqr4aL4xeWH6mSq1zQ14qbxextzA@mail.gmail.com>
From: "cheater00 ." <cheater00@gmail.com>
Date: Mon, 11 Jan 2016 14:45:54 +0100
Message-ID: <CA+9GZUgb=h9_t5fXH-qP_-MwKkoN4xLhhYNnCthccA114+KaeQ@mail.gmail.com>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After remounting, the bug doesn't transpire any more, Data gets resized.

It is my experience that this bug will go untriggered for weeks at a
time until I write a lot to that disk there, at which point it'll
happen very quickly. I believe this has more to do with the amount of
data that's been written to disk than anything else. It has been about
48 GB to trigger the last instance and I don't think that's very
different from what happened before but I didn't keep track exactly.

On Mon, Jan 11, 2016 at 2:30 PM, cheater00 . <cheater00@gmail.com> wrote:
> The bug just happened again. Attached is a log since the time I
> mounted the FS right after the fsck.
>
> Note the only things between the message I got while mounting:
> [216798.144518] BTRFS info (device sdc1): disk space caching is enabled
>
> and the beginning of the crash dump:
> [241534.760651] ------------[ cut here ]------------
>
> is this:
> [218266.098344] usb 4-1.1: reset high-speed USB device number 3 using ehci-pci
> [233647.332085] usb 4-1.1: reset high-speed USB device number 3 using ehci-pci
>
> I am not sure why those resets happen, though. I bought a few cables
> and experimented with them, and the usb ports themselves are located
> directly on the motherboard.
> Also, they happened some considerable time before the crash dump. So
> I'm not sure they're even related. Especially given that I was copying
> a lot of very small files, and they all copied onto the disk fine all
> the time between the last usb reset and the crash dump, which is
> roughly two and a half hours. In fact I pressed ctrl-z on a move
> operation and then wrote something like sleep $(echo '60*60*3' | bc) ;
> fg and ran it just past 9 am, so the mv resumed past 12 pm, so as
> things add up the last usb reset happened even before the mv was
> resumed with fg.
>
> I unmounted the fs and re-mounted the it to make it writeable again.
> This showed up in dmesg:
>
> [241766.485365] BTRFS error (device sdc1): cleaner transaction attach
> returned -30
> [241770.115897] BTRFS info (device sdc1): disk space caching is enabled
>
> this time there was no "info" line about the free space cache file. So
> maybe it wasn't important for the bug to occur at all.
>
> The new output of btrfs fi df -g is:
> Data, single: total=2080.01GiB, used=2078.80GiB
> System, DUP: total=0.01GiB, used=0.00GiB
> System, single: total=0.00GiB, used=0.00GiB
> Metadata, DUP: total=5.50GiB, used=3.73GiB
> Metadata, single: total=0.01GiB, used=0.00GiB
> GlobalReserve, single: total=0.50GiB, used=0.00GiB
>
> I could swap this disk onto sata and the other disk back onto usb to
> see if the usb resets have anything to do with this. But I'm skeptic.
> Also maybe btrfs has some other issues related to just the disk being
> on usb, resets or not, and this way if the bug doesn't trigger on sata
> we'll think "aha it was the resets, buggy hardware etc" but instead
> it'll have been something else that just has to do with the disk being
> on usb operating normally.
>
> On Mon, Jan 11, 2016 at 2:11 PM, cheater00 . <cheater00@gmail.com> wrote:
>> On Mon, Jan 11, 2016 at 2:05 PM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>> On 2016-01-09 16:07, cheater00 . wrote:
>>>>
>>>> Would like to point out that this can cause data loss. If I'm writing
>>>> to disk and the disk becomes unexpectedly read only - that data will
>>>> be lost, because who in their right mind makes their code expect this
>>>> and builds a contingency (e.g. caching, backpressure, etc)...
>>>
>>> If a data critical application (mail server, database server, anything
>>> similar) can't gracefully handle ENOSPC, then that application is broken,
>>> not the FS.  As an example, set up a small VM with an SMTP server, then
>>> force the FS the server uses for queuing mail read-only, and see if you can
>>> submit mail, then go read the RFCs for SMTP and see what clients are
>>> supposed to do when they can't submit mail.  A properly designed piece of
>>> software is supposed to be resilient against common failure modes of the
>>> resources it depends on (which includes ENOSPC and read-only filesystems for
>>> anything that works with data on disk).
>>>>
>>>>
>>>> There's no loss of data on the disk because the data doesn't make it
>>>> to disk in the first place. But it's exactly the same as if the data
>>>> had been written to disk, and then lost.
>>>>
>>> No, it isn't.  If you absolutely need the data on disk, you should be
>>> calling fsync or fdatasync, and then assuming if those return an error that
>>> none of the data written since the last call has gotten to the disk (some of
>>> it might have, but you need to assume it hasn't).  Every piece of software
>>> in wide usage that requires data to be on the disk does this, because
>>> otherwise it can't guarantee that the data is on disk.
>>
>> I agree that a lot of stuff goes right in a perfect world. But most of
>> the time what you're running isn't a mail server used by billions of
>> users, but instead a bash script someone wrote once that's supposed to
>> do something, and no one knows how it works.

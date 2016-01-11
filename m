Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:36725 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932636AbcAKU3i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 15:29:38 -0500
Received: by mail-lf0-f42.google.com with SMTP id h129so25772154lfh.3
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jan 2016 12:29:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+9GZUj92Y2qvgXjQbnavzrc4kM4n_0mBt+yu4CEFjzZJ2+kcQ@mail.gmail.com>
References: <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com>
	<CA+9GZUgnmMoLeGsyeo=tFe2GLsDkLEr0umiDovf3P2aBtDA+Xg@mail.gmail.com>
	<CA+9GZUjRWNVShW=6jfCVDTjRdQQCS9T_-cMkOF3s8846uAhn+w@mail.gmail.com>
	<CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
	<CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
	<CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com>
	<CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
	<CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
	<20160109202659.GC6060@carfax.org.uk>
	<CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
	<20160109210429.GD6060@carfax.org.uk>
	<CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com>
	<5693A8B3.2090508@gmail.com>
	<CA+9GZUjj8a=drg7--p-f02+QXLo7aWMyZd3O8TA9gTyGWb3MLA@mail.gmail.com>
	<5693B7C0.8010903@gmail.com>
	<CA+9GZUizsH3ToTMf_7mfN1Xgv=5obrCxCRHY+APS4SSGKoWHVA@mail.gmail.com>
	<CA+9GZUj92Y2qvgXjQbnavzrc4kM4n_0mBt+yu4CEFjzZJ2+kcQ@mail.gmail.com>
Date: Mon, 11 Jan 2016 21:29:37 +0100
Message-ID: <CAPmG0jYGRzvTWjSV09R7PswL6nqZVc7dhgXTQarej3JNeh0Q5g@mail.gmail.com>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
From: Henk Slager <eye1tm@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 11, 2016 at 5:33 PM, cheater00 . <cheater00@gmail.com> wrote:
> After unmounting:
> [251818.992992] BTRFS error (device sdc1): cleaner transaction attach
> returned -30
>
> and remounting:
> [251837.393750] BTRFS info (device sdc1): disk space caching is enabled
>
> the disk again resizes Data.
>
> On Mon, Jan 11, 2016 at 5:02 PM, cheater00 . <cheater00@gmail.com> wrote:
>> I triggered the bug again, attaching log. There were some usb resets,
>> but they happened 23 minutes before the fs crashed.
>>
>> At mount, the output of btrfs fi df -g was like this:
>> Data, single: total=2080.01GiB, used=2078.80GiB
>> System, DUP: total=0.01GiB, used=0.00GiB
>> System, single: total=0.00GiB, used=0.00GiB
>> Metadata, DUP: total=5.50GiB, used=3.73GiB
>> Metadata, single: total=0.01GiB, used=0.00GiB
>> GlobalReserve, single: total=0.50GiB, used=0.00GiB
>>
>> Now it is:
>> Data, single: total=2094.01GiB, used=2092.26GiB
>> System, DUP: total=0.01GiB, used=0.00GiB
>> System, single: total=0.00GiB, used=0.00GiB
>> Metadata, DUP: total=5.50GiB, used=3.79GiB
>> Metadata, single: total=0.01GiB, used=0.00GiB
>> GlobalReserve, single: total=0.50GiB, used=0.00GiB

The Data increments with 1G (or 10G?) chunks if there is no
well-fitting space in existing chunks.

>> The file being copied at the time was 954 MB.

The space cache faults get repaired automatically, that is not an
issue. Also your fs gives no errors when doing a check.
The sort of files you write is nothing difficult for btrfs, even not
over a stable usb2 connection. I am writing/incrementing files of
~50G, also C-sources etc over an old usb2 link since 2 years Also
balancing many hours over this link. I have not seen resets however
(grepped /var/log/messages). The usb2 link is an 2T usb3 disk plugged
into an usb2 port. In usb3 port it isn't even recognised. I also have
a usb3 3.5 inch dock that produces resets with a 4T harddisk since
kernel 4.x (was 4.1.x or so, it was a dd full disk copy). Also if you
have too many ATA resets caused by whatever or short disconnects,
btrfs might get in trouble; it can't handle bad disks/IO very well
currently.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:37780 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751797AbdLSMZy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 07:25:54 -0500
Received: by mail-it0-f53.google.com with SMTP id d137so2581193itc.2
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 04:25:54 -0800 (PST)
Subject: Re: Unexpected raid1 behaviour
To: Tomasz Pala <gotar@polanet.pl>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
Date: Tue, 19 Dec 2017 07:25:49 -0500
MIME-Version: 1.0
In-Reply-To: <20171218194351.GA25245@polanet.pl>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-12-18 14:43, Tomasz Pala wrote:
> On Mon, Dec 18, 2017 at 08:06:57 -0500, Austin S. Hemmelgarn wrote:
> 
>> The fact is, the only cases where this is really an issue is if you've
>> either got intermittently bad hardware, or are dealing with external
> 
> Well, the RAID1+ is all about the failing hardware.
About catastrophically failing hardware, not intermittent failure.
> 
>> storage devices.  For the majority of people who are using multi-device
>> setups, the common case is internally connected fixed storage devices
>> with properly working hardware, and for that use case, it works
>> perfectly fine.
> 
> If you're talking about "RAID"-0 or storage pools (volume management)
> that is true.
> But if you imply, that RAID1+ "works perfectly fine as long as hardware
> works fine" this is fundamentally wrong. If the hardware needs to work
> properly for the RAID to work properly, noone would need this RAID in
> the first place.
I never said the hardware needed to not fail, just that it needed to 
fail in a consistent manner.  BTRFS handles catastrophic failures of 
storage devices just fine right now.  It has issues with intermittent 
failures, but so does hardware RAID, and so do MD and LVM to a lesser 
degree.
> 
>> that BTRFS should not care.  At the point at which a device is dropping
>> off the bus and reappearing with enough regularity for this to be an
>> issue, you have absolutely no idea how else it's corrupting your data,
>> and support of such a situation is beyond any filesystem (including ZFS).
> 
> Support for such situation is exactly what RAID performs. So don't blame
> people for expecting this to be handled as long as you call the
> filesystem feature a 'RAID'.
No, classical RAID (other than RAID0) is supposed to handle catastrophic 
failure of component devices.  That is the entirety of the original 
design purpose, and that is the entirety of what you should be using it 
for in production.  The point at which you are getting random corruption 
on a disk and you're using anything but BTRFS for replication, you 
_NEED_ to replace that disk, and if you don't you risk it causing 
corruption on the other disk.  As of right now, BTRFS is no different in 
that respect, but I agree that it _should_ be able to handle such a 
situation eventually.
> 
> If this feature is not going to mitigate hardware hiccups by design (as
> opposed to "not implemented yet, needs some time", which is perfectly
> understandable), just don't call it 'RAID'.
It shouldn't have been called RAID in the first place, that we can agree 
on (even if for different reasons).
> 
> All the features currently working, like bit-rot mitigation for
> duplicated data (dup/raid*) using checksums, are something different
> than RAID itself. RAID means "survive failure of N devices/controllers"
> - I got one "RAID1" stuck in r/o after degraded mount, not nice... Not
> _expected_ to happen after single disk failure (without any reappearing).
And that's a known bug on older kernels (not to mention that you should 
not be mounting writable and degraded for any purpose other than fixing 
the volume).

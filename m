Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:34075 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932215AbeE0F6I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 May 2018 01:58:08 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fMoep-0006KR-Ml
        for linux-btrfs@vger.kernel.org; Sun, 27 May 2018 07:55:55 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID-1 refuses to balance large drive
Date: Sun, 27 May 2018 05:55:49 +0000 (UTC)
Message-ID: <pan$33fea$4513a1e$b0b44d88$dcd9097e@cox.net>
References: <56F1E7BE.1000004@gmail.com> <56F22F80.501@gmail.com>
        <CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
        <56F2C991.9080500@gmail.com>
        <CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
        <56F2EA25.4070004@gmail.com>
        <CAJCQCtQ7YwtBcvq9H1e1Ma8WEKB4o2ni40yOE9f1KMr0u6rX_w@mail.gmail.com>
        <CAA7pwKNjyRRoXGV0djzjgXX7HQ2MY8mhQFj8_7TsfYeKkge-2g@mail.gmail.com>
        <CAPmG0jbUWiDNSVjv9hMF3rpe0cm4EZWkuRKEgM_t6EuU3sPYFA@mail.gmail.com>
        <CAHz9+Emc4DsXoMLKYrp1TfN+2r2cXxaJmPyTnpeCZF=h0FhtMg@mail.gmail.com>
        <CAHz9+En8h8mX1OorR1Nyvf3iwHxmZRt02ufi-Je-jGsV1Nx+sw@mail.gmail.com>
        <f773a802-67a3-f148-5d36-fa8a9d168e25@gmx.com>
        <CAHz9+EkeAAOXN7K+C0Wtmu-3RPOpTC4a6pK-y5gDQCtdAc8nUA@mail.gmail.com>
        <6dc280f8-3822-078e-9b69-c3203e75ec1e@gmx.com>
        <CAHz9+EkzNkAiP4CSZCiAbTrsKik0SGS9OQ=C4TSfwtB8Rb3zvA@mail.gmail.com>
        <c8077032-58ea-da5b-ea62-6007d837e666@gmx.com>
        <CAHz9+EkB64Y-ZT37Y-Bu=HXcw-FELW4GNGf+G-fC9MPXa3WvBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brad Templeton posted on Sat, 26 May 2018 19:21:57 -0700 as excerpted:

> Certainly.  My apologies for not including them before.

Aieee!  Reply before quote, making the reply out of context, and my
attempt to reply in context... difficult and troublesome.

Please use standard list context-quote, reply in context, next time,
making it easier for further replies also in context.

> As
> described, the disks are reasonably balanced -- not as full as the
> last time.  As such, it might be enough that balance would (slowly)
> free up enough chunks to get things going.  And if I have to, I will
> partially convert to single again.   Certainly btrfs replace seems
> like the most planned and simple path but it will result in a strange
> distribution of the chunks.

[btrfs filesystem usage output below]

> Label: 'butter'  uuid: a91755d4-87d8-4acd-ae08-c11e7f1f5438
>        Total devices 3 FS bytes used 6.11TiB
>        devid    1 size 3.62TiB used 3.47TiB path /dev/sdj2Overall:
>    Device size:                  12.70TiB
>    Device allocated:             12.25TiB
>    Device unallocated:          459.95GiB
>    Device missing:                  0.00B
>    Used:                         12.21TiB
>    Free (estimated):            246.35GiB      (min: 246.35GiB)
>    Data ratio:                       2.00
>    Metadata ratio:                   2.00
>    Global reserve:              512.00MiB      (used: 1.32MiB)
> 
> Data,RAID1: Size:6.11TiB, Used:6.09TiB
>   /dev/sda        3.48TiB
>   /dev/sdi2       5.28TiB
>   /dev/sdj2       3.46TiB
> 
> Metadata,RAID1: Size:14.00GiB, Used:12.38GiB
>   /dev/sda        8.00GiB
>   /dev/sdi2       7.00GiB
>   /dev/sdj2      13.00GiB
> 
> System,RAID1: Size:32.00MiB, Used:888.00KiB
>   /dev/sdi2      32.00MiB
>   /dev/sdj2      32.00MiB
> 
> Unallocated:
>   /dev/sda      153.02GiB
>   /dev/sdi2     154.56GiB
>   /dev/sdj2     152.36GiB

[Presumably this is a bit of btrfs filesystem show output, but the
rest of it is missing...]

>       devid    2 size 3.64TiB used 3.49TiB path /dev/sda
>       devid    3 size 5.43TiB used 5.28TiB path /dev/sdi2


Based on the 100+ GiB still free on each of the three devices above,
you should have no issues balancing after replacing one of them.

Presumably the first time you tried it, there was far less, likely under
a GiB free on the two not replaced.  Since data chunks are nominally
1 GiB each and raid1 requires two copies, each on a different device,
that didn't leave enough space on either of the older devices to do
a balance, even tho there was plenty of space left on the just-replaced
new one.

(Tho multiple-GiB chunks are possible on TB+ devices, but 10 GiB free
on each device should be plenty, so 100+ GiB free on each... should be
no issues unless you run into some strange bug.)


Meanwhile, even in the case of not enough space free on all three
existing devices, given that they're currently two 4 TB devices and
a 6 TB device and that you're replacing one of the 4 TB devices with
an 8 TB device...

Doing a two-step replace, first replacing the 6 TB device with the
new 8 TB device, then resizing to the new 8 TB size, giving you ~2 TB of
free space on it, then replacing one of the 4 TB devices with the now
free 6 TB device, and again resizing to the new 6 TB size, giving you
~2 TB free on it too, thus giving you ~2 TB free on each of two devices
instead of all 4 TB of new space on a single device, should do the trick
very well, and should still be faster, probably MUCH faster, than doing
a temporary convert to single, then back to raid1, the kludge you used
last time. =:^)


Meanwhile, while kernel version of course remains up to you, given that
you mentioned 4.4 with a potential upgrade to 4.15, I will at least
cover the following, so you'll have it to use as you decide on kernel
versions.

4.15?  Why?  4.14 is the current mainline LTS kernel series, with 4.15
only being a normal short-term stable series that has already been
EOLed.  So 4.15 now makes little sense at all.  Either go current-stable
series and do 4.16 and continue to upgrade as the new kernels come (4.17
should be out shortly as it's past rc6, with rc7 likely out by the time
you read this and release likely in a week), or stick with 4.14 LTS for
the longer-term support.

Of course you can go with your distro kernel if you like, and I presume
that's why you mentioned 4.15, but as I said it's already EOLed upstream,
and of course this list being a kernel development list, our focus tends
to be on upstream/mainstream, not distro level kernels.  If you choose
a distro level kernel series that's EOLed at kernel.org, then you really
should be getting support from them for it, as they know what they've
backported and/or patched and are thus best positioned to support it.

As for what this list does try to support, it's the last two kernel
release series in each of the current and LTS tracks.  So as the first
release back from current 4.16, 4.15, tho EOLed upstream, is still
reasonably supported for the moment here, tho people should be
upgrading to 4.16 by now as 4.17 should be out in a couple weeks or
so and 4.15 would be out of the two-current-kernel-series window at that
time.

Meanwhile, the two latest LTS series are as already stated 4.14, and the
earlier 4.9.  4.4 is the one previous to that and it's still mainline
supported in general, but it's out of the two LTS-series window of best
support here, and truth be told, based on history, even supporting the
second newest LTS series starts to get more difficult at about a year and
a half out, 6 months or so before the next LTS comes out.  As it happens
that's about where 4.9 is now, and 4.14 has had about 6 months to
stabilize now, so for LTS I'd definitely recommend 4.14, now.

Of course that doesn't mean that we /refuse/ to support 4.4, we still
try, but it's out of primary focus now and in many cases, should you
have problems, the first recommendation is going to be try something
newer and see if the problem goes away or presents differently.  Or
as mentioned, check with your distro if it's a distro kernel, since
in that case they're best positioned to support it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


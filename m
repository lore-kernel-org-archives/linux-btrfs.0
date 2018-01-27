Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:57960 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751291AbeA0LYU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Jan 2018 06:24:20 -0500
Date: Sat, 27 Jan 2018 12:06:19 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180127110619.GA10472@polanet.pl>
References: <1516975360.4083556.1249069832.1B287A04@webmail.messagingengine.com>
 <5d342036-0de0-9bf7-3e9e-4885b62d8100@gmail.com>
 <1516978054.4103196.1249114200.76EC1546@webmail.messagingengine.com>
 <84c23047-522d-2529-5b16-d07ed8c28fc6@gmail.com>
 <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com>
 <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com>
 <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 27, 2018 at 13:26:13 +0300, Andrei Borzenkov wrote:

>> I just tested to boot with a single drive (raid1 degraded), even with degraded option in fstab and grub, unable to boot ! The boot process stop on initramfs.
>> 
>> Is there a solution to boot with systemd and degraded array ?
> 
> No. It is finger pointing. Both btrfs and systemd developers say
> everything is fine from their point of view.

Treating btrfs volume as ready by systemd would open a window of
opportunity when volume would be mounted degraded _despite_ all the
components are (meaning: "would soon") be ready - just like Chris Murphy
wrote; provided there is -o degraded somewhere.

This is not a systemd issue, but apparently btrfs design choice to allow
using any single component device name also as volume name itself.

IF a volume has degraded flag, then it is btrfs job to mark is as ready:

>>>>>> ... and it still does not work even if I change it to root=/dev/sda1
>>>>>> explicitly because sda1 will *not* be announced as "present" to
>>>>>> systemd> until all devices have been seen once ...

...so this scenario would obviously and magically start working.

As for the regular by-UUID mounts: these links are created by udev WHEN
underlying devices appear. Does btrfs volume appear? No.

If btrfs pretends to be device manager it should expose more states,
especially "ready to be mounted, but not fully populated" (i.e.
"degraded mount possible"). Then systemd could _fallback_ after timing
out to degraded mount automatically according to some systemd-level
option.

Unless there is *some* signalling from btrfs, there is really not much
systemd can *safely* do.

-- 
Tomasz Pala <gotar@pld-linux.org>

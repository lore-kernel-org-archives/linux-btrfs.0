Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36.italiaonline.it ([212.48.25.164]:35245 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752014AbcGGTlN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 15:41:13 -0400
Reply-To: kreijack@inwind.it
Subject: Re: 64-btrfs.rules and degraded boot
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <20160705212706.719397fc@jupiter.sol.kaishome.de>
 <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
 <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
 <10018aa9-a2e2-dd2a-b8d9-9945e0e170af@gmail.com>
 <CAA91j0VUTBc8W2CBFQJZFR4RxJAYL1bkw6GTJLsxu9mMBZ4yDw@mail.gmail.com>
 <f3b5493d-456c-f614-7c1b-fd1b6e9977bc@gmail.com>
 <1E3215A5-EAA9-425D-AE08-B81B57D3043E@gmail.com>
 <93cdc463-8f53-5cf6-055c-05b5359ad814@gmail.com>
 <fddbc0b3-deb7-8ac8-46c7-bde110206482@inwind.it>
 <de824c8d-f94f-87bd-2bf9-d27b1ff7294a@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <f253dd27-feb3-d0af-398e-b79be71f4e37@inwind.it>
Date: Thu, 7 Jul 2016 21:41:09 +0200
MIME-Version: 1.0
In-Reply-To: <de824c8d-f94f-87bd-2bf9-d27b1ff7294a@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-07 20:23, Austin S. Hemmelgarn wrote:
[...]
> FWIW, I've pretty much always been of the opinion that the device discovery belongs in a mount helper.  The auto-discovery from udev (and more importantly, how the kernel handles being told about a device) is much of the reason that it's so inherently dangerous to do block level copies.  There's obviously no way that can be changed now without breaking something, but that's on the really short list of things that I personally feel are worth breaking to fix a particularly dangerous pitfall.  The recent discovery that device ready state is write-once when set just reinforces this in my opinion.
> 
> Here's how I would picture the ideal situation:
> * A device is processed by udev.  It detects that it's part of a BTRFS array, updates blkid and whatever else in userspace with this info, and then stops without telling the kernel.
> * The kernel tracks devices until the filesystem they are part of is unmounted, or a mount of that FS fails.
> * When the user goes to mount the a BTRFS filesystem, they use a mount helper.
>   1. This helper queries udev/blkid/whatever to see which devices are part of an array.
>   2. Once the helper determines which devices are potentially in the requested FS, it checks the following things to ensure array integrity:
>     - Does each device report the same number of component devices for the array?
>     - Does the reported number match the number of devices found?
>     - If a mount by UUID is requested, do all the labels match on each device?
>     - If a mount by LABEL is requested, do all the UUID's match on each device?
>     - If a mount by path is requested, do all the component devices reported by that device have matching LABEL _and_ UUID?
>     - Is any of the devices found already in-use by another mount?
        ^^^^^^^^^^^^^^^^^ It is possible to mount two time the same device.

I add my favorite:
	- is there a conflict of disk-uuid (i.e two different disk with the same uuid) ?

Anyway the point 2 has to be in loop until timeout: i.e. if systemd ask to mount a filesystem when the first device appear, wait for all devices appear.

>   4. If any of the above checks fails, and the user has not specified an option to request a mount anyway, report the error and exit with non-zero status _before_ even talking to the kernel.
>   5. If only the second check fails (the check verifying the number of devices found), and it fails because the number found is less than required for a non-degraded mount, ignore that check if and only if the user specified -o degraded.
>   6. If any of the other checks fail, ignore them if and only if the user asks to ignore that specific check.
>   7. Otherwise, notify the kernel about the devices and call mount(2).
> * The mount helper parses it's own set of special options similar to the bg/fg/retry options used by mount.nfs to allow for timeouts when mounting, as well as asynchronous mounts in the background.
> * btrfs device scan becomes a no-op
> * btrfs device ready uses the above logic minus step 7 to determine if a filesystem is probably ready.
> 
> Such a situation would probably eliminate or at least reduce most of our current issues with device discovery, and provide much better error reporting and general flexibility.
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

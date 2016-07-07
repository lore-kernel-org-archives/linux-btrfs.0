Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36204 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbcGGS6G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 14:58:06 -0400
Received: by mail-oi0-f51.google.com with SMTP id f189so35805425oig.3
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 11:58:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <de824c8d-f94f-87bd-2bf9-d27b1ff7294a@gmail.com>
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <20160705212706.719397fc@jupiter.sol.kaishome.de> <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
 <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
 <10018aa9-a2e2-dd2a-b8d9-9945e0e170af@gmail.com> <CAA91j0VUTBc8W2CBFQJZFR4RxJAYL1bkw6GTJLsxu9mMBZ4yDw@mail.gmail.com>
 <f3b5493d-456c-f614-7c1b-fd1b6e9977bc@gmail.com> <1E3215A5-EAA9-425D-AE08-B81B57D3043E@gmail.com>
 <93cdc463-8f53-5cf6-055c-05b5359ad814@gmail.com> <fddbc0b3-deb7-8ac8-46c7-bde110206482@inwind.it>
 <de824c8d-f94f-87bd-2bf9-d27b1ff7294a@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 7 Jul 2016 12:58:04 -0600
Message-ID: <CAJCQCtS7=bR_r6+u+vSxE7rfUOOwx0G3NTff4=WUbfV3riWVSA@mail.gmail.com>
Subject: Re: 64-btrfs.rules and degraded boot
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Goffredo Baroncelli <kreijack@inwind.it>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 7, 2016 at 12:23 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

>
> Here's how I would picture the ideal situation:
> * A device is processed by udev.  It detects that it's part of a BTRFS
> array, updates blkid and whatever else in userspace with this info, and then
> stops without telling the kernel.
> * The kernel tracks devices until the filesystem they are part of is
> unmounted, or a mount of that FS fails.
> * When the user goes to mount the a BTRFS filesystem, they use a mount
> helper.
>   1. This helper queries udev/blkid/whatever to see which devices are part
> of an array.
>   2. Once the helper determines which devices are potentially in the
> requested FS, it checks the following things to ensure array integrity:
>     - Does each device report the same number of component devices for the
> array?
>     - Does the reported number match the number of devices found?
>     - If a mount by UUID is requested, do all the labels match on each
> device?
>     - If a mount by LABEL is requested, do all the UUID's match on each
> device?
>     - If a mount by path is requested, do all the component devices reported
> by that device have matching LABEL _and_ UUID?
>     - Is any of the devices found already in-use by another mount?
>   4. If any of the above checks fails, and the user has not specified an
> option to request a mount anyway, report the error and exit with non-zero
> status _before_ even talking to the kernel.
>   5. If only the second check fails (the check verifying the number of
> devices found), and it fails because the number found is less than required
> for a non-degraded mount, ignore that check if and only if the user
> specified -o degraded.
>   6. If any of the other checks fail, ignore them if and only if the user
> asks to ignore that specific check.
>   7. Otherwise, notify the kernel about the devices and call mount(2).
> * The mount helper parses it's own set of special options similar to the
> bg/fg/retry options used by mount.nfs to allow for timeouts when mounting,
> as well as asynchronous mounts in the background.
> * btrfs device scan becomes a no-op
> * btrfs device ready uses the above logic minus step 7 to determine if a
> filesystem is probably ready.
>
> Such a situation would probably eliminate or at least reduce most of our
> current issues with device discovery, and provide much better error
> reporting and general flexibility.

It might be useful to see where ZFS and LVM work and fail in this
regard. And also plan for D-Bus support to get state notifications up
to something like storaged or other such user space management tools.
Early on in Fedora there were many difficulties between systemd and
LVM, so avoiding whatever that was about would be nice.

Also, tangentially related, Fedora is replacing udisks2 with storaged.
Storaged already has a Btrfs plug-in so there should be better
awareness there. I get all kinds of damn strange behaviors in GNOME
with Btrfs multiple device volumes: volume names appearing twice in
the UI, unmounting one causes umount errors with the other.
https://fedoraproject.org/wiki/Changes/Replace_UDisks2_by_Storaged
http://storaged.org/

-- 
Chris Murphy

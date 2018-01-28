Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:46880 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752023AbeA1AQd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Jan 2018 19:16:33 -0500
Date: Sun, 28 Jan 2018 01:16:32 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180128001632.GC16927@polanet.pl>
References: <1516978054.4103196.1249114200.76EC1546@webmail.messagingengine.com>
 <84c23047-522d-2529-5b16-d07ed8c28fc6@gmail.com>
 <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com>
 <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com>
 <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <CAJCQCtT+jgHxuYvTjAKWPhnX2H6yTwB6Z7Hqk+56GVfUtKB7Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <CAJCQCtT+jgHxuYvTjAKWPhnX2H6yTwB6Z7Hqk+56GVfUtKB7Xw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 27, 2018 at 14:12:01 -0700, Chris Murphy wrote:

> doesn't count devices itself. The Btrfs systemd udev rule defers to
> Btrfs kernel code by using BTRFS_IOC_DEVICES_READY. And it's totally
> binary. Either they are all ready, in which case it exits 0, and if
> they aren't all ready it exits 1.
> 
> But yes, mounting whether degraded or not is sufficiently complicated
> that you just have to try it. I don't get the point of wanting to know
> whether it's possible without trying. Why would this information be

If you want to blind-try it, just tell the btrfs.ko to flip the IOCTL bit.

No shortcuts please, do it legit, where it belongs.

>> Ie, the thing systemd can safely do, is to stop trying to rule everything,
>> and refrain from telling the user whether he can mount something or not.
> 
> Right. Open question is whether the timer and timeout can be
> implemented in the systemd world and I don't see why not, I certainly

It can. The reasons why it's not already there follow:

1. noone created udev rules and systemd units for btrfs-progs yet (that
   is trivial),
2. btrfs is not degraded-safe yet (the rules would have to check if the
   filesystem won't stuck in read-only mode for example, this is NOT
   trivial),
3. there is not way to tell the kernel that we want degraded (probably
   some new IOCTL) - this is the path that timer would use to trigger udev
   event releasing systemd mount.

Let me repeat this, so this would be clear: this is NOT going to work
as some systemd-shortcut being "mount -o degraded", this must go through
the kernel IOCTL -> udev -> systemd path, i.e.:

timer expires -> executes IOCTL with "OK, give me degraded /dev/blah" ->
BTRFS_IOC_DEVICES_READY returns "READY" (or new value "DEGRADED") -> udev
catches event and changes SYSTEMD_READY -> systemd mounts the volume.


This is really simple. All you need to do is to pass "degraded" to the
btrfs.ko, so the BTRFS_IOC_DEVICES_READY would return "go ahead".

-- 
Tomasz Pala <gotar@pld-linux.org>

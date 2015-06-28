Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f51.google.com ([209.85.216.51]:36803 "EHLO
	mail-vn0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbbF1TIY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Jun 2015 15:08:24 -0400
Received: by vnbg1 with SMTP id g1so21450080vnb.3
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2015 12:08:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADfjVrhmUhWAs0+6_s-hDcoLyrXdvkY1fZgoKv2VRDt2F8MWhQ@mail.gmail.com>
References: <CA+xOVSOD1YY-=Cm+vmzTUV9cHe9idtDkRr0RmpRP5a0Z6eC4YQ@mail.gmail.com>
	<CA+xOVSNu547eo6TY_mwLypTGWuE5AmyMqC6GwR06Sir1282vqA@mail.gmail.com>
	<CAJCQCtSv15DVDju7vhm=Luc5hqWvce__F7iovh87uxq37bNg0Q@mail.gmail.com>
	<CA+xOVSMjO0e5TPfksr=TmnT9zc5=hJemYPtn_tg+xxsWbFMV=A@mail.gmail.com>
	<CADfjVrhmUhWAs0+6_s-hDcoLyrXdvkY1fZgoKv2VRDt2F8MWhQ@mail.gmail.com>
Date: Sun, 28 Jun 2015 13:08:21 -0600
Message-ID: <CAJCQCtSzFCUSAjRwmXFVnearTJ2jSPYm5ONxj5gHnDRN8Y8yUw@mail.gmail.com>
Subject: Re: btrfs replace seems to corrupt the file system
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 28, 2015 at 12:50 PM, Noah Massey <noah.massey@gmail.com> wrote:
> On Sun, Jun 28, 2015 at 2:02 PM, Mordechay Kaganer <mkaganer@gmail.com> wrote:
>> To recover the old device, that's what i'm trying to do. Asked on IRC
>> also, no reply. As stated above, the device passes btrfs check without
>> errors but cannot mount because it complains about "ongoing replace"
>> and the replace device is missing.
>
> Standard disclaimer, not a dev, just a user.
> The following worked for me to recover the old device after
> reproducing your situation:
> (where loop0 is my "old" device)
>
> # mount -t btrfs -o degraded /dev/loop0 /mnt
> # btrfs replace cancel /mnt
> # btrfs umount /mnt
> # mount -t btrfs /dev/loop0 /mnt
>
> mount now succeeds without error.

Neat trick!

>
> $ uname -r
> 4.1.0
> $ btrfs version
> btrfs-progs v4.1

Yeah I definitely advise a newer kernel and progs. Even if this trick
works with the older kernel (seems reasonably likely) that the next
attempt at btrfs replace needs to happen with a newer kernel and progs
anyway.

Bit off topic question is the device used as the target for
replacement has superblocks from the first (failed, bad csum) attempt.
So I wonder to what degree it's non-deterministic to try this again
without erasing at least the old superblocks first? They have the same
UUID is the thing; if the UUID from a different volume were used,
there's no ambiguity between the stale and new data, but is there any
possibility of confusion with a new attempt when UUID is the same?

-- 
Chris Murphy

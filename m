Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:32794 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbbF1TUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Jun 2015 15:20:23 -0400
Received: by laar3 with SMTP id r3so41409457laa.0
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2015 12:20:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADfjVrhmUhWAs0+6_s-hDcoLyrXdvkY1fZgoKv2VRDt2F8MWhQ@mail.gmail.com>
References: <CA+xOVSOD1YY-=Cm+vmzTUV9cHe9idtDkRr0RmpRP5a0Z6eC4YQ@mail.gmail.com>
	<CA+xOVSNu547eo6TY_mwLypTGWuE5AmyMqC6GwR06Sir1282vqA@mail.gmail.com>
	<CAJCQCtSv15DVDju7vhm=Luc5hqWvce__F7iovh87uxq37bNg0Q@mail.gmail.com>
	<CA+xOVSMjO0e5TPfksr=TmnT9zc5=hJemYPtn_tg+xxsWbFMV=A@mail.gmail.com>
	<CADfjVrhmUhWAs0+6_s-hDcoLyrXdvkY1fZgoKv2VRDt2F8MWhQ@mail.gmail.com>
Date: Sun, 28 Jun 2015 22:20:16 +0300
Message-ID: <CA+xOVSOxTnRpfxnw=FpizBNGJmdi5y_aEPRZqHos6W5u4=HgbQ@mail.gmail.com>
Subject: Re: btrfs replace seems to corrupt the file system
From: Mordechay Kaganer <mkaganer@gmail.com>
To: Noah Massey <noah.massey@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

B.H.

On Sun, Jun 28, 2015 at 9:50 PM, Noah Massey <noah.massey@gmail.com> wrote:
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

Yeah! That worked even with my old kernel/btrfs-progs. Thank you very
much. Now the old volume mounts OK. The next step for me is to run
scrub on it to see if the data is actually intact.

Then (if it's OK, hopefully) we'll see how to redo the replace. Maybe,
unmount and do a simple "dd" will be the best option? At least it's
not going to corrupt the original data :-).

-- 
משיח NOW!
Moshiach is coming very soon, prepare yourself!
יחי אדוננו מורינו ורבינו מלך המשיח לעולם ועד!

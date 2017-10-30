Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:54548 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751886AbdJ3OhD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 10:37:03 -0400
Received: from mail-yw0-f170.google.com ([209.85.161.170]) by
 mrelay.perfora.net (mreueus001 [74.208.5.2]) with ESMTPSA (Nemesis) id
 0MaLU6-1dtqBq2J0C-00K3Gw for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017
 15:37:02 +0100
Received: by mail-yw0-f170.google.com with SMTP id k11so11737957ywh.1
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017 07:37:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$7f6a7$60d76ea4$36d8c4cb$1d03823c@cox.net>
References: <CAD8FQQ0tO3AZDDh89hczwZ1pL70uom5EBY2fbZWm_LDJAQE2UQ@mail.gmail.com>
 <CAD8FQQ3kBfy8kLFzSm-OVbsYsQ7-LzH0faD09__4S5_q0bM7pA@mail.gmail.com>
 <CAKuJGC-aRt_NKboYa9ZK6ApWDJ_knM-UazPxEUq7sHiNXEqA6w@mail.gmail.com>
 <CAD8FQQ20m3sgLKc_utf2xb-J6bhf1W58mAkEFc2jyJy7-bH3+w@mail.gmail.com>
 <CAD8FQQ3boTj97yu-F8CiFBvR-EfD+1chcSo=VzyAxwO7GpomEg@mail.gmail.com>
 <CAKuJGC8omM8TMg7DqncuoM6e0jdUOdiwNLU6q29z__U=2NQHvg@mail.gmail.com>
 <1484297967.48018.1508985286675@email.1and1.com> <CAJCQCtS9he3cpqKgnFQjM2GPA1atvgfmi2ZhrjGZg8Yq1h91BQ@mail.gmail.com>
 <CAD8FQQ1t63ubt=e2MZ+=VJTJ1uMi5NgnfZXzc72eMyWT76E4nw@mail.gmail.com> <pan$7f6a7$60d76ea4$36d8c4cb$1d03823c@cox.net>
From: Zak Kohler <y2k@y2kbugger.com>
Date: Mon, 30 Oct 2017 10:36:31 -0400
Message-ID: <CAD8FQQ1RQh4sHz+V_M_85+rWm-526hfRqXyyCqJT0Gjb7kZfkw@mail.gmail.com>
Subject: Re: btrfs send yields "ERROR: send ioctl failed with -5: Input/output error"
To: btrfs <linux-btrfs@vger.kernel.org>
Cc: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lakshmipathi.G posted on Mon, Oct 30, 2017 at 12:07 AM as excerpted:

> Can you share these steps as simple bash script? Currently I'm running
> few tests, I can check your script and share the results.

sure, but it is pretty trivial:

device1=/dev/disk/by-id/XX1
device2=/dev/disk/by-id/XX2
device3=/dev/disk/by-id/XX3

mkfs.btrfs -L OfflineJ $device1 $device2 $device3
mount -t btrfs $device1 /mnt
btrfs subvolume create /mnt/dataroot
mkdir -p /media/OfflineJ

umount /mnt
mount -o subvol=/dataroot $device1 /media/OfflineJ

> > The only thing I could think of is that the btrfs version that I used to mkfs
> > was not up to date. Is there a way to determine which version was used to
> > create the filesystem?
> >
> If I'm not wrong, i don't think we can get mkfs version from existing file
> system layout. what was your kernel version?

Not quite sure.
Oldest: archlinux linux-lts as of 2017.06.08
Most likely: archlinux linux-lts as of 2017.10.18

It may be possible that I updated and created the fs without
rebooting or reloading the kernel modules. But normally in that case
any interaction, even mounting, just fails loudly.


Duncan posted on Mon, Oct 30, 2017 at 12:09 AM as excerpted:

> and I downclocked it a notch (from its rated pc3200 to 3000, IIRC).  At

Hmm, I did have a mild overclock on this system when I used it as a desktop
but I thought I reverted it when I made it into a server. I'll double
check this.

> sometimes, but not always, trigger as well, but the most frequent symptom
> really was checksum verification failures untarring tbz2s.

I'll have to try and recreate this using my EXT4 system disk.


Zak Kohler posted on Sun, Oct 29, 2017 at 9:57 PM as excerpted:

> I'm running '$ sudo btrfs scrub start --offline --progress
> /dev/disk/by-id/WD-XX3' one more time to just to make sure that I
> wasn't reading something wrong.

Well even stranger news on the fourth run:

$ sudo btrfs scrub start --offline --progress /dev/disk/by-id/WD-XX3
Csum error: 175 # first run
Csum error: 112 # second run...
Csum error: 285 # third run...
Csum error: 0 # fourth run

Also can anyone confirm that the above --offline command checks the whole
filesystem regardless which device is specified on the cli?

> Only other think I can think to try is transferring those drives to
> another system.

I still need to try this also.

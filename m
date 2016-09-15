Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:42620 "EHLO mout1.freenet.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754485AbcIOUlw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 16:41:52 -0400
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
        by mout1.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (port 25) (Exim 4.85 #1)
        id 1bkd4K-0008L9-7P
        for linux-btrfs@vger.kernel.org; Thu, 15 Sep 2016 22:15:36 +0200
Received: from localhost ([::1]:36540 helo=mjail1.freenet.de)
        by mjail1.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (Exim 4.85 #1)
        id 1bkd4K-0008Q7-2y
        for linux-btrfs@vger.kernel.org; Thu, 15 Sep 2016 22:15:36 +0200
Received: from mx1.freenet.de ([195.4.92.11]:35329)
        by mjail1.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (Exim 4.85 #1)
        id 1bkd0Q-0003Pi-Bq
        for linux-btrfs@vger.kernel.org; Thu, 15 Sep 2016 22:11:34 +0200
Received: from ppp-88-217-2-152.dynamic.mnet-online.de ([88.217.2.152]:55604 helo=[192.168.1.206])
        by mx1.freenet.de with esmtpsa (ID master.b.at.raven@chefmail.de) (TLSv1.2:DHE-RSA-AES128-SHA:128) (port 465) (Exim 4.85 #1)
        id 1bkd0Q-0005zv-6y
        for linux-btrfs@vger.kernel.org; Thu, 15 Sep 2016 22:11:34 +0200
Subject: Re: Size of scrubbed Data
References: <CAA3ktqmQ+kGddhuw6gC9Hoct+eayxjZFrDjigffCgmDa09=PBA@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: g6094199@freenet.de
Message-ID: <1fedb20d-9137-53f2-8d40-fcbf466b658d@chefmail.de>
Date: Thu, 15 Sep 2016 22:11:51 +0200
MIME-Version: 1.0
In-Reply-To: <CAA3ktqmQ+kGddhuw6gC9Hoct+eayxjZFrDjigffCgmDa09=PBA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Stefan,

1st you should run an balance on system data to move the single data to
raid1. imho.
then do the scrub again.
btw are there any scrubbing errors in dmesg? disks are ok?! any
compression involved? changed freespacecache to v2?


sash



Am 15.09.2016 um 17:48 schrieb Stefan Malte Schumacher:
> Hello
>
>
> I have encountered a very strange phenomenon while using btrfs-scrub.
> I believe it may be a result of replacing my old installation of
> Debian Jessie with Debian Stretch, resulting in a Kernel Switch from
> 3.16+63 to 4.6.0-1. I scrub my filesystem once a month and let anacron
> send me the results. My filesystem, consisting of four four-gigabyte
> drives with both data and metadata as RAID1 was reported as containing
> nearly 12TiB of data in scrubs done in May, June, July and August. But
> then it changed and suddenly shows only 9TiB in size, despite the fact
> that I did not delete any large files. If I remember correctly my
> switch from Debian Jessie to Stretch was around that time period.
> Could someone explain this behavior to me? Was a new way of
> calculating the size of scrubed data introduced? How can I check if I
> have lost data? I have a backup, but only one generation and rsync
> will by now have deleted files on the NAS, which might have lost on
> the fileserver. According to the long and short self-tests, which I
> run with smartmontools my drives are alright. How do I proceed?
>
>
>
> Yours
>
> Stefan
>
> uname -a
> Linux mars 4.6.0-1-amd64 #1 SMP Debian 4.6.4-1 (2016-07-18) x86_64 GNU/Linux
>
> btrfs --version
> btrfs-progs v4.7.1
>
>  btrfs fi show
> Label: none  uuid: 8c668854-db5d-45a7-875d-43c4e82a829e
>         Total devices 4 FS bytes used 6.06TiB
>         devid    1 size 3.64TiB used 3.09TiB path /dev/sde
>         devid    2 size 3.64TiB used 3.09TiB path /dev/sdc
>         devid    3 size 3.64TiB used 3.09TiB path /dev/sdd
>         devid    4 size 3.64TiB used 3.09TiB path /dev/sda
>
>
>  btrfs fi df /mnt/btrfs-raid/
> Data, RAID1: total=6.17TiB, used=6.05TiB
> System, RAID1: total=32.00MiB, used=916.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, RAID1: total=10.00GiB, used=8.14GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> Maybe this is also of use in identifying the problem:
> grep btrfs *
> grep: apt: Ist ein Verzeichnis
> grep: cups: Ist ein Verzeichnis
> dpkg.log:2016-09-03 15:20:16 upgrade btrfs-progs:amd64 4.7-1 4.7.1-1
> dpkg.log:2016-09-03 15:20:16 status triggers-awaited btrfs-progs:amd64 4.7-1
> dpkg.log:2016-09-03 15:20:16 status half-configured btrfs-progs:amd64 4.7-1
> dpkg.log:2016-09-03 15:20:16 status unpacked btrfs-progs:amd64 4.7-1
> dpkg.log:2016-09-03 15:20:16 status half-installed btrfs-progs:amd64 4.7-1
> dpkg.log:2016-09-03 15:20:16 status half-installed btrfs-progs:amd64 4.7-1
> dpkg.log:2016-09-03 15:20:17 status unpacked btrfs-progs:amd64 4.7.1-1
> dpkg.log:2016-09-03 15:20:17 status unpacked btrfs-progs:amd64 4.7.1-1
> dpkg.log:2016-09-03 15:20:45 configure btrfs-progs:amd64 4.7.1-1 <keine>
> dpkg.log:2016-09-03 15:20:45 status unpacked btrfs-progs:amd64 4.7.1-1
> dpkg.log:2016-09-03 15:20:45 status unpacked btrfs-progs:amd64 4.7.1-1
> dpkg.log:2016-09-03 15:20:45 status half-configured btrfs-progs:amd64 4.7.1-1
> dpkg.log:2016-09-03 15:20:46 status triggers-awaited btrfs-progs:amd64 4.7.1-1
> dpkg.log:2016-09-03 15:20:51 status installed btrfs-progs:amd64 4.7.1-1
> dpkg.log.1:2016-08-10 16:58:23 upgrade btrfs-progs:amd64 4.5.2-1 4.6.1-1
> dpkg.log.1:2016-08-10 16:58:23 status triggers-awaited btrfs-progs:amd64 4.5.2-1
> dpkg.log.1:2016-08-10 16:58:23 status half-configured btrfs-progs:amd64 4.5.2-1
> dpkg.log.1:2016-08-10 16:58:23 status unpacked btrfs-progs:amd64 4.5.2-1
> dpkg.log.1:2016-08-10 16:58:23 status half-installed btrfs-progs:amd64 4.5.2-1
> dpkg.log.1:2016-08-10 16:58:24 status half-installed btrfs-progs:amd64 4.5.2-1
> dpkg.log.1:2016-08-10 16:58:24 status unpacked btrfs-progs:amd64 4.6.1-1
> dpkg.log.1:2016-08-10 16:58:24 status unpacked btrfs-progs:amd64 4.6.1-1
> dpkg.log.1:2016-08-10 17:01:25 configure btrfs-progs:amd64 4.6.1-1 <keine>
> dpkg.log.1:2016-08-10 17:01:25 status unpacked btrfs-progs:amd64 4.6.1-1
> dpkg.log.1:2016-08-10 17:01:26 status unpacked btrfs-progs:amd64 4.6.1-1
> dpkg.log.1:2016-08-10 17:01:26 status half-configured btrfs-progs:amd64 4.6.1-1
> dpkg.log.1:2016-08-10 17:01:26 status triggers-awaited btrfs-progs:amd64 4.6.1-1
> dpkg.log.1:2016-08-10 17:02:34 status installed btrfs-progs:amd64 4.6.1-1
> dpkg.log.1:2016-08-19 00:45:05 upgrade btrfs-progs:amd64 4.6.1-1 4.7-1
> dpkg.log.1:2016-08-19 00:45:05 status triggers-awaited btrfs-progs:amd64 4.6.1-1
> dpkg.log.1:2016-08-19 00:45:05 status half-configured btrfs-progs:amd64 4.6.1-1
> dpkg.log.1:2016-08-19 00:45:05 status unpacked btrfs-progs:amd64 4.6.1-1
> dpkg.log.1:2016-08-19 00:45:05 status half-installed btrfs-progs:amd64 4.6.1-1
> dpkg.log.1:2016-08-19 00:45:06 status half-installed btrfs-progs:amd64 4.6.1-1
> dpkg.log.1:2016-08-19 00:45:06 status unpacked btrfs-progs:amd64 4.7-1
> dpkg.log.1:2016-08-19 00:45:06 status unpacked btrfs-progs:amd64 4.7-1
> dpkg.log.1:2016-08-19 00:47:06 configure btrfs-progs:amd64 4.7-1 <keine>
> dpkg.log.1:2016-08-19 00:47:06 status unpacked btrfs-progs:amd64 4.7-1
> dpkg.log.1:2016-08-19 00:47:06 status unpacked btrfs-progs:amd64 4.7-1
> dpkg.log.1:2016-08-19 00:47:06 status half-configured btrfs-progs:amd64 4.7-1
> dpkg.log.1:2016-08-19 00:47:06 status triggers-awaited btrfs-progs:amd64 4.7-1
> dpkg.log.1:2016-08-19 00:49:22 status installed btrfs-progs:amd64 4.7-1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



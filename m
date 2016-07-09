Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:34279 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbcGIFkS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Jul 2016 01:40:18 -0400
Received: by mail-lf0-f43.google.com with SMTP id h129so39701831lfh.1
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jul 2016 22:40:17 -0700 (PDT)
Subject: Re: raid1 has failing disks, but smart is clear
To: Corey Coughlin <corey.coughlin.cc3@gmail.com>,
        Tomasz Kusmierz <tom.kusmierz@gmail.com>
References: <577D82AE.3040005@gmail.com>
 <03E1A820-7029-4022-9D46-900C4FCA1ADC@gmail.com> <577DF95E.7080100@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <57808E3E.2020907@gmail.com>
Date: Sat, 9 Jul 2016 08:40:14 +0300
MIME-Version: 1.0
In-Reply-To: <577DF95E.7080100@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

07.07.2016 09:40, Corey Coughlin пишет:
> Hi Tomasz,
>     Thanks for the response!  I should clear some things up, though.
> 
> On 07/06/2016 03:59 PM, Tomasz Kusmierz wrote:
>>> On 6 Jul 2016, at 23:14, Corey Coughlin
>>> <corey.coughlin.cc3@gmail.com> wrote:
>>>
>>> Hi all,
>>>     Hoping you all can help, have a strange problem, think I know
>>> what's going on, but could use some verification.  I set up a raid1
>>> type btrfs filesystem on an Ubuntu 16.04 system, here's what it looks
>>> like:
>>>
>>> btrfs fi show
>>> Label: none  uuid: 597ee185-36ac-4b68-8961-d4adc13f95d4
>>>     Total devices 10 FS bytes used 3.42TiB
>>>     devid    1 size 1.82TiB used 1.18TiB path /dev/sdd
>>>     devid    2 size 698.64GiB used 47.00GiB path /dev/sdk
>>>     devid    3 size 931.51GiB used 280.03GiB path /dev/sdm
>>>     devid    4 size 931.51GiB used 280.00GiB path /dev/sdl
>>>     devid    5 size 1.82TiB used 1.17TiB path /dev/sdi
>>>     devid    6 size 1.82TiB used 823.03GiB path /dev/sdj
>>>     devid    7 size 698.64GiB used 47.00GiB path /dev/sdg
>>>     devid    8 size 1.82TiB used 1.18TiB path /dev/sda
>>>     devid    9 size 1.82TiB used 1.18TiB path /dev/sdb
>>>     devid   10 size 1.36TiB used 745.03GiB path /dev/sdh
> Now when I say that the drives mount points change, I'm not saying they
> change when I reboot.  They change while the system is running.  For
> instance, here's the fi show after I ran a "check --repair" run this
> afternoon:
> 
> btrfs fi show
> Label: none  uuid: 597ee185-36ac-4b68-8961-d4adc13f95d4
>     Total devices 10 FS bytes used 3.42TiB
>     devid    1 size 1.82TiB used 1.18TiB path /dev/sdd
>     devid    2 size 698.64GiB used 47.00GiB path /dev/sdk
>     devid    3 size 931.51GiB used 280.03GiB path /dev/sdm
>     devid    4 size 931.51GiB used 280.00GiB path /dev/sdl
>     devid    5 size 1.82TiB used 1.17TiB path /dev/sdi
>     devid    6 size 1.82TiB used 823.03GiB path /dev/sds
>     devid    7 size 698.64GiB used 47.00GiB path /dev/sdg
>     devid    8 size 1.82TiB used 1.18TiB path /dev/sda
>     devid    9 size 1.82TiB used 1.18TiB path /dev/sdb
>     devid   10 size 1.36TiB used 745.03GiB path /dev/sdh
> 
> Notice that /dev/sdj in the previous run changed to /dev/sds.  There was
> no reboot, the mount just changed.  I don't know why that is happening,
> but it seems like the majority of the errors are on that drive.  But
> given that I've fixed the start/stop issue on that disk, it probably
> isn't a WD Green issue.

It's not "mount point", it is just device names. Do not make it sound
more confusing than it already is :)

This implies that disks drop off and reappear. Do you have "dmesg" or
log (/var/log/syslog or /var/log/messages or journalctl) for the same
period of time?


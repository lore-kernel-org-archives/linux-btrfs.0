Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38119 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933981AbcJ1IWJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Oct 2016 04:22:09 -0400
Received: by mail-wm0-f46.google.com with SMTP id n67so96653689wme.1
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Oct 2016 01:22:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMPo9sqnPsS6wCJDy5qtxsVMyj=t5suCq1yaf-1kJ5WS=NHMkA@mail.gmail.com>
References: <CAMPo9sqnPsS6wCJDy5qtxsVMyj=t5suCq1yaf-1kJ5WS=NHMkA@mail.gmail.com>
From: =?UTF-8?B?QmVhcmNhdCDFnsOhbmRvcg==?= <bearcatsandor@gmail.com>
Date: Fri, 28 Oct 2016 02:21:27 -0600
Message-ID: <CAMPo9so1NwzgfCEzgteBRjV5KH_q8ynjn62fbbauM7N61gy7+w@mail.gmail.com>
Subject: Re: It takes me up to 20 reboots for the system to start sda
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the suggestions Kai.  I'm using dracut 044.

I tried using the rootdelay=2 kernel parameter to little effect other
than slowing down my booting.

I found this, which may be related:
https://github.com/dracutdevs/dracut/issues/149 (btrfs raid on rootdev
is unreliably mounted).

On Thu, Oct 27, 2016 at 7:17 PM, Bearcat Şándor <bearcatsandor@gmail.com> wrote:
> Folks,
>
> I have a btrfs raid 10 spread out among 4 ssds.  The main drive is
> sda. When i reboot my system after the kernel loads i see "a start job
> is running for dev-sda1.device.  I've let this sit for 3 hours with no
> progress into the boot, and it seems to be a race condition of some
> sort.
>
> If i restart around 20 times one of them will let the system continue
> booting, though i've been lucky enough to have it happen in 4. I have
> the following systemd unit:
> /etc/systemd/system/local-fs-pre.target.wants/btrfs-dev-scan.service
>
> [Unit]
> Description=Btrfs scan devices
> Before=local-fs-pre.target
> DefaultDependencies=false
>
> [Service]
> Type=oneshot
> ExecStart=/sbin/btrfs device scan
>
> [Install]
> WantedBy=local-fs-pre.target
>
> These 4 disks were joined to /dev/sda
>    btrfs device add -f /dev/sdc /dev/sdd /dev/sde /
>
> followed by
>     btrfs balance start -dconvert=raid10 -mconvert=raid10 /
>
> my fstab contains:
> /dev/sdf1 /boot vfat defaults,noatime,discard 0 2
> /dev/sda / btrfs defaults,noatime,discard,compress=zlib,autodefrag 0 1
> /dev/sdb  /home/hometheater btrfs
> defaults,noatime,discard,compress=zlib,autodefrag 0 2
>
>
> Any ideas would be appreciated. For what it's worth i have smartd running.
>
> Thank you,
>
> --
> Bearcat M. Şándor
> Feline Soul Systems LLC
> Voice: 872.CAT.SOUL (872.228.7685)
> Fax: 406.235.7070



-- 
Bearcat M. Şándor
Feline Soul Systems LLC
Voice: 872.CAT.SOUL (872.228.7685)
Fax: 406.235.7070

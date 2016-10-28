Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:59774 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S964894AbcJ1CH4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 22:07:56 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bzwZs-0003dF-Rb
        for linux-btrfs@vger.kernel.org; Fri, 28 Oct 2016 04:07:28 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: It takes me up to 20 reboots for the system to start sda
Date: Fri, 28 Oct 2016 04:06:54 +0200
Message-ID: <20161028040654.3859a849@jupiter.sol.kaishome.de>
References: <CAMPo9sqnPsS6wCJDy5qtxsVMyj=t5suCq1yaf-1kJ5WS=NHMkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Thu, 27 Oct 2016 19:17:52 -0600
schrieb Bearcat Şándor <bearcatsandor@gmail.com>:

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
> Any ideas would be appreciated. For what it's worth i have smartd
> running.

Try kernel parameter rootdelay=2 (or maybe higher value). I had this,
too, back a while. It seems to be fixed in later versions of dracut.
Which initramfs are you using?

I guess sda is not available when btrfs-scan runs, and thus the mount
will be incomplete and systemd just waits.

-- 
Regards,
Kai

Replies to list-only preferred.



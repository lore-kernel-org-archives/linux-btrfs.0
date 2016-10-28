Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60359 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750776AbcJ1LiF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Oct 2016 07:38:05 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1c05Tn-00028i-BG
        for linux-btrfs@vger.kernel.org; Fri, 28 Oct 2016 13:37:47 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: It takes me up to 20 reboots for the system to start sda
Date: Fri, 28 Oct 2016 13:36:33 +0200
Message-ID: <20161028133633.6799b6bf@jupiter.sol.kaishome.de>
References: <CAMPo9sqnPsS6wCJDy5qtxsVMyj=t5suCq1yaf-1kJ5WS=NHMkA@mail.gmail.com>
        <CAMPo9so1NwzgfCEzgteBRjV5KH_q8ynjn62fbbauM7N61gy7+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Fri, 28 Oct 2016 02:21:27 -0600
schrieb Bearcat Şándor <bearcatsandor@gmail.com>:

> Thanks for the suggestions Kai.  I'm using dracut 044.
> 
> I tried using the rootdelay=2 kernel parameter to little effect other
> than slowing down my booting.
> 
> I found this, which may be related:
> https://github.com/dracutdevs/dracut/issues/149 (btrfs raid on rootdev
> is unreliably mounted).

Ah okay, then I maybe fixed it by setting grub not to use UUIDs for
mounting:

$ cat /etc/default/grub
...
GRUB_DISABLE_LINUX_UUID="true"
GRUB_DEVICE="LABEL=system"

Additionally I manually forced mounting by label (of course you need to
set a label for your filesystem). And I've set rootfstype so it won't
try all the other different filesystems first (which leads to a lot of
error messages in dmesg).

But I later switched to systemd-boot. But it also used labels for
mounting root. It looks like this:

title      Gentoo/Linux 13.0
version    4.8.4-gentoo
machine-id 121b87ca633e8ac0016656680000001b
linux      /vmlinuz-4.8.4-gentoo
initrd     /initramfs-4.8.4-gentoo.img
options    root=LABEL=system rootfstype=btrfs rootflags=compress=lzo,nossd,autodefrag,noatime zswap.enabled=1 splash loglevel=3

As you can see, I no longer need rootdelay or rootwait as parameters.


> On Thu, Oct 27, 2016 at 7:17 PM, Bearcat Şándor
> <bearcatsandor@gmail.com> wrote:
> > Folks,
> >
> > I have a btrfs raid 10 spread out among 4 ssds.  The main drive is
> > sda. When i reboot my system after the kernel loads i see "a start
> > job is running for dev-sda1.device.  I've let this sit for 3 hours
> > with no progress into the boot, and it seems to be a race condition
> > of some sort.
> >
> > If i restart around 20 times one of them will let the system
> > continue booting, though i've been lucky enough to have it happen
> > in 4. I have the following systemd unit:
> > /etc/systemd/system/local-fs-pre.target.wants/btrfs-dev-scan.service
> >
> > [Unit]
> > Description=Btrfs scan devices
> > Before=local-fs-pre.target
> > DefaultDependencies=false
> >
> > [Service]
> > Type=oneshot
> > ExecStart=/sbin/btrfs device scan
> >
> > [Install]
> > WantedBy=local-fs-pre.target
> >
> > These 4 disks were joined to /dev/sda
> >    btrfs device add -f /dev/sdc /dev/sdd /dev/sde /
> >
> > followed by
> >     btrfs balance start -dconvert=raid10 -mconvert=raid10 /
> >
> > my fstab contains:
> > /dev/sdf1 /boot vfat defaults,noatime,discard 0 2
> > /dev/sda / btrfs defaults,noatime,discard,compress=zlib,autodefrag
> > 0 1 /dev/sdb  /home/hometheater btrfs
> > defaults,noatime,discard,compress=zlib,autodefrag 0 2
> >
> >
> > Any ideas would be appreciated. For what it's worth i have smartd
> > running.
> >
> > Thank you,
> >
> > --
> > Bearcat M. Şándor
> > Feline Soul Systems LLC
> > Voice: 872.CAT.SOUL (872.228.7685)
> > Fax: 406.235.7070  
> 
> 
> 



-- 
Regards,
Kai

Replies to list-only preferred.



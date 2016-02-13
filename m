Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:33442 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbcBMSUn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Feb 2016 13:20:43 -0500
Received: by mail-ig0-f174.google.com with SMTP id y8so51076207igp.0
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Feb 2016 10:20:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56BF3FD2.2030005@friedels.name>
References: <56AFCEC3.9050803@friedels.name>
	<CAJCQCtRox+q5u902iwA3YL2yvEP+9_=02HJzpZU6TWZ1R9V+Qg@mail.gmail.com>
	<56B126DD.90009@friedels.name>
	<CAJCQCtT0S6CiErJYUju5D5-q0s-KBXuYkXxMURjppZcgURP4wA@mail.gmail.com>
	<56B24393.9030108@friedels.name>
	<CAJCQCtQgXRULpEG4HkOfhsB658kQS_jo2iw-xsY9zNpB1yDFoQ@mail.gmail.com>
	<CAJCQCtTth7gKnCKsuJhaJ2jvYxzgZ76+gqQZOE2q7HJANXPQag@mail.gmail.com>
	<56BF3FD2.2030005@friedels.name>
Date: Sat, 13 Feb 2016 11:20:42 -0700
Message-ID: <CAJCQCtTOy6+YMEZH0OOU6LivspgYxYGVAJpmKgf44tK+YX5bFg@mail.gmail.com>
Subject: Re: booting from BTRFS works only with one device in the pool
From: Chris Murphy <lists@colorremedies.com>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 13, 2016 at 7:38 AM, Hendrik Friedel <hendrik@friedels.name> wrote:
> Hello Chris,
>
> thanks, I appreciate your help
>
> -----------------
> 1. Install CentOS 7.0 to vda
> 2. reboot
> 3. btrfs dev add /dev/vdb /
> 4. reboot
> ## works
> 5. btrfs balance start /
> 6. reboot
> ## works
>
> Same thing when starting with CentOS 7.2 media.
>
> This is a NAS product using CentOS 7.2? My only guess is they've
> changed something broke this.
> -----------------
> I confirm that it runs also for me on CentOS 7 Minimal.  Thus we can rule
> out CentOS and myself as the Source of the problem.
> Rockstor is Based on Centos 7.2.
>
> So, I compared the grub.cfg of Centos 7.2 -which works for me to Rockstor.
>
> I see very few differences apart from UUIDs:
> 1) menuentry 'Rockstor' --class rhel fedora
>    menuentry 'Centos  ' --class centos
> 2) insmod ext2
>    insmod zfs

Rockstor uses an ext234 file system for /boot, where CentOS 7x by
default uses XFS. This is a non-factor. I see no meaningful difference
in the grub.cfg.

I expect the problem is in the initramfs or udev rules. You'll
probably need to boot with some combination of
'systemd.log_level=debug rd.debug rd.udev.debug' using all three
options at the same time will make boot incredibly slow, and
'journalctl -b' will be extremely verbose. So you just try systemd
debug first and see if that helps sort out whether this is a dracut or
udev problem.




-- 
Chris Murphy

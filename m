Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:33359 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbcAUVZt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 16:25:49 -0500
Received: by mail-ig0-f182.google.com with SMTP id z14so133456267igp.0
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 13:25:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56A13176.2050502@gmail.com>
References: <56A13176.2050502@gmail.com>
Date: Thu, 21 Jan 2016 14:25:49 -0700
Message-ID: <CAJCQCtS3roJ84TNROAOwpyEFh_D85RcajAAOFkE5iURoKqVt4Q@mail.gmail.com>
Subject: Re: "Some devices missing" only while not mounted
From: Chris Murphy <lists@colorremedies.com>
To: Konstantin Svist <fry.kun@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 21, 2016 at 12:28 PM, Konstantin Svist <fry.kun@gmail.com> wrote:

> 1 of the drives failed (/dev/sdb; command timeouts, link reset
> messages), causing a kernel panic by btrfs getting really confused.
> After reboot, I got "parent transid verify failed" while trying to mount.

For each drive:
# smartctl -l scterc /dev/sdX
# cat /sys/block/sdX/device/timeout

The first value must be less than the second. Note that the first
value is in deciseconds, and the second value is in seconds. If scterc
is not supported or disabled, then its equivalent value is only
determined by knowing how the firmware does ECC and the max time it
will try to do recovery on reads, but this can be 120+ seconds.

Chances are there's a misconfiguration in this setup that's allowing
bad sectors to cause the drive to do error recovery, and the SCSI
command timer is being reached before the drive can report a read
error, and this results in the link resets and an accumulation of bad
sectors. It often eventually leads to data loss.


> Booted into USB stick (fedora 23 lxde live), found /dev/sdb2 by SMART
> errors, saw that I can mount degraded (without /dev/sdb2) without any
> errors.
> Replaced the bad drive with a new one, ran "btrfs dev add", "btrfs del
> missing" using btrfs-progs v4.2.2 -- this returned an error saying no
> "missing" device or something.
> Upgraded to btrfs-progs 4.3.1, this time it went fine.
> Reboot to main system got stuck on systemd waiting for btrfs device.



>
> After some back and forth, I found that "ready" returns an error and "fi
> show" is inconsistent.
> /dev/sda2 was showing up as dev id 5 (2 missing)

2 missing with raid10 is not OK, filesystem is probably not repairable
has been my experience

>
> Tried removing /dev/sdb2 again and "btrfs replace"ing the now-missing
> /dev/sdb2 with the fresh instance of /dev/sdb2.
> Now /dev/sdb2 shows up as device 6 (2 and 5 not listed).

Well, the problem is already that you have 2 missing, and trying to do
a replace just makes things worse, near as I can tell. While you might
have found a bug here, you've made it a lot worse by just trying
something difference (dev replace) trying to beat Btrfs over the head
with a hammer rather than trying to solve the mysterious missing
device problem. If Btrfs really thinks there are two missing devices
on raid10, then it's probably a hosed file system at this point.


> "fi show" on mounted /dev/sda2 looks normal; on unmounted /dev/sda2
> shows "Total devices 5" and "Some devices missing"

This is a confusing interpretation because it has nothing to do with
mounted vs unmounted. I'm looking at your attachment, and it only
shows "some devices missing" when you use the -d flag. It doesn't
matter whether the fs is mounted or not, -d always produces "some
devices missing" and without -d it doesn't. And I don't have an
explanation for that.

I suggest you unmount the file system and do 'btrfs check' without
--repair and report the results, lets see if it tells us which devices
it thinks are missing still.




-- 
Chris Murphy

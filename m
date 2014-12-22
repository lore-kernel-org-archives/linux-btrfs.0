Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:46679 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaLVAZs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Dec 2014 19:25:48 -0500
Received: by mail-yh0-f52.google.com with SMTP id z6so1852283yhz.25
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Dec 2014 16:25:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANcfdL39NWs=go4LVY8vuqp7bqkKuoop2arzpJoEX7TY4wSGYw@mail.gmail.com>
References: <CANcfdL39NWs=go4LVY8vuqp7bqkKuoop2arzpJoEX7TY4wSGYw@mail.gmail.com>
Date: Sun, 21 Dec 2014 17:25:47 -0700
Message-ID: <CAJCQCtQ-DkJh5tg1gWuv6EW=enm66jx16jrtXhXiPvhauRnJ9w@mail.gmail.com>
Subject: Re: Uncorrectable errors on RAID-1?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 21, 2014 at 12:34 PM, constantine <costas.magnuse@gmail.com> wrote:
> Some months ago I had 6 uncorrectable errors. I deleted the files that
> contained them and then after scrubbing I had 0 uncorrectable errors.
> After some weeks I encountered new uncorrectable errors.
>
> Question 1:
> Why do I have uncorrectable errors on a RAID-1 filesystem in the first place?
>
> Question 2:
> How do I properly correct them? (Again by deleting their files? :( )
>
> Question 3:
> How do I prevent this from happening?

There are multiple kinds of uncorrectable errors so it depends on the
exact error. If Btrfs is reporting uncorrectable errors, then that
suggests both copies are bad.

Whether md, LVM, or Btrfs raid, make sure the value for

cat /sys/block/sdX/device/timeout

is larger than the value reported by

smartctl -l scterc /dev/sdX

Not that units for the first command are seconds, the units for the
second command are demiseconds. For the kernel to automatically fix
bad sectors by overwriting them, the drive needs to explicitly report
read errors. If the SCSI command timer value is shorter than the
drive's error recovery, the SATA link might get reset before the drive
reports the read error and then uncorrected errors will persist
instead of being automatically fixed.

-- 
Chris Murphy

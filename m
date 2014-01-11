Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:53101 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbaAKRKg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jan 2014 12:10:36 -0500
Received: by mail-pd0-f174.google.com with SMTP id w10so1127451pde.5
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jan 2014 09:10:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140111150454.GV15634@carfax.org.uk>
References: <CAE8gLh=drhPtUXSbT7zHDSh7pipxuZpVhfuRQ7QOFV+HP4wHPQ@mail.gmail.com>
	<20140111150454.GV15634@carfax.org.uk>
Date: Sat, 11 Jan 2014 18:10:35 +0100
Message-ID: <CAE8gLhnd8mjRZoJCCj8ns4W6OJJXFGUiO8Ni78aYbyY2MA_Luw@mail.gmail.com>
Subject: Re: BTRFS over LVM remounts read-only
From: MegaBrutal <megabrutal@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014/1/11 Hugo Mills <hugo@carfax.org.uk>:
>
> [60631.481913] attempt to access beyond end of device
> [60631.481935] dm-1: rw=1073, want=42917896, limit=42917888
> [60631.481941] btrfs_dev_stat_print_on_error: 34 callbacks suppressed
> [60631.481949] btrfs: bdev /dev/mapper/vmhost--vg-vmhost--rootfs errs: wr 311347, rd 0, flush 0, corrupt 0, gen 0
>
>    This is the problem.
>
>    It looks like you've shrunk the LV without first shrinking the
> filesystem. Depending on how much you shrunk it by, the odds are
> fairly good that significant chunks of the FS are now toast.
>
>    Hugo.
>

Thank you very much! Strange, I indeed shrinked the LV, but only by a
few megabytes to make space for /boot (as turned out, GRUB2 can't boot
from LVM), and I think I did shrink the FS too... But maybe not. As it
started out as a test system, I intentionally wanted to test some
obscure situations here. Thankfully I don't have considerable data
loss and I don't think any valuable data was on the space that was cut
off. Strange that the system was running like this for a month with
this problem being undetected.

How can I shrink the FS to the correct size right now, ensuring that I
really shrink it to the exact LV size?

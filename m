Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from datenkhaos.de ([81.89.99.198]:52435 "EHLO datenkhaos.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbaIOROE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 13:14:04 -0400
Date: Mon, 15 Sep 2014 19:13:58 +0200
From: Johannes Hirte <johannes.hirte@datenkhaos.de>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: "Btrfs: device_list_add() should not update list when mounted"
 breaks subvol mount
Message-ID: <20140915191358.373f7e3a@datenkhaos.de>
In-Reply-To: <pan$654be$d6b1d475$33035c3b$be242b8b@cox.net>
References: <20140911002241.201bc6c2@datenkhaos.de>
	<54110AEC.6040301@oracle.com>
	<54135AE7.40400@gmail.com>
	<5413D7E5.6080905@oracle.com>
	<20140913195525.333f93a4@datenkhaos.de>
	<20140913232320.64fd189c@datenkhaos.de>
	<pan$654be$d6b1d475$33035c3b$be242b8b@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 14 Sep 2014 00:45:49 +0000 (UTC)
Duncan <1i5t5.duncan@cox.net> wrote:

> Johannes Hirte posted on Sat, 13 Sep 2014 23:23:20 +0200 as excerpted:
> 
> > On Sat, 13 Sep 2014 19:55:25 +0200 Johannes Hirte
> > <johannes.hirte@datenkhaos.de> wrote:
> > 
> >> On Sat, 13 Sep 2014 13:36:37 +0800 Anand Jain
> >> <Anand.Jain@oracle.com> wrote:
> >> 
> >>> The quickest workaround for you will be to try to match
> >>> the device path as in the btrfs fi show -m </mnt> output to your
> >>> probably fstab/mnttab entry.
> >> 
> >> Doesn't work here. I don't even get a path with the affected
> >> kernels. I'll get:
> >> 
> >> Label: none  uuid: 02edbd6b-f044-4800-b21e-ca8982c2c2e5
> >>         Total devices 1 FS bytes used 270.10GiB
> >>         *** Some devices missing
> >> 
> >> Btrfs v3.16
> >> 
> >> with a working kernel:
> >> 
> >> Label: none  uuid: 02edbd6b-f044-4800-b21e-ca8982c2c2e5
> >>         Total devices 1 FS bytes used 270.10GiB
> >>         devid  1 size 293.89GiB used 289.06GiB path /dev/sda1
> >> 
> >> Btrfs v3.16
> 
> >> And now I was able to reproduce on a second machine. The main
> >> difference between the affected and the unaffected systems is
> >> initramfs. On the affected systems, I don't use one. On the working
> >> systems, the rootfs is mounted via initramfs before. I'll test, if
> >> an initramfs will solve the issue. Seems likely, cause if I put
> >> the disk of an affected system into a working system and mount it
> >> there, everything works.
> > 
> > Of course, with the initramfs it works.
> 
> I see a btrfs device scan in the initramfs script.  What happens if
> you simply run btrfs device scan manually, before doing btrfs
> filesystem show?
> 
> I'm guessing that'll fix it.

Not tested, but I doubt it will fix it. In this initramfs it is a
leftover from a time, when the system was multi-device. On two other
systems, initramfs works without the scan. Additionally I can put the
affected HDD from the laptop and put it into/on another system, that is
affected without initramfs. I can mount it there without any scan
before. But I'm not 100% sure if udev takes responsibility for scanning
here.

regards,
  Johannes

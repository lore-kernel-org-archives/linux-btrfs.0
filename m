Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:36122 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933210AbbIYUr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 16:47:27 -0400
Received: by vkfp126 with SMTP id p126so63312199vkf.3
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2015 13:47:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5605ADE4.5090800@mur.at>
References: <560409E7.5020500@mur.at>
	<CAJCQCtQ3aSfHE3o4nyaKOJjDbxiw87GHW6_JdBC1vnDgQXgGKA@mail.gmail.com>
	<CAJCQCtRMumq4=QqujuOxu6nC0W+6dv1tWzqe8fCzzEEa-D+1ZQ@mail.gmail.com>
	<5605ADE4.5090800@mur.at>
Date: Fri, 25 Sep 2015 14:47:26 -0600
Message-ID: <CAJCQCtTaagpqurnjLeN7Mw8oBv59uWYtMbOb5REo8NgiP+UjjA@mail.gmail.com>
Subject: Re: strange i/o errors with btrfs on raid/lvm
From: Chris Murphy <lists@colorremedies.com>
To: =?UTF-8?Q?Jogi_Hofm=C3=BCller?= <jogi@mur.at>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 25, 2015 at 2:26 PM, Jogi Hofmüller <jogi@mur.at> wrote:

> That was right while the RAID was in degraded state and rebuilding.

On the guest:

Aug 28 05:17:01 vm kernel: [140683.741688] BTRFS info (device vdc):
disk space caching is enabled
Aug 28 05:17:13 vm kernel: [140695.575896] BTRFS warning (device vdc):
block group 13988003840 has wrong amount of free space
Aug 28 05:17:13 vm kernel: [140695.575901] BTRFS warning (device vdc):
failed to load free space cache for block group 13988003840, rebuild
it now
Aug 28 05:17:13 vm kernel: [140695.626035] BTRFS warning (device vdc):
block group 17209229312 has wrong amount of free space
Aug 28 05:17:13 vm kernel: [140695.626039] BTRFS warning (device vdc):
failed to load free space cache for block group 17209229312, rebuild
it now
Aug 28 05:17:13 vm kernel: [140695.683517] BTRFS warning (device vdc):
block group 20430454784 has wrong amount of free space
Aug 28 05:17:13 vm kernel: [140695.683521] BTRFS warning (device vdc):
failed to load free space cache for block group 20430454784, rebuild
it now
Aug 28 05:17:13 vm kernel: [140695.822818] BTRFS warning (device vdc):
block group 68211965952 has wrong amount of free space
Aug 28 05:17:13 vm kernel: [140695.822822] BTRFS warning (device vdc):
failed to load free space cache for block group 68211965952, rebuild
it now



On the host, there are no messages that correspond to this time index,
but a bit over an hour and a half later are when there are sas error
messages, and the first reported write error.

I see the rebuild event starting:

Aug 28 07:04:23 host mdadm[2751]: RebuildStarted event detected on md
device /dev/md/0

But there are subsequent sas errors still, including hard resetting of
the link, and additional read errors. This continues more than once...

And then

Aug 28 17:06:49 host mdadm[2751]: RebuildFinished event detected on md
device /dev/md/0, component device  mismatches found: 2048 (on raid
level 10)
Aug 28 17:06:49 host mdadm[2751]: SpareActive event detected on md
device /dev/md/0, component device /dev/sdd1

and also a number of SMART warnings about seek error on another device

Aug 28 17:35:55 host smartd[3146]: Device: /dev/sda [SAT], SMART Usage
Attribute: 7 Seek_Error_Rate changed from 180 to 179


So it sounds like more than one problem, either two drives, or maybe
even a controller problem, I can't really tell as there are lots of
messages.

But 2048 mismatches found after a rebuild is a problem. So there's
already some discrepancy in the mdadm raid10. And mdadm raid1 (or 10)
cannot resolve mismatches because which block is correct is ambiguous.
So that means something is definitely going to get corrupt. Btrfs, if
the metadata profile is DUP can recover from that. But data can't.
Normally this results in an explicit Btrfs message about a checksum
mismatch and no ability to fix it, but will still report the path to
affected file.  But I'm not finding that.

Anyway, if the hardware errors are resolved, try doing a scrub on the
file system, maybe when there's a period of reduced usage, to make
sure data and metadata are OK.

And then you could also manually reset the free space cache by
umounting and then remounting with -o clear_cache. This is a one time
thing, you do not need to remount.



-- 
Chris Murphy

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45936 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415Ab2IQWqa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 18:46:30 -0400
Received: by bkwj10 with SMTP id j10so2805284bkw.19
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2012 15:46:29 -0700 (PDT)
MIME-Version: 1.0
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 18 Sep 2012 00:46:08 +0200
Message-ID: <CAPXgP10p_26o3Xw9UEqaPs5=1VAZNkFqZnkXmphzvapcSca5ZQ@mail.gmail.com>
Subject: BTRFS_IOC_DEVICES_READY and removed devices
To: btrfs <linux-btrfs@vger.kernel.org>
Cc: Lennart Poettering <lennart@poettering.net>,
        Harald Hoyer <harald@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We are currently playing around with native btrfs multi-device support
in systemd. We already committed the needed pieces to systemd git, to
register all detected btrfs filesystems with the kernel.

For volumes which are listed in fstab for mounting, we delay the
actual mount-attempt of a multi-device volume until we see READY
returned from BTRFS_IOC_DEVICES_READY. A line with UUID= in /etc/fstab
with "nofail" in the options field, and we can boot up without any
device plugged in. Now plugging in devices one-after-the-other until
the volume has a full tree of devices; with the last device there,
systemd just mounts the volume as expected.

This seems to work very well so far, unless a device which is already
registered disappears, which is a kind of valid hotplug scenario we
should handle better:

If one device of a 2-device volume is registered with the in-kernel
cache, and then the device is unplugged from the system, the cache
state does not get updated. If then the other device of the 2-device
volume is registered, BTRFS_IOC_DEVICES_READY indicates ready; but in
fact only one of two needed devices are available at that time, and
mounting fails.

Can we somehow subscribe to device media-changes/removal to prevent
the stale device state in the in-kernel cache?

Or alternatively make BTRFS_IOC_DEVICES_READY re-validate all involved
block devices before it returns READY?

Thanks,
Kay

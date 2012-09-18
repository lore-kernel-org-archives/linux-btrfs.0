Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:43183 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab2IRNJG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 09:09:06 -0400
Date: Tue, 18 Sep 2012 09:09:03 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Kay Sievers <kay@vrfy.org>
CC: btrfs <linux-btrfs@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        Harald Hoyer <harald@redhat.com>
Subject: Re: BTRFS_IOC_DEVICES_READY and removed devices
Message-ID: <20120918130903.GA2272@localhost.localdomain>
References: <CAPXgP10p_26o3Xw9UEqaPs5=1VAZNkFqZnkXmphzvapcSca5ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAPXgP10p_26o3Xw9UEqaPs5=1VAZNkFqZnkXmphzvapcSca5ZQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 17, 2012 at 04:46:08PM -0600, Kay Sievers wrote:
> We are currently playing around with native btrfs multi-device support
> in systemd. We already committed the needed pieces to systemd git, to
> register all detected btrfs filesystems with the kernel.
> 
> For volumes which are listed in fstab for mounting, we delay the
> actual mount-attempt of a multi-device volume until we see READY
> returned from BTRFS_IOC_DEVICES_READY. A line with UUID= in /etc/fstab
> with "nofail" in the options field, and we can boot up without any
> device plugged in. Now plugging in devices one-after-the-other until
> the volume has a full tree of devices; with the last device there,
> systemd just mounts the volume as expected.
> 
> This seems to work very well so far, unless a device which is already
> registered disappears, which is a kind of valid hotplug scenario we
> should handle better:
> 
> If one device of a 2-device volume is registered with the in-kernel
> cache, and then the device is unplugged from the system, the cache
> state does not get updated. If then the other device of the 2-device
> volume is registered, BTRFS_IOC_DEVICES_READY indicates ready; but in
> fact only one of two needed devices are available at that time, and
> mounting fails.
> 
> Can we somehow subscribe to device media-changes/removal to prevent
> the stale device state in the in-kernel cache?
> 
> Or alternatively make BTRFS_IOC_DEVICES_READY re-validate all involved
> block devices before it returns READY?

Hrm excellent question, I'll look at what options we have in kernel to check and
see if a device is still present and figure something out.  Thanks,

Josef

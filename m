Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17.italiaonline.it ([212.48.25.145]:41138 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751569AbbFNToY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Jun 2015 15:44:24 -0400
Message-ID: <557DD993.9080803@inwind.it>
Date: Sun, 14 Jun 2015 21:44:19 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: Goffredo Baroncelli <kreijack@libero.it>
MIME-Version: 1.0
To: systemd-devel@lists.freedesktop.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>, 1i5t5.duncan@cox.net
Subject: Re: [systemd-devel] [survey] BTRFS_IOC_DEVICES_READY return status
References: <557ADBAE.9040407@oracle.com> <20150612210453.3dee4563@opensuse.site> <557B3C32.9030707@inwind.it> <557BF979.9040106@oracle.com> <557C479F.2070403@libero.it> <pan$63061$a3cdf5f6$a390adbd$e6097ad9@cox.net>
In-Reply-To: <pan$63061$a3cdf5f6$a390adbd$e6097ad9@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-06-14 06:05, Duncan wrote:
> Goffredo Baroncelli posted on Sat, 13 Jun 2015 17:09:19 +0200 as
> excerpted:
> 
>> My attempt followed a different idea: the mount helper waits the devices
>> if needed, or if it is the case it mounts the filesystem in degraded
>> mode.
>> All devices are passed as mount arguments (--device=/dev/sdX), there is
>> no a device registration: this avoids all these problems.
>>
>> [*] http://permalink.gmane.org/gmane.comp.file-systems.btrfs/40767
> 
> But /dev/sdX doesn't always work, because, for instance, my usual /dev/sdb 
> was slow to respond on my last boot, and currently appears as /dev/sdf, 
> with sdb/c/d/e being my (multi-type) sdcard, etc, adapter, medialess.

Please give a look to my patch.

You may mount the filesystem in different way:
- by device (/dev/sdxxx)
- by UUID (UUID=)
- by LABEL (LABEL=)

The helper finds the right devices and (eventually) waits for the other devices.
When it has collected all the devices, these are passed to the kernel via 
the "device=/dev/sdx" mount option. So the registration would not be needed anymore.

> 
> Tho if /dev/disk/by-*/* works, I could use that.  Tho AFAIK it's udev 
> that fills that in, so udev would be necessary.

I never wrote that udev is not necessary. I think only that relying to udev
to handling a multi-volume filesystem is too complicated. The responsibility 
is spread in too much layer.



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

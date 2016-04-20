Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16692 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbcDTNcg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Apr 2016 09:32:36 -0400
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: Question: raid1 behaviour on failure
To: Matthias Bodenbinder <matthias@bodenbinder.de>,
        linux-btrfs@vger.kernel.org
References: <nf1q0j$ug4$1@ger.gmane.org> <57148B2E.6010904@cn.fujitsu.com>
 <nf73cv$7vh$1@ger.gmane.org>
Message-ID: <571784DF.3060800@oracle.com>
Date: Wed, 20 Apr 2016 21:32:15 +0800
MIME-Version: 1.0
In-Reply-To: <nf73cv$7vh$1@ger.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> 1. mount the raid1 (2 disc with different size)

> 2. unplug the biggest drive (hotplug)

   Btrfs won't know that you have plugged-out a disk.
   Though it experiences IO failures, it won't close the bdev.

> 3. try to copy something to the degraded raid1

   This will work as long as you do _not_ run unmount/mount.

   However once you umount/mount you won't be able to mount
   even with -o degraded option. (there are some workaround
   patches in the ML)

> 4. plugin the device again (hotplug)

   This is a bad test case.

   - Since btrfs didn't close the device, at #2 above, the block
   layer will create a new device instance and path when you plug-in
   the device.

   And when btrfs will promptly scan the device and update its
   records. But note that its still using the old bdev. And
   you will continue to see the IO errors. And no IO will go
   to the new device instance.

   There are patches in the ML under tests which will force
   close the device upon loosing access to the device. As a
   first step.



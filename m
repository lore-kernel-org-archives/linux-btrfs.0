Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.linuxsystems.it ([2.119.245.46]:56650 "EHLO
	mail2.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbcEDJqT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 05:46:19 -0400
Received: from localhost (unknown [192.168.1.189])
	by mail2.linuxsystems.it (Postfix) with ESMTPSA id 20302A3EBE
	for <linux-btrfs@vger.kernel.org>; Wed,  4 May 2016 11:46:12 +0200 (CEST)
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: <linux-btrfs@vger.kernel.org>
Subject: /etc/fstab rootfs options vs grub2 rootflags cmdline
Date: Wed, 04 May 2016 11:46:10 +0200
MIME-Version: 1.0
Message-ID: <79249c4d-eab0-43fa-a6ae-b670699891dc@linuxsystems.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I have the following options for my rootfs in /etc/fstab:
rw,relatime,compress=lzo,ssd,discard,space_cache,autodefrag,subvolid=257,subvol=/@

grub2 already placed rootflags=subvol=@ in its cmdline, but not the other 
options. I suppose that some of them will automatically be set during 
remount, but I'm not sure if all of them will.

Do you know which ones should I manually add to GRUB_CMDLINE_LINUX in 
/etc/default/grub?

Is there any way to check to if they are already enabled?
mount shows /dev/mapper/cryptroot on / type btrfs 
(rw,relatime,compress=lzo,ssd,discard,space_cache,autodefrag,subvolid=257,subvol=/@) 
but I'm not sure if I can trust it: I read that space_cache should trigger 
"enabling free space tree" in dmesg but I can't see it and I don't know 
about the others.

Thanks,
Niccolò

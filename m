Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.linuxsystems.it ([2.119.245.46]:57486 "EHLO
	mail2.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbcEDNwq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 09:52:46 -0400
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: <linux-btrfs@vger.kernel.org>
Cc: Duncan <1i5t5.duncan@cox.net>
Subject: Re: /etc/fstab rootfs options vs grub2 rootflags cmdline
Date: Wed, 04 May 2016 15:52:39 +0200
MIME-Version: 1.0
Message-ID: <f8233c24-e336-4d31-a4cb-f3b0f97d1305@linuxsystems.it>
In-Reply-To: <pan$7b1b$2e968d2f$7ddc7045$1ba7386@cox.net>
References: <79249c4d-eab0-43fa-a6ae-b670699891dc@linuxsystems.it>
 <pan$7b1b$2e968d2f$7ddc7045$1ba7386@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks,
Now my fstab option are 
rw,noatime,compress=lzo,discard,autodefrag,subvolid=257,subvol=/@
I tried to add rootflags=noatime,compress=lzo,discard,autodefrag to 
GRUB_CMDLINE_LINUX in /etc/default/grub as you suggested but my system 
didn't manage to boot, probably because grub automatically adds 
rootflags=subvol=@ and only a single rootflags can be taken into account. 
Do you have any suggestion?

Niccolò

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:57345 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813AbbCVVPx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Mar 2015 17:15:53 -0400
Message-ID: <550F3103.7080609@arcor.de>
Date: Sun, 22 Mar 2015 22:15:47 +0100
From: Ochi <ochi@arcor.de>
MIME-Version: 1.0
To: rbellamy@pteradigm.com
CC: linux-btrfs@vger.kernel.org
Subject: Upgrade to 3.19.2 Kernel fails to boot
References: <CADw2B2Nxr5PPSaVWpQWxg0ZaXYSpOTye_pMU1HbjCHif8q9_LQ@mail.gmail.com>
In-Reply-To: <CADw2B2Nxr5PPSaVWpQWxg0ZaXYSpOTye_pMU1HbjCHif8q9_LQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> When I upgrade to the 3.19.2 Kernel I get a deadlocked boot:
> INFO: task mount:302 blocked for more than 120 seconds.
> INFO: task btrfs-transacti:329 blocked for more than 120 seconds.

I had a similar behavior today after I accidentally pulled the power 
plug of my machine (Arch Linux, Kernel 3.19.2). I tried to boot several 
times, but "mount" timed out. I booted into a recovery Arch Linux with a 
3.18 kernel and my root filesystem mounted without any problems. 
Unmounted, ran btrfs check, no errors. After reboot, the filesystem 
mounted normally with 3.19.2 again! I tried to reproduce this behavior 
on another machine, but so far to no avail.

I'm afraid I wasn't able to gather more debug info. Some more general 
info: I'm using btrfs on top of dm-crypt (LUKS), my root is on a SSD, 
and I'm using rw,noatime,ssd,discard,space_cache as mount options.

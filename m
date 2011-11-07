From: dima <dolenin@parallels.com>
Subject: How to remount btrfs without compression?
Date: Mon, 7 Nov 2011 09:53:47 +0900
Message-ID: <4EB72C1B.1030702@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Is there any possibility to remount a compressed btrfs without any 
compression at all?

Syslinux bootloader does not understand any btrfs compression and 
whenever I edit syslinux.cfg on my compressed / subvolume, the file 
becomes compressed and thus unreadable by syslinux on the next boot.

I tried to remount / without the 'compress' option (and edit 
syslinux.cfg in uncompressed state) and while the "mount" command would 
not show compression any more, I can see in the /proc/mounts that 
compression is still there and the file still gets compressed after 
editing. But there seem to be no mount option like compress=none or 
something.

The only workaround I found is to boot from a live CD mount / without 
any compression and re-save syslinux.cfg. Then it the file gets 
uncompressed.

Are there any other options except for this workaround to temporarily 
remount btrfs without compression?

thanks

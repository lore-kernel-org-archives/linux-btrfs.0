Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx009.vodafonemail.xion.oxcs.net ([153.92.174.39]:56437 "EHLO
        mx009.vodafonemail.xion.oxcs.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750935AbdEMP3A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 May 2017 11:29:00 -0400
To: arvidjaar@gmail.com
References: <2f1e52d4-ca30-3623-1ea7-a046bee18bda@gmail.com>
Subject: Re: Creating btrfs RAID on LUKS devs makes devices disappear
From: Ochi <ochi@arcor.de>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <161080bd-1a3f-180f-3119-ccf8fde4a498@arcor.de>
Date: Sat, 13 May 2017 17:28:52 +0200
MIME-Version: 1.0
In-Reply-To: <2f1e52d4-ca30-3623-1ea7-a046bee18bda@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

okay, I think I now have a repro that is stupidly simple, I'm not even 
sure if I overlook something here. No multi-device btrfs involved, but 
notably it does happen with btrfs, but not with e.g. ext4.

[Sidenote: At first I thought it had to do with systemd-cryptsetup 
opening multiple devices with the same key that makes a difference. 
Rationale: I think the whole systemd machinery for opening crypt devices 
is able to try the same password on multiple devices when manual 
keyphrase input is used, and I thought maybe the same is true for 
keyfiles which may cause race conditions, but after all it doesn't seem 
to matter much. Also it seemed to relate to multi-device btrfs volumes, 
but now it appears to be simpler than that. That said, I can't be sure 
whether there are more problems hidden when actually using RAID.]

I have tried to repro the issue on a completely fresh Arch Linux in a 
VirtualBox VM. No custom systemd magic involved whatsoever, all stock 
services, generators, etc. In addition to the root volume (no crypto), 
there is another virtual HDD with one partition. This is a LUKS 
partition with a keyfile added to open it automatically on boot. I added 
a corresponding /etc/crypttab line as follows:

     storage0    /dev/sdb1    /etc/crypto/keyfile

Let's suppose we open the crypt device manually the first time and 
perform mkfs.btrfs on the /dev/mapper/storage0 device. Reboot the system 
such that systemd-cryptsetup can do its magic to open the dm device.

After reboot, log in. /dev/mapper/storage0 should be there, and of 
course the corresponding /dev/dm-*. Perform another mkfs.btrfs on 
/dev/mapper/storage0. What I observe is (possibly try multiple times, 
but it has been pretty reliable in my testing):

- /dev/mapper/storage0 and the /dev/dm-* device are gone.

- A process systemd-cryptsetup is using 100% CPU (haven't noticed 
before, but now on my laptop I can actually hear it)

- The dm-device was eliminated by systemd, see the logs below.

- Logging out and in again (as root in my case) solves the issue, the 
device is back.

I have prepared outputs of journalctl and udevadm info --export-db 
produced after the last step (logging out and back in). Since the logs 
are quite large, I link them here, I hope that is okay:

https://pastebin.com/1r6j1Par
https://pastebin.com/vXLGFQ0Z

In the journal, the interesting spots are after the two "ROOT LOGIN ON 
tty1". A few seconds after the first one, I performed the mkfs.

Notably, it doesn't seem to happen when using e.g. ext4 instead of 
btrfs. Also, it doesn't happen when opening the crypt device manually, 
without crypttab and thus without systemd-cryptsetup, 
systemd-cryptsetup-generator, etc. which parses crypttab.

So after all, I suspect the systemd-cryptsetup to be the culprit in 
combination with btrfs volumes. Maybe someone can repro that.

Versions used in the VM:
- Current Arch Linux
- Kernel 4.10.13
- btrfs-progs 4.10.2
- systemd v232 (also tested v233 from testing repo with same results)

Hope this helps
Sebastian

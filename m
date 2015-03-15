Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33505 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbbCOJJv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Mar 2015 05:09:51 -0400
Received: by pdnc3 with SMTP id c3so28247277pdn.0
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Mar 2015 02:09:50 -0700 (PDT)
Subject: Re: Is it safe or useful to use NOCOW flag and autodefrag mount option at same time?
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <trinity-2997a6a9-13e0-4df6-ae13-0d944bd2f0b1-1426358188246@3capp-gmx-bs46>
Date: Sun, 15 Mar 2015 17:09:43 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <C879D0AA-018D-4C52-94F8-37D322F8DCD4@gmail.com>
References: <trinity-2997a6a9-13e0-4df6-ae13-0d944bd2f0b1-1426358188246@3capp-gmx-bs46>
To: peer.loz@gmx.net
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> 
> Hi,
> first of all a great thank you to all developers and contributors. The
> Btrfs filesystem ist a great filesystem!
> 
> Following common recommendations [1], I use these mount options on my
> main developing machine: noatime,autodefrag. This is desktop machine and
> it works well so far. Now, I'm also going to install several KVM virtual
> machines on this system. I want to use qcow2 files stored on SSD with a
> btrfs on it. In order to avoid bad performance with the VMs, I want to
> disable the Copy-On-Write mechanism on the storage directory of my VM
> images as for example described in [2].
> 
> My question now is: Is it safe to use the autodefrag mount option and to
> disable CoW for single directories which contain VM files at the same
> time? Is it even useful or may it harm?
> 
> Thank you very much for insights and comments in advance.

Btrfs use COW feautr to do defrag, acutally there was bug in the past
(nocow and defrag)..

But make sure your kernel include following commit:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=47059d930f0e002ff851beea87d738146804726d

With above commit, i think autodefrag should work well with nocow.

Best regards,
Wang Shilong

> 
> Best regards,
> jploz
> 
> 
> As requested in the wiki basic information about my fresh setup attached:
> uname -a
> Linux hostname 3.16.0-4-686-pae #1 SMP Debian 3.16.7-ckt7-1 (2015-03-01) i686 GNU/Linux
> 
> btrfs --version
> Btrfs v3.17
> 
> btrfs fi show
> Label: none  uuid: cc6492e7-a7a7-43f9-bba2-a1abe8635d36
> 	Total devices 1 FS bytes used 4.00GiB
> 	devid    1 size 210.00GiB used 8.02GiB path /dev/sdb2
> 
> Label: 'DataHddBtr'  uuid: aa3f41c0-5a60-4fd7-9365-8c99284e032c
> 	Total devices 1 FS bytes used 384.00KiB
> 	devid    1 size 480.00GiB used 2.04GiB path /dev/sda1
> 
> Btrfs v3.17
> 
> mount | grep btrfs
> /dev/sdb2 on / type btrfs (rw,noatime,ssd,space_cache,autodefrag)
> /dev/sda1 on /data/btr type btrfs (rw,noatime,space_cache,autodefrag)
> 
> btrfs fi df /
> Data, single: total=7.01GiB, used=3.89GiB
> System, single: total=4.00MiB, used=16.00KiB
> Metadata, single: total=1.01GiB, used=114.39MiB
> GlobalReserve, single: total=48.00MiB, used=0.00B
> 
> btrfs fi df /data/btr/
> Data, single: total=8.00MiB, used=256.00KiB
> System, DUP: total=8.00MiB, used=16.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, DUP: total=1.00GiB, used=112.00KiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=16.00MiB, used=0.00B
> 
> dmesg | grep -i btrfs
> [    2.693408] Btrfs loaded
> [    2.756178] BTRFS: device fsid cc6492e7-a7a7-43f9-bba2-a1abe8635d36 devid 1 transid 393 /dev/sdb2
> [    2.756843] BTRFS: device label DataHddBtr devid 1 transid 9 /dev/sda1
> [    2.775447] BTRFS info (device sdb2): disk space caching is enabled
> [    2.779944] BTRFS: detected SSD devices, enabling SSD mode
> [    3.430997] BTRFS info (device sdb2): enabling auto defrag
> [    3.431002] BTRFS info (device sdb2): disk space caching is enabled
> [    3.548937] BTRFS info (device sda1): enabling auto defrag
> [    3.548939] BTRFS info (device sda1): disk space caching is enabled
> [  183.341398] BTRFS info (device sda1): enabling auto defrag
> [  183.341403] BTRFS info (device sda1): disk space caching is enabled
> 
> 
> References:
> [1] https://btrfs.wiki.kernel.org/index.php/Gotchas
> [2] https://wiki.archlinux.org/index.php/Btrfs#Copy-On-Write_.28CoW.29
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Best Regards,
Wang Shilong


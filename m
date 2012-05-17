Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57691 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754657Ab2EQQKZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 12:10:25 -0400
Received: by lahd3 with SMTP id d3so1427900lah.19
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2012 09:10:23 -0700 (PDT)
Message-ID: <4FB522EC.50305@gmail.com>
Date: Thu, 17 May 2012 20:10:20 +0400
From: "Sergey E. Kolesnikov" <rockingdemon@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: trim malfunction in linux 3.3.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello.
I've been running Ubuntu 12.04 kernel and btrfs on two partitions of two 
GPT partitioned SSDs. Rootfs was btrfs subvol "@" and homes were at 
"@home". When I was batch trimming with "fstrim /" using Ubuntu's 
standard kernel 3.2.0 - everything was fine. Then I compiled vanilla 
3.3.6 kernel ad tried to fstrim again, fs got severely damaged.

It seems that batch trim miscalculates ranges and trims some occupied 
space. Can't say if GPT or other partitioning details matter.

I will try to provide any info possible, but fs is trimmed badly, and I 
need this machine to be up and running, so will have to mkfs.btrfs again 
and use 3.2.0 kernel.

Steps that caused corruption:
1. Created partitions on two (say /dev/sd[ab]) SSD drives with about 1G 
offset from the beginning (first partition is ext4 for /boot)
2. mkfs.btrfs /dev/sd[ab]2
3. created subvolumes "@" and "@home" for mountpoints "/" and "/home" 
respectively
4. installed xubuntu 12.04
5. fstrim /
6. everything is ok
7. compiled and installed vanilla 3.3.6 kernel
8. reboot into 3.3.6
9. btrfs scrub - ok
10. fstrim /
11. fs got baaadly corrupted

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vps01.maxiapps.eu ([212.44.99.234]:57815 "EHLO
	vps01.maxiapps.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751177AbaBDP6Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Feb 2014 10:58:25 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by vps01.maxiapps.eu (Postfix) with ESMTP id 6FDCD358A15D
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Feb 2014 18:52:14 +0300 (MSK)
Received: from vps01.maxiapps.eu ([127.0.0.1])
	by localhost (vps01.maxiapps.eu [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id a62E35ApIo3z for <linux-btrfs@vger.kernel.org>;
	Tue,  4 Feb 2014 18:52:14 +0300 (MSK)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by vps01.maxiapps.eu (Postfix) with ESMTP id EB7B7358A15F
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Feb 2014 18:52:13 +0300 (MSK)
Received: from vps01.maxiapps.eu ([127.0.0.1])
	by localhost (vps01.maxiapps.eu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id O_QI35ZOvPgJ for <linux-btrfs@vger.kernel.org>;
	Tue,  4 Feb 2014 18:52:13 +0300 (MSK)
Received: from [192.168.139.5] (mail.laly.si [89.212.74.161])
	by vps01.maxiapps.eu (Postfix) with ESMTPSA id CC22F358A15D
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Feb 2014 18:52:13 +0300 (MSK)
Message-ID: <52F10CAC.5030306@laly.si>
Date: Tue, 04 Feb 2014 16:52:12 +0100
From: Blaz Balon <blaz.balon@laly.si>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Booting with syslinux not possible
References: <52EBFD82.7080900@gmail.com> <loom.20140131T225403-745@post.gmane.org>
In-Reply-To: <loom.20140131T225403-745@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I also had some problems with syslinux.

For me it only works if I put boot folder to root of btrfs.
Didn't have a chance to do more test, but I copied /boot from default 
subvolume to subvolume 0 and it boots OK.

----------
regards
Blaz Balon

On 01/31/2014 11:00 PM, Alex wrote:
> Sorry KC:
>
> All my VM's are on syslinux (actually extlinux) and btrfs:
>     Device Boot      Start         End      Blocks   Id  System
> /dev/vda1   *        2048     7938047     3968000   83  Linux
> /dev/vda2         7938048     8388607      225280   82  Linux swap / Solaris
>
> root@<VM> ~ # ll /boot
> total 19452
> -rw-r--r-- 1 root root  2319932 Jan 21 06:12 System.map-3.12-1-amd64
> -rw-r--r-- 1 root root   149029 Jan 21 06:12 config-3.12-1-amd64
> drwxr-xr-x 1 root root      176 Jan 28 22:32 extlinux/
> -rw-r--r-- 1 root root 14240605 Jan 28 22:32 initrd.img-3.12-1-amd64
> -rw-r--r-- 1 root root   176764 Nov 13  2011 memtest86+.bin
> -rw-r--r-- 1 root root   178944 Nov 13  2011 memtest86+_multiboot.bin
> -rw-r--r-- 1 root root  2842064 Jan 21 06:08 vmlinuz-3.12-1-amd64
> root@china ~ #
>
> Occasionally I get excited and decide to fix it 'til it breaks (usually I
> turn compression on, and /boot can't be accessed), but it's been working
> fine for a few years now.
>
> Kind regards.
>
> Al.
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


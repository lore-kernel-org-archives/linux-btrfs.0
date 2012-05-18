Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28998 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760110Ab2ERDjb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 23:39:31 -0400
Message-ID: <4FB5C563.9050203@cn.fujitsu.com>
Date: Fri, 18 May 2012 11:43:31 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: "Sergey E. Kolesnikov" <rockingdemon@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: trim malfunction in linux 3.3.6
References: <4FB522EC.50305@gmail.com>
In-Reply-To: <4FB522EC.50305@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/18/2012 12:10 AM, Sergey E. Kolesnikov wrote:

> Hello.
> I've been running Ubuntu 12.04 kernel and btrfs on two partitions of two
> GPT partitioned SSDs. Rootfs was btrfs subvol "@" and homes were at
> "@home". When I was batch trimming with "fstrim /" using Ubuntu's
> standard kernel 3.2.0 - everything was fine. Then I compiled vanilla
> 3.3.6 kernel ad tried to fstrim again, fs got severely damaged.
> 
> It seems that batch trim miscalculates ranges and trims some occupied
> space. Can't say if GPT or other partitioning details matter.
> 
> I will try to provide any info possible, but fs is trimmed badly, and I
> need this machine to be up and running, so will have to mkfs.btrfs again
> and use 3.2.0 kernel.
> 
> Steps that caused corruption:
> 1. Created partitions on two (say /dev/sd[ab]) SSD drives with about 1G
> offset from the beginning (first partition is ext4 for /boot)
> 2. mkfs.btrfs /dev/sd[ab]2
> 3. created subvolumes "@" and "@home" for mountpoints "/" and "/home"
> respectively
> 4. installed xubuntu 12.04
> 5. fstrim /
> 6. everything is ok
> 7. compiled and installed vanilla 3.3.6 kernel
> 8. reboot into 3.3.6
> 9. btrfs scrub - ok
> 10. fstrim /
> 11. fs got baaadly corrupted


Could you please show some logs about the corrpution?

I'll try to reproduce it on my own box. ;)

thanks,
liubo

> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



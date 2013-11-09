Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:34417 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3KIKza (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Nov 2013 05:55:30 -0500
Message-ID: <527E149F.3090001@inwind.it>
Date: Sat, 09 Nov 2013 11:55:27 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Lester B <b.lester011+btrfs@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs resize problem after device add/delete
References: <CAOeUAF_80gVV-uDAw1Z_kQreOze-mW6uUCSheM_eBb_TYq_fuw@mail.gmail.com>
In-Reply-To: <CAOeUAF_80gVV-uDAw1Z_kQreOze-mW6uUCSheM_eBb_TYq_fuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013-11-08 23:09, Lester B wrote:
> I create a new btrfs filesystem and then add a new device and delete
> the original device. When I run 'btrfs filesystem show', the total
> device is two and there is an error that some devices are missing.

See my answer below.

> 
> I also tried to resize the filesystem but didn't work. Resizing
> without device id have an error that there is no such device. When the
> device id is explicitly pass, an error 'invalid argument' is
> displayed.

We need more info:
- what is the output of "btrfs filesystem df <path>"
- which is a raid level involved (RAID1/DUP/...), if any ?
- which command you perform to shrink/enlarge the partition and which
one to resize the filesystem (these are two separate steps) ?


> 
> I tried to unmount and then remount and the first problem disappeared
> while the second one didn't.

Unfortunately "btrfs filesystem show" read the data from the disk, that
time to time is outdated.

> 
> 3.11.6-1-ARCH #1 SMP PREEMPT Fri Oct 18 23:22:36 CEST 2013 x86_64 GNU/Linux
> 
> Btrfs v0.20-rc1-358-g194aa4a-dirty
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

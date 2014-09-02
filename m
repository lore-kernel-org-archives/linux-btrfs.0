Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56087 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751980AbaIBBdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Sep 2014 21:33:07 -0400
Message-ID: <54051E4F.1080102@cn.fujitsu.com>
Date: Tue, 2 Sep 2014 09:33:03 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, <remco@yerf-it.nl>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: find_mount_root() issue
References: <62013C11-1628-42C1-929B-24E46858D38B@yerf-it.nl> <pan$abcad$cae3304e$722c055b$e8898249@cox.net>
In-Reply-To: <pan$abcad$cae3304e$722c055b$e8898249@cox.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: find_mount_root() issue
From: Duncan <1i5t5.duncan@cox.net>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年08月31日 17:41
> Remco Hosman - Yerf IT.nl posted on Sun, 31 Aug 2014 09:37:38 +0200 as
> excerpted:
>
>> issue:
>> on my system i have 2 entries for /, one with the type ‘rootfs’ and a
>> 2nd one with the type ‘btrfs’. find_mount_root() uses the first one and
>> reports a fail.
>>
>> My change:
>> if (longest_matchlen < len) {
>> into:
>> if (longest_matchlen <= len) {
>>
>> i have not tested this, but in my understanding it will use the last
>> longest match instead of the first.
>>
>> I have no idea if this rootfs entry is normal nor if its always there
>> before the ‘proper’ one.
>>
>> These are the 2 entries in my mount list:
>> rootfs / rootfs rw 0 0
>> /dev/sda2 / btrfs rw,noatime,ssd,noacl,space_cache 0 0
> AFAIK that rootfs entry is the kernel's built-in initramfs that it
> automatically mounts, even if empty, before mounting your real-root.
>
> If you use an initramfs/initrd, the switch_root process normally hides/
> unmounts the initr*, but if you don't and the kernel is using its empty
> one, nothing hides/unmounts it, so it's still there after the normal / is
> mounted over top.
>
> At least, I always booted to root directly without an initr*, and always
> had a rootfs entry until relatively recently, presumably when I switched
> to a two-device btrfs real-rootfs, and had to create and use an initramfs
> to do so[1].  Now I don't have a rootfs entry any longer.
>
> ---
> [1] Initr* required for multi-device btrfs root: Btrfs has the device=
> mount option, which would normally be passed via a kernel-command-line
> rootflags= option to btrfs, that can be used with multi-device-
> filesystems in the absence of btrfs device scan.  Unfortunately,
> rootflags=device= fails for some reason, or at least did last time I
> tried it, so the only way I can get a multi-device btrfs root to mount is
> to use an initr*.
>
Interesting, as mentioned by Duncan, the normal situation is that initr* 
root should be hidden/unmounted.

But when things out of the normal track, like Remco's problem, current 
find_mount_root will only use
the first longest match, any further match will be ignored.
So (longest_matchlen <= len) is OK for this case.

On the other hand, (longest_matchlen <= len) will fail under the 
following situation:
/dev/sdb on /mnt/test type btrfs (rw,relatime,space_cache)
/dev/sdc on /mnt/test type ext4 (rw,relatime,data=ordered)

To fix the behavior , the correct fix seems to only return the mount 
entry with all the following condition:
1) longgest match
2) fs type is btrfs

If I am wrong, please tell me.

Thanks,
Qu

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:61306 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaBLKfJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 05:35:09 -0500
Received: by mail-we0-f172.google.com with SMTP id p61so5762630wes.31
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Feb 2014 02:35:08 -0800 (PST)
Message-ID: <52FB4E47.4070606@gmail.com>
Date: Wed, 12 Feb 2014 10:34:47 +0000
From: Leonidas Spyropoulos <artafinde@gmail.com>
MIME-Version: 1.0
To: Jakob Truelsen <antialize@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: No space left on device
References: <CAEhsiNw3hLSu8zPw44ndR1xQ-fjFrzaSCw3GDa=1vhCY3BypnA@mail.gmail.com>
In-Reply-To: <CAEhsiNw3hLSu8zPw44ndR1xQ-fjFrzaSCw3GDa=1vhCY3BypnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/02/2014 09:51, Jakob Truelsen wrote:
> Hello. I am experiencing "No space left on device" with a btrfs file
> system, yet I cannot seem to find any exhausted resource. Could some
> resource I do not know about be exhausted, or is this caused by
> something else. Below is a trace of information that might be usefull,
> please let me know if there is anything I can do to resolve the issue.
>
> /Jakob
>
> [jakobt@soda ~]$ uname -a
> Linux soda 3.12.8-1-ARCH #1 SMP PREEMPT Thu Jan 16 09:16:34 CET 2014
> x86_64 GNU/Linux
>
> [jakobt@soda ~]$ btrfs --version
> Btrfs v3.12
>
> [jakobt@soda ~]$ mount
> ...
> /dev/sda on /data type btrfs (rw,relatime,nospace_cache)
>
> [jakobt@soda ~]$ df /data
> Filesystem     1K-blocks     Used Available Use% Mounted on
> /dev/sdb2       76594224 49247368  23433028  68% /
>
> [jakobt@soda ~]$ btrfs filesystem df /data
> Data, single: total=1.82TiB, used=518.04GiB
> System, DUP: total=8.00MiB, used=204.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=1.00GiB, used=767.70MiB
> Metadata, single: total=8.00MiB, used=0.00
>
> [jakobt@soda ~]$ touch /data/jakobt/hat
> touch: cannot touch ‘/data/jakobt/hat’: No space left on device
>
> [jakobt@soda ~]$ sudo btrfs fi balance start /data
> ERROR: error during balancing '/data' - No space left on device
> There may be more info in syslog - try dmesg | tail
>
> [jakobt@soda ~]$ dmesg | grep tail -n 2
> [1113177.878157] btrfs: device label Data devid 1 transid 44784 /dev/sda
> [1113507.641752] btrfs: 1866 enospc errors during balance
>
> [jakobt@soda ~]$ sudo umount /data
>
> [jakobt@soda ~]$ sudo btrfsck /dev/sda
> ...
> cache and super generation don't match, space cache will be invalidated
> ..
> found 172181366447 bytes used err is 0
> total csum bytes: 418841160
> total tree bytes: 805187584
> total fs tree bytes: 247164928
> total extent tree bytes: 26329088
> btree space waste bytes: 164771401
> file data blocks allocated: 561564688384
>   referenced 511759908864
> Btrfs v3.12
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hello Jacob,

Have you tried balancing just the data/metadata chunks only?

Regards,
Leonidas

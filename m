Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20065 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753428AbcB2B5J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 20:57:09 -0500
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
To: Marc Haber <mh+linux-btrfs@zugschlus.de>, <linux-btrfs@vger.kernel.org>
References: <20160227211450.GS26042@torres.zugschlus.de>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56D3A56A.20809@cn.fujitsu.com>
Date: Mon, 29 Feb 2016 09:56:58 +0800
MIME-Version: 1.0
In-Reply-To: <20160227211450.GS26042@torres.zugschlus.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Marc Haber wrote on 2016/02/27 22:14 +0100:
> Hi,
>
> I have again the issue of no space left on device while rebalancing
> (with btrfs-tools 4.4.1 on kernel 4.4.2 on Debian unstable):
>
> mh@fan:~$ sudo btrfs balance start /mnt/fanbtr
> ERROR: error during balancing '/mnt/fanbtr': No space left on device

It seems that, only when balancing all chunks, ENOSPC error happens.

And did you run any other heavy IO at background?

BTW, is there any kernel log when the ENOSPC happens?

> mh@fan:~$ sudo btrfs fi show /mnt/fanbtr
> mh@fan:~$ sudo btrfs fi show -m
> Label: 'fanbtr'  uuid: 4198d1bc-e3ce-40df-a7ee-44a2d120bff3
>          Total devices 1 FS bytes used 116.49GiB
>          devid    1 size 417.19GiB used 177.06GiB path /dev/mapper/fanbtr
> mh@fan:~$ sudo btrfs fi df /mnt/fanbtr
> Data, single: total=113.00GiB, used=112.77GiB
> System, DUP: total=32.00MiB, used=48.00KiB
> Metadata, DUP: total=32.00GiB, used=3.72GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> mh@fan:~$
>
> The filesystem was recently resized from 300 GB to 420 GB.
>
> Why does btrfs fi show /mnt/fanbtr not give any output? Wy does btrfs
> fi df /mnt/fanbtr say that my data space is only 113 GiB large?
>
> btrfs balance start -dusage=5 works up to -dusage=100:
>
> mh@fan:~$ sudo btrfs balance start -dusage=100 /mnt/fanbtr
> Done, had to relocate 111 out of 179 chunks
> mh@fan:~$ sudo btrfs balance start -dusage=100 /mnt/fanbtr
> Done, had to relocate 111 out of 179 chunks
> mh@fan:~$ sudo btrfs balance start -dusage=100 /mnt/fanbtr
> Done, had to relocate 110 out of 179 chunks
> mh@fan:~$ sudo btrfs balance start -dusage=100 /mnt/fanbtr
> Done, had to relocate 109 out of 179 chunks
> mh@fan:~$ sudo btrfs balance start /mnt/fanbtr
> ERROR: error during balancing '/mnt/fanbtr': No space left on device
> mh@fan:~$

Would you please try the following commands to see which one caused the 
problem?
And would you please provide the dmesg of them?

# btrfs balance start -dprofiles=single /mnt/fanbtr
# btrfs balance start -mprofile=dup /mnt/fanbtr
# btrfs balance start -sprofile=dup /mnt/fanbtr

The above three commands should be equal to your "btrfs balance start" 
command without any parameter, but do them separately, so it should tell 
you which chunk type caused the ENOSPC error.

 From your above -dusage=100 parameter, I think data should be OK, and 
since the metadata chunk is larger than 1G, and there are a lot of free 
metadata space, I assume it's the single system chunk causing the problem.

And if my assumption is right, you have nothing to worry as data and 
metadata should be OK to allocate new chunks, and 32M system chunks is 
definitely large enough.
But in that case, we should have a clearer clue to trace and fix the bug.

Thanks,
Qu

>
> What is going on here? How do I get away from here?
>
> Greetings
> Marc
>
>



Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.13]:57185 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaCBSk1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Mar 2014 13:40:27 -0500
Message-ID: <53137AD1.50504@friedels.name>
Date: Sun, 02 Mar 2014 19:39:13 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: btrfsck does not fix
References: <52C7127F.3060902@friedels.name>	<0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com>	<52D317CF.2070007@friedels.name> <6210673.6TYUkLGl6b@merkaba>	<52DED1C2.60103@friedels.name> <52F6A955.5020808@friedels.name>	<A0A6914C-DDA5-4904-83FA-B59AA420C9C6@colorremedies.com>	<52F73E2B.9080103@friedels.name>	<837FAEE6-9A8E-4A88-AEDF-B9B2B3C3B618@colorremedies.com>	<82A12D91-416E-4B2F-80ED-23ACFD466633@colorremedies.com>	<53010EF9.60805@friedels.name>	<21AD6EBC-FDDA-4BDE-B0B4-D6A8BBAD58F0@colorremedies.com> <pan$475be$cb0c1165$a3d91acc$c206709@cox.net> <5303D6C8.80103@friedels.name> <9583F3D2-78BB-40C3-A1CD-E2D8DE4CA89E@colorremedies.com>
In-Reply-To: <9583F3D2-78BB-40C3-A1CD-E2D8DE4CA89E@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris, hi Ducan,

 >> time ./btrfs balance start  -dconvert=single,soft /mnt/BTRFS/Video/
>> ERROR: error during balancing '/mnt/BTRFS/Video/' - No space left on device
>> There may be more info in syslog - try dmesg | tail
>>
>> real    0m23.803s
>> user    0m0.000s
>> sys     0m1.070s
>>
>> dmesg:
>> [697498.761318] btrfs: relocating block group 19874593112064 flags 9
>> [697507.614140] btrfs: relocating block group 19715679322112 flags 9
>> [697516.218690] btrfs: 2 enospc errors during balance
>
> You could try mounting with enospc_debug option and retrying, see if there's more information dmesg.

I did this (this is on 3.14 rc4 now):
[ 2631.094438] BTRFS info (device sda1): block group has cluster?: no
[ 2631.094439] BTRFS info (device sda1): 0 blocks of free space at or 
bigger than bytes is
[ 2631.094440] BTRFS: block group 24946983043072 has 1073741824 bytes, 0 
used 0 pinned 0 reserved
[ 2631.094441] BTRFS critical (device sda1): entry offset 
24946983043072, bytes 1073741824, bitmap no
[ 2631.105072] BTRFS info (device sda1): block group has cluster?: no
[ 2631.105073] BTRFS info (device sda1): 0 blocks of free space at or 
bigger than bytes is
[ 2631.105074] BTRFS: block group 24948056784896 has 1073741824 bytes, 0 
used 0 pinned 0 reserved
[ 2631.105075] BTRFS critical (device sda1): entry offset 
24948056784896, bytes 1073741824, bitmap no
[ 2631.115594] BTRFS info (device sda1): block group has cluster?: no
[ 2631.115595] BTRFS info (device sda1): 0 blocks of free space at or 
bigger than bytes is
[ 2631.115596] BTRFS: block group 24949130526720 has 1073741824 bytes, 0 
used 0 pinned 0 reserved
[ 2631.115597] BTRFS critical (device sda1): entry offset 
24949130526720, bytes 1073741824, bitmap no
[ 2631.126096] BTRFS info (device sda1): block group has cluster?: no
[ 2631.126097] BTRFS info (device sda1): 0 blocks of free space at or 
bigger than bytes is
[ 2635.099492] BTRFS info (device sda1): 2 enospc errors during balance



> So hopefully the data you need is already backed up and you can just blow this file system away.

I am lacking space why I did the balance (to free one of the two discs).
So, unless the above helps, it seems, I need to buy another HDD?

Davids itegration-branch btrfsck tells me:

./btrfsck /dev/sda1
Checking filesystem on /dev/sda1
UUID: 989306aa-d291-4752-8477-0baf94f8c42f
checking extents
checking free space cache
checking fs roots
root 256 inode 9579 errors 100, file extent discount
root 256 inode 9580 errors 100, file extent discount
root 256 inode 14258 errors 100, file extent discount
root 256 inode 14259 errors 100, file extent discount
root 14155 inode 9579 errors 100, file extent discount
root 14155 inode 9580 errors 100, file extent discount
root 14155 inode 14258 errors 100, file extent discount
root 14155 inode 14259 errors 100, file extent discount
root 14251 inode 9579 errors 100, file extent discount
root 14251 inode 9580 errors 100, file extent discount
...
root 17083 inode 14259 errors 100, file extent discount
found 1419993333189 bytes used err is 1
total csum bytes: 2488683616
total tree bytes: 2811752448
total fs tree bytes: 49192960
total extent tree bytes: 129617920
btree space waste bytes: 83558397
file data blocks allocated: 2585349570560
  referenced 2583623929856
Btrfs this-will-become-v3.13-48-g57c3600

So, nothing new, as far as I can tell...

Greetings,
Hendrik


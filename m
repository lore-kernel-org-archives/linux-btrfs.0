Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:58490 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab3KPMlu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 07:41:50 -0500
Message-ID: <528765F0.7080909@friedels.name>
Date: Sat, 16 Nov 2013 13:32:48 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: btrfsck errors is it save to fix?
References: <52742B59.3060405@friedels.name>	<CAE5mzvijfSOi9dP0MWCMd6=R5MW3bhabote4QYmFnqNEerDifw@mail.gmail.com>	<5274BEC8.5060804@friedels.name> <52780E20.8020405@friedels.name>	<CAE5mzvgrKqrv3LpmiF6iUK=GYsnGOQnSwLTM0dSfBE8ZP-4AuA@mail.gmail.com>	<5279E581.4000700@friedels.name> <527BE712.40304@friedels.name>	<pan$2f107$ddc92f2a$30381770$58497a03@cox.net>	<527DF34B.2030309@friedels.name> <52812AAA.1080106@friedels.name>	<3j78la-3nn.ln1@hurikhan77.spdns.de>	<pan$9db1e$bf9333c2$543d2730$1c706b4d@cox.net>	<llcala-j7c.ln1@hurikhan77.spdns.de> <pan$a3720$6cf50f31$9d15d3bf$b3bbf4bb@cox.net>
In-Reply-To: <pan$a3720$6cf50f31$9d15d3bf$b3bbf4bb@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

 >> Possible? Yes. Although I did not implicitly mention it, you would
>> combine "clear_cache" and "nospace_cache" - that should do the trick.
>> Then unmount and check.
>
> Thanks and mentally noted for further reference.  I didn't think about
> combining the options, but it makes perfect sense now that I have, thanks
> to you. =:^)

For me, it unfortunately did not work:

  mount /dev/sdc1  /mnt/BTRFS/Video/VDR -o clear_cache,nospace_cache

[wait a day or two]

Checking filesystem on /dev/sdc1
UUID: 989306aa-d291-4752-8477-0baf94f8c42f
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
root 256 inode 9579 errors 100, file extent discount
root 256 inode 9580 errors 100, file extent discount
root 256 inode 14258 errors 100, file extent discount
root 256 inode 14259 errors 100, file extent discount
root 4444 inode 9579 errors 100, file extent discount
root 4444 inode 9580 errors 100, file extent discount
root 4444 inode 14258 errors 100, file extent discount
root 4444 inode 14259 errors 100, file extent discount
found 2928473450130 bytes used err is 1
total csum bytes: 3206482672
total tree bytes: 3902070784
total fs tree bytes: 38912000
total extent tree bytes: 136044544
btree space waste bytes: 411777432
file data blocks allocated: 3447164817408
  referenced 3446445981696
Btrfs v0.20-rc1-596-ge9ac73b

Same as before (just a bit more verbose).

Does it help to delete the files at the affected inodes? How do I find, 
which files are stored at these inodes?

Greetings,
Hendrik


-- 
Hendrik Friedel
Auf dem Brink 12
28844 Weyhe
Mobil 0178 1874363

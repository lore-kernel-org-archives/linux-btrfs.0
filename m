Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:53665 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaDSNEu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Apr 2014 09:04:50 -0400
Received: by mail-ob0-f170.google.com with SMTP id vb8so1477868obc.29
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Apr 2014 06:04:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAcaxmUYW4SLmBjv7QPO_0zeHaxLX4PQEu0kT+g5FWNPFOLhDQ@mail.gmail.com>
References: <CAAcaxmUYW4SLmBjv7QPO_0zeHaxLX4PQEu0kT+g5FWNPFOLhDQ@mail.gmail.com>
Date: Sat, 19 Apr 2014 21:04:49 +0800
Message-ID: <CAAcaxmWvZY-Zet6isG0-nVu5gWsctGGO447dfvYadf74X-JHSQ@mail.gmail.com>
Subject: Re: bug report: softlockup hung task
From: ylet ylet <levin.front@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: jbacik <jbacik@fb.com>, clm@fb.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I tried the latest git pull for linus(2014-04-12). The softlockup bug
still exists.

I ran IOZONE in performance test with zlib mount option:
mount -t btrfs -o nospace_cache -o compress-force=zlib -o enospc_debug
/dev/sdb /mnt/btrfs

My PC has i5 4-core CPU, 8GB mem and a 256GB SSD.

 The iozone configuration is as follow:
./iozone -s 16g -i 0 -i 1 -i 2 -t 4 -r 4k -+w 50 -+y 20 -+C 60 -F
/mnt/btrfs/test1 /mnt/btrfs/test2 /mnt/btrfs/test3 /mnt/btrfs/test

2014-04-19 20:13 GMT+08:00 ylet ylet <levin.front@gmail.com>:
> I tried the latest git pull for linus(2014-04-12). The softlockup bug still
> exists.
>
> I ran IOZONE in performance test with zlib mount option:
> mount -t btrfs -o nospace_cache -o compress-force=zlib -o enospc_debug
> /dev/sdb /mnt/btrfs
>
> My PC has i5 4-core CPU, 8GB mem and a 256GB SSD.
>
>  The iozone configuration is as follow:
> ./iozone -s 16g -i 0 -i 1 -i 2 -t 4 -r 4k -+w 50 -+y 20 -+C 60 -F
> /mnt/btrfs/test1 /mnt/btrfs/test2 /mnt/btrfs/test3 /mnt/btrfs/test
>

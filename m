Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f41.google.com ([209.85.210.41]:61390 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab3DJLlq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 07:41:46 -0400
Received: by mail-da0-f41.google.com with SMTP id w4so180542dam.28
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2013 04:41:46 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: btrfs prof compile error on debian squeeze.
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <09F43135-B6BE-4549-A42C-52A340CD522B@icloud.com>
Date: Wed, 10 Apr 2013 19:41:41 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <11DA7B81-2E09-41ED-9D25-DBEECC0555BB@gmail.com>
References: <09F43135-B6BE-4549-A42C-52A340CD522B@icloud.com>
To: Olivier BATARD <obatard@icloud.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
Maybe this url will help you.

https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories

Thanks,
Wang
> Hello,
> 
> I'm trying to build btrfs-prog on debian squeeze but when I'm trying to use make, I have an error :
> 
> 
> pc@debian:~/b/btrfs-progs$ make
>    [LD]     mkfs.btrfs
> mkfs.o: In function `is_ssd':
> /home/pc/b/btrfs-progs/mkfs.c:1234: undefined reference to `blkid_probe_get_wholedisk_devno'
> collect2: ld returned 1 exit status
> make: *** [mkfs.btrfs] Erreur 1
> 
> 
> After a few searches over the internet, it seems that my blkid library is out of date. How can I compile btrfs prog on debian squeeze ?
> 
> Thanks !
> 
> 
> Olivier.--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


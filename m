Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:45685 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161173Ab3DGB7l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Apr 2013 21:59:41 -0400
Received: by mail-pa0-f49.google.com with SMTP id kp14so2660510pab.36
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Apr 2013 18:59:41 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: btrfs-progs: undefined reference to `blkid_probe_get_wholedisk_devno'
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <CAF1ivSYuWd0F5C=vMMBpdB1YhSY0Z319+UB8nqA7_5pqNdfT=g@mail.gmail.com>
Date: Sun, 7 Apr 2013 09:59:34 +0800
Cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Message-Id: <4754110E-8C1E-40DC-B910-31F9BFC4F2CC@gmail.com>
References: <CAF1ivSbyGNjk1rqY_0Jc_1mWJdUZN2-YcUVK4y=2jpZG9SqRSQ@mail.gmail.com> <CAF1ivSYuWd0F5C=vMMBpdB1YhSY0Z319+UB8nqA7_5pqNdfT=g@mail.gmail.com>
To: Lin Ming <minggr@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Lin,

Before compiling you'll need to get some dependencies:
Maybe this url will help:
https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories


Thanks,
Wang

> On Sun, Apr 7, 2013 at 9:38 AM, Lin Ming <minggr@gmail.com> wrote:
>> 
>> Hi,
>> 
>> Build latest git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
>> 
>> ~/btrfs-progs$ make
>>    [LD]     mkfs.btrfs
>> mkfs.o: In function `is_ssd':
>> /home/mlin/btrfs-progs/mkfs.c:1234: undefined reference to `blkid_probe_get_wholedisk_devno'
>> 
>> any fix?
>> 
>> Thanks,
>> Lin Ming
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


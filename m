Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:47942 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161313Ab3DGDA7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Apr 2013 23:00:59 -0400
Received: by mail-la0-f52.google.com with SMTP id ej20so216601lab.25
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Apr 2013 20:00:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4754110E-8C1E-40DC-B910-31F9BFC4F2CC@gmail.com>
References: <CAF1ivSbyGNjk1rqY_0Jc_1mWJdUZN2-YcUVK4y=2jpZG9SqRSQ@mail.gmail.com>
	<CAF1ivSYuWd0F5C=vMMBpdB1YhSY0Z319+UB8nqA7_5pqNdfT=g@mail.gmail.com>
	<4754110E-8C1E-40DC-B910-31F9BFC4F2CC@gmail.com>
Date: Sun, 7 Apr 2013 11:00:58 +0800
Message-ID: <CAF1ivSZKjNZNxvVbaTeX9TQMCJNQDcZCbi2rp0v9JELPZBJPng@mail.gmail.com>
Subject: Re: btrfs-progs: undefined reference to `blkid_probe_get_wholedisk_devno'
From: Lin Ming <minggr@gmail.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I already installed these packages.
sudo apt-get install uuid-dev libattr1-dev zlib1g-dev libacl1-dev
e2fslibs-dev libblkid-dev liblzo2-dev

Maybe my blkid library is too old.
Could you help to check if there is "blkid_probe_get_wholedisk_devno"
in your /usr/include/blkid/blkid.h?

Thanks,
Lin Ming

On Sun, Apr 7, 2013 at 9:59 AM, Wang Shilong <wangshilong1991@gmail.com> wrote:
> Hello Lin,
>
> Before compiling you'll need to get some dependencies:
> Maybe this url will help:
> https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories
>
>
> Thanks,
> Wang
>
>> On Sun, Apr 7, 2013 at 9:38 AM, Lin Ming <minggr@gmail.com> wrote:
>>>
>>> Hi,
>>>
>>> Build latest git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
>>>
>>> ~/btrfs-progs$ make
>>>    [LD]     mkfs.btrfs
>>> mkfs.o: In function `is_ssd':
>>> /home/mlin/btrfs-progs/mkfs.c:1234: undefined reference to `blkid_probe_get_wholedisk_devno'
>>>
>>> any fix?
>>>
>>> Thanks,
>>> Lin Ming
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

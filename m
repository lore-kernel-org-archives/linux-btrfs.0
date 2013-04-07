Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:37611 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161182Ab3DGBmG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Apr 2013 21:42:06 -0400
Received: by mail-lb0-f170.google.com with SMTP id x11so4788097lbi.1
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Apr 2013 18:42:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAF1ivSbyGNjk1rqY_0Jc_1mWJdUZN2-YcUVK4y=2jpZG9SqRSQ@mail.gmail.com>
References: <CAF1ivSbyGNjk1rqY_0Jc_1mWJdUZN2-YcUVK4y=2jpZG9SqRSQ@mail.gmail.com>
Date: Sun, 7 Apr 2013 09:42:03 +0800
Message-ID: <CAF1ivSYuWd0F5C=vMMBpdB1YhSY0Z319+UB8nqA7_5pqNdfT=g@mail.gmail.com>
Subject: Re: btrfs-progs: undefined reference to `blkid_probe_get_wholedisk_devno'
From: Lin Ming <minggr@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(Add list)

On Sun, Apr 7, 2013 at 9:38 AM, Lin Ming <minggr@gmail.com> wrote:
>
> Hi,
>
> Build latest git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
>
> ~/btrfs-progs$ make
>     [LD]     mkfs.btrfs
> mkfs.o: In function `is_ssd':
> /home/mlin/btrfs-progs/mkfs.c:1234: undefined reference to `blkid_probe_get_wholedisk_devno'
>
> any fix?
>
> Thanks,
> Lin Ming

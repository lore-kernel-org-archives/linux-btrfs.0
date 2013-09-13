Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42165 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793Ab3IMNwo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 09:52:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130913133314.GA20461@roeck-us.net>
References: <20130913133314.GA20461@roeck-us.net>
Date: Fri, 13 Sep 2013 15:52:43 +0200
Message-ID: <CAMuHMdWoNo9U0DCRoXt8V2d1SiSxX5Sku9rNvg+9MiX++XjVRg@mail.gmail.com>
Subject: Re: Build failures due to commit 416161db (btrfs: offline dedupe)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>, Mark Fasheh <mfasheh@suse.de>,
        Zach Brown <zab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 13, 2013 at 3:33 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> fs/btrfs/ioctl.c: In function 'btrfs_ioctl_file_extent_same':
> fs/btrfs/ioctl.c:2802:3: error: implicit declaration of function '__put_user_unaligned' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[2]: *** [fs/btrfs/ioctl.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
>
> Seen with alpha:allmodconfig, arm:allmodconfig, m68k:allmodconfig, and
> xtensa:allmodconfig.

Known issue, cfr. my early warning 10 days ago:

"Btrfs is the first user of __put_user_unaligned() outside the compat code,
hence now all 32-bit architectures should make sure to implement this, too."

http://marc.info/?l=linux-arch&m=137820065929216&w=2

and today's thread https://lkml.org/lkml/2013/9/12/814

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

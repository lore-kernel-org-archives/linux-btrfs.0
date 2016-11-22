Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:36515 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756025AbcKVTHf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 14:07:35 -0500
Received: by mail-qt0-f181.google.com with SMTP id w33so18544724qtc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Nov 2016 11:07:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ0EP40tqX7MhtHcUiCMW5hRUrkhS+c3xPe=nRqCK8m5dc4FPA@mail.gmail.com>
References: <CAJ0EP40tqX7MhtHcUiCMW5hRUrkhS+c3xPe=nRqCK8m5dc4FPA@mail.gmail.com>
From: Mike Gilbert <floppymaster@gmail.com>
Date: Tue, 22 Nov 2016 14:07:14 -0500
Message-ID: <CAJ0EP40JWGBBGHz7C6Yo5soSA1_x2d08iTfAaFyzvzYtT=55Eg@mail.gmail.com>
Subject: Re: btrfs-progs-4.8.3 libbtrfs missing symbols?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 22, 2016 at 1:49 PM, Mike Gilbert <floppymaster@gmail.com> wrote:
> Hi,
>
> I received a bug report about a build failure in a package (snapper)
> that utilizes libbtrfs.
>
> https://bugs.gentoo.org/show_bug.cgi?id=600078
>
> To summarize the issue, the package has a configure test that executes
> the following:
>
> configure:16618: x86_64-pc-linux-gnu-gcc -o conftest -O2 -pipe
> -march=amdfam10 -frecord-gcc-switches -std=c99 -Wall -Wextra
> -Wformat=2 -Wmissing-prototypes -Wno-unused-parameter
> -DCONFDIR='"/etc/conf.d"' -Wl,-O1 -Wl,--as-needed conftest.c -lbtrfs
>>&5
> /usr/lib/gcc/x86_64-pc-linux-gnu/5.4.0/../../../../lib64/libbtrfs.so:
> undefined reference to `lookup_path_rootid'
> collect2: error: ld returned 1 exit status
> configure:16618: $? = 1
>
> It seems that the "lookup_path_rootid" symbol is not included in the library.
>
> Could someone look into this?

I this this issue was introduced here:

https://git.kernel.org/cgit/linux/kernel/git/kdave/btrfs-progs.git/commit/?id=1c85c3de5aab997ff66ea95cb0f2c9f79726ec40

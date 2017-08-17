Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:34838 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752820AbdHQUvc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 16:51:32 -0400
Received: by mail-yw0-f171.google.com with SMTP id n83so20461910ywn.2
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Aug 2017 13:51:32 -0700 (PDT)
Date: Thu, 17 Aug 2017 13:51:29 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Zirconium Hacker <jared.e.vb@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS error (device sda4): failed to read chunk tree: -5
Message-ID: <20170817205129.GD2459@vader>
References: <CALsQ4_wnfHtJ+Drn3DJsQxdkX9=ZYDqH_H=hi3BxdSrnDZpqmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALsQ4_wnfHtJ+Drn3DJsQxdkX9=ZYDqH_H=hi3BxdSrnDZpqmw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 16, 2017 at 06:25:54PM -0400, Zirconium Hacker wrote:
> Hi,
> This is my first time using a mailing list, and I hope I'm doing this right.
> 
> $ uname -a
> Linux thinkpad 4.12.6-1-ARCH #1 SMP PREEMPT Sat Aug 12 09:16:22 CEST
> 2017 x86_64 GNU/Linux
> $ btrfs --version
> btrfs-progs v4.12
> $ sudo mount -o ro,recovery /dev/sda4 /mnt
> mount: /mnt: wrong fs type, bad option, bad superblock on /dev/sda4,
> missing codepage or helper program, or other error.
> $ dmesg | tail
> <snip>
> [ 1289.087439] BTRFS warning (device sda4): 'recovery' is deprecated,
> use 'usebackuproot' instead
> [ 1289.087440] BTRFS info (device sda4): trying to use backup root at mount time
> [ 1289.087442] BTRFS info (device sda4): disk space caching is enabled
> [ 1289.097757] BTRFS error (device sda4): failed to read chunk tree: -5
> [ 1289.135222] BTRFS error (device sda4): open_ctree failed

Errno 5 is EIO, are there any I/O errors in your logs?

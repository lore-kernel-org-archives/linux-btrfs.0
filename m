Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:35677 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbcAVPMN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jan 2016 10:12:13 -0500
Received: by mail-ig0-f172.google.com with SMTP id t15so151201074igr.0
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 07:12:12 -0800 (PST)
MIME-Version: 1.0
Reply-To: radek.sprta@gmail.com
In-Reply-To: <CAM7-wL0OzZU9UvFHG0GauXz+ZSHg58CaPQR33CkxNRyPg6+SSg@mail.gmail.com>
References: <CAM7-wL0OzZU9UvFHG0GauXz+ZSHg58CaPQR33CkxNRyPg6+SSg@mail.gmail.com>
From: Radek Sprta <radek.sprta@gmail.com>
Date: Fri, 22 Jan 2016 16:11:53 +0100
Message-ID: <CAM7-wL0kU5TkZaOac1PG5Drk1+JZxYE35-r8y0YiZ2ngmEu9zg@mail.gmail.com>
Subject: Fwd: Unmountable fs after power outage
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everybody,

after a recent power outage attempting to mount a my btrfs partition
fails with the following error:

mount: wrong fs type, bad option, bad superblock on /dev/sda8,
       missing codepage or helper program, or other error

This is what dmesg shows:
[ 1035.236081] BTRFS (device sda8): parent transid verify failed on
410124288 wanted 85753 found 85755
[ 1035.240756] BTRFS (device sda8): parent transid verify failed on
410124288 wanted 85753 found 85755
[ 1035.240780] BTRFS: failed to read tree root on sda8
[ 1035.252025] BTRFS: open_ctree failed

Below is the result of btrfs check:
Checking filesystem on /dev/sda8
UUID: b0486700-ff9f-4979-8735-257ff1428a0d
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 311702978854 bytes used err is 0
total csum bytes: 271057636
total tree bytes: 1859862528
total fs tree bytes: 1473953792
total extent tree bytes: 72876032
btree space waste bytes: 377740163
file data blocks allocated: 11278336921600
 referenced 975937630208
btrfs-progs v4.0

I tried googling the "open_ctree failed" error, but couldn't find any
definite answers. Here's some additional info:

uname -a:
Linux Computer 4.2.0-22-generic #27-Ubuntu SMP Thu Dec 17 22:57:08 UTC
2015 x86_64 x86_64 x86_64 GNU/Linux

btrfs fi show:
Label: none  uuid: b0486700-ff9f-4979-8735-257ff1428a0d
Total devices 1 FS bytes used 290.37GiB
devid    1 size 301.32GiB used 295.04GiB path /dev/sda8

Thanks in advance for any help,
Radek

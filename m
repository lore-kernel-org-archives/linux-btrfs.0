Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f179.google.com ([209.85.208.179]:39244 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727660AbeISBTa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 21:19:30 -0400
Received: by mail-lj1-f179.google.com with SMTP id l15-v6so2862886lji.6
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 12:45:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRyY=_qPTkBkMCs9HCNMvEHJCeFJ_=eCK_BGKgWLHotXA@mail.gmail.com>
References: <CAJCQCtRyY=_qPTkBkMCs9HCNMvEHJCeFJ_=eCK_BGKgWLHotXA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 18 Sep 2018 13:45:22 -0600
Message-ID: <CAJCQCtS-QajPnCLo1nZ=RLzMggn13Ki3-ZRfA_haRq6Vk1Hdfg@mail.gmail.com>
Subject: Re: GRUB writing to grubenv outside of kernel fs code
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 17, 2018 at 9:44 PM, Chris Murphy <lists@colorremedies.com> wrote:
> https://btrfs.wiki.kernel.org/index.php/FAQ#Does_grub_support_btrfs.3F
>
> Does anyone know if this is still a problem on Btrfs if grubenv has
> xattr +C set? In which case it should be possible to overwrite and
> there's no csums that are invalidated.

I'm wrong.

$ sudo grub2-editenv --verbose grubenv create
[sudo] password for chris:
[chris@f29h ~]$ ll
-rw-r--r--. 1 root  root     1024 Sep 18 13:37 grubenv
[chris@f29h ~]$ stat -f grubenv
  File: "grubenv"
    ID: ac9ba8ecdce5b017 Namelen: 255     Type: btrfs
Block size: 4096       Fundamental block size: 4096
Blocks: Total: 46661632   Free: 37479747   Available: 37422535
Inodes: Total: 0          Free: 0
[chris@f29h ~]$ sudo filefrag -v grubenv
Filesystem type is: 9123683e
File size of grubenv is 1024 (1 block of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..    4095:          0..      4095:   4096:
last,not_aligned,inline,eof
grubenv: 1 extent found
[chris@f29h ~]$

So it's an inline extent, which means nocow doesn't apply. It's
metadata so it *must* be COW. And any overwrite would trigger a
metadata checksum error.

First I'd argue it should refuse to create the file on Btrfs. But if
it does create grubenv, instead it should know that on Btrfs it must
redirect it to the appropriate btrfs reserved area (no idea how this
works) rather than to a file.



-- 
Chris Murphy

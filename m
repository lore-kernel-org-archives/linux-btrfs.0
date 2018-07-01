Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:44671 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752433AbeGATPK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jul 2018 15:15:10 -0400
Received: by mail-oi0-f53.google.com with SMTP id s198-v6so8962451oih.11
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Jul 2018 12:15:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180701162722.mnm5wjgxc7weymiz@merlins.org>
References: <20180701162722.mnm5wjgxc7weymiz@merlins.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 1 Jul 2018 13:15:09 -0600
Message-ID: <CAJCQCtRwJONrdEmS0e7Wp9SVdEsxC7qhsw_4QffX6rdvLV0Btw@mail.gmail.com>
Subject: Re: btrfs check of a raid0?
To: Marc MERLIN <marc@merlins.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 1, 2018 at 10:27 AM, Marc MERLIN <marc@merlins.org> wrote:
> Howdy,
>
> I have a btrfs filesystem made out of 2 devices:
> [   75.141414] BTRFS: device label btrfs_space devid 1 transid 429220 /dev/bcache3
> [   75.164745] BTRFS: device label btrfs_space devid 2 transid 429220 /dev/bcache2
>
> One of the 2 devices had a hardware error (not btrfs' fault):
> [201504.939659] BTRFS error (device bcache3): bdev /dev/bcache2 errs: wr 552, rd 39, flush 1, corrupt 0, gen 0
> [201504.995967] BTRFS warning (device bcache3): bcache3 checksum verify failed on 399998976 wanted F3019EEA found E6A97DC4 level 0
> [201505.032209] BTRFS error (device bcache3): bdev /dev/bcache2 errs: wr 552, rd 40, flush 1, corrupt 0, gen 0
> [201505.062447] BTRFS error (device bcache3): parent transid verify failed on 399998976 wanted 434763 found 434245
> [201600.262142] BTRFS error (device bcache3): bdev /dev/bcache2 errs: wr 552, rd 41, flush 1, corrupt 0, gen 0
>
> I unmounted it, and I'm trying to check the filesystem now.

Is it raid0 metadata? Because if it's raid1 metadata it should have
passively recovered from a good copy and then fixed the bad copy.


>
> How is it supposed to work when you have multiple devices for a btrfs
> filesystem?
>
> gargamel:~# btrfs check --repair -p /dev/bcache2
> enabling repair mode
> ERROR: mount check: cannot open /dev/bcache2: No such device or address
> ERROR: could not check mount status: No such device or address
> gargamel:~# btrfs check --repair -p /dev/bcache3
> enabling repair mode
> ERROR: cannot open device '/dev/bcache3': Device or resource busy
> ERROR: cannot open file system
>
> [205248.299528] BTRFS info (device bcache3): disk space caching is enabled
> [205248.320335] BTRFS error (device bcache3): Remounting read-write after error is not allowed

If it's successfully unmounted, I don't understand the error messages
that it can't be opened. Is umount hung? Sounds to me like btrfs check
thinks it's still mounted.



-- 
Chris Murphy

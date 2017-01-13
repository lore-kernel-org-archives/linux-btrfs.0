Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f180.google.com ([209.85.213.180]:34114 "EHLO
        mail-yb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750700AbdAMGqp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jan 2017 01:46:45 -0500
Received: by mail-yb0-f180.google.com with SMTP id c125so12528864ybf.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jan 2017 22:46:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <707f7f482dd48c08544574b71ab77299@amphorawinery.eu>
References: <707f7f482dd48c08544574b71ab77299@amphorawinery.eu>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 12 Jan 2017 23:46:44 -0700
Message-ID: <CAJCQCtTw-tUA5B0GD9i4WOncZ5DO=Nkf+71oZX23Mpw9zN4hdA@mail.gmail.com>
Subject: Re: RAID10: uncorrectable errors
To: Gregory Petit <gregory@amphorawinery.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 12, 2017, 2:55 AM Gregory Petit <gregory@amphorawinery.eu> wrote:

> Here are the details:
>
> scrub started at Wed Jan 11 18:00:01 2017 and finished after 00:19:23
> total bytes scrubbed: 1.14TiB with 4 errors
> error details: csum=4
> corrected errors: 0, uncorrectable errors: 4, unverified errors: 0
>
>  From dmesg:
> Wed Jan 11 18:10:35 2017] BTRFS error (device sda): bdev /dev/sda errs:
> wr 0, rd 0, flush 0, corrupt 1, gen 0
> [Wed Jan 11 18:10:35 2017] BTRFS error (device sda): unable to fixup
> (regular) error at logical 631657844736 on dev /dev/sda
> [Wed Jan 11 18:10:51 2017] BTRFS error (device sda): bdev /dev/sdb errs:
> wr 0, rd 0, flush 0, corrupt 1, gen 0
> [Wed Jan 11 18:10:51 2017] BTRFS error (device sda): unable to fixup
> (regular) error at logical 632954847232 on dev /dev/sdb
> [Wed Jan 11 18:18:57 2017] BTRFS error (device sda): bdev /dev/sdc errs:
> wr 0, rd 0, flush 0, corrupt 1, gen 0
> [Wed Jan 11 18:18:57 2017] BTRFS error (device sda): unable to fixup
> (regular) error at logical 632954847232 on dev /dev/sdc
> [Wed Jan 11 18:19:19 2017] BTRFS error (device sda): bdev /dev/sde errs:
> wr 0, rd 0, flush 0, corrupt 1, gen 0
> [Wed Jan 11 18:19:19 2017] BTRFS error (device sda): unable to fixup
> (regular) error at logical 631657844736 on dev /dev/sde


Look at the logical addresses. Two pair, four total, have errors.
Looks like both copies of two blocks of information are corrupt, and
that's why fix up doesn't happen. I'm gonna guess this is metadata.
But between 'btrfs inspect-internal logical-resolve' or 'dump-tree'
with those two block numbers, you should be able to figure out what's
affected. Pretty strange for both copies to get munged though, but I'm
suspicious of hardware - in particular controller or cable or even
RAM, since it affects at least two drives. The chances this is two
drives corrupting the same logical block of data is almost zero.



>
> root@proxmox:~# btrfs check --repair /dev/sda

FWIW btrfs check finds all member devices for you regardless of which
device you point it to, and checks the whole file system. It's not
necessary to run it on each device.

'btrfs check --mode=lowmem' might find the problem but I don't think
it can fix anything still.


Chris Murphy

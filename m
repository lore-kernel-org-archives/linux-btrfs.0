Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33906 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752872AbdHQXjT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 19:39:19 -0400
Received: by mail-qt0-f196.google.com with SMTP id i19so7627591qte.1
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Aug 2017 16:39:19 -0700 (PDT)
Date: Thu, 17 Aug 2017 19:39:17 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Paulo Dias <paulo.miguel.dias@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: qcow2 images make scrub believe the filesystem is corrupted.
Message-ID: <20170817233916.GA25527@destiny>
References: <CADJPUQ9awnz30XzGZLGQAUhAqeH5ek6stDN5N5JTzc3dGtdiug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADJPUQ9awnz30XzGZLGQAUhAqeH5ek6stDN5N5JTzc3dGtdiug@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 15, 2017 at 10:12:28PM -0300, Paulo Dias wrote:
> Hello/2 all
> 
> I'm using libvirt with a qcow2 image and everytime i run btrfs scrub
> -H /home (subvolume where the image is), i get:
> 
> ago 15 21:58:08 kerberos kernel: BTRFS error (device sda3): bdev
> /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 30, gen 0
> ago 15 21:58:08 kerberos kernel: BTRFS error (device sda3): unable to
> fixup (regular) error at logical 289831161856 on dev /dev/sda3
> ago 15 21:58:08 kerberos kernel: BTRFS error (device sda3): bdev
> /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 31, gen 0
> ago 15 21:58:08 kerberos kernel: BTRFS error (device sda3): unable to
> fixup (regular) error at logical 289830309888 on dev /dev/sda3
> ago 15 21:58:08 kerberos kernel: BTRFS error (device sda3): bdev
> /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 32, gen 0
> ago 15 21:58:08 kerberos kernel: BTRFS error (device sda3): unable to
> fixup (regular) error at logical 289831055360 on dev /dev/sda3
> ago 15 21:58:08 kerberos kernel: BTRFS error (device sda3): bdev
> /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 33, gen 0
> ago 15 21:58:08 kerberos kernel: BTRFS error (device sda3): unable to
> fixup (regular) error at logical 289861591040 on dev /dev/sda3
> ago 15 21:58:09 kerberos kernel: BTRFS warning (device sda3): checksum
> error at logical 290297204736 on dev /dev/sda3, sector 67982824, root
> 258, inode 968837, offset 17455849472, length 4096, links 1 (path:
> groo/Fedora/Fedora.qcow2)
> ago 15 21:58:09 kerberos kernel: BTRFS error (device sda3): bdev
> /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 34, gen 0
> ago 15 21:58:09 kerberos kernel: BTRFS error (device sda3): unable to
> fixup (regular) error at logical 290297204736 on dev /dev/sda3
>

Tried replying from my phone, forgot the app defaults to HTML, trying again.

This is happening because the app (the guest OS in this case, we saw this a lot
with windows guests) is changing the pages while they are in flight.  We
calculate the checksum of the page before it's written, so if it changes while
in flight we'll end up with a csum mismatch.

To fix this change kvm to not use O_DIRECT or set NODATASUM on your qcow2 image.
You'll have to re-create the image because NODATASUM won't apply to the already
invalid checksums.  Thanks,

Josef 

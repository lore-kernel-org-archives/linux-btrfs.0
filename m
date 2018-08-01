Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f171.google.com ([209.85.208.171]:36277 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733019AbeHAHQh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2018 03:16:37 -0400
Received: by mail-lj1-f171.google.com with SMTP id u7-v6so15775955lji.3
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2018 22:32:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN4oSBc8zM+OZEXAGygwf3RMoyEKLmrk--_HqwMsG1HVGJCf2Q@mail.gmail.com>
References: <CAN4oSBc8zM+OZEXAGygwf3RMoyEKLmrk--_HqwMsG1HVGJCf2Q@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 31 Jul 2018 23:32:46 -0600
Message-ID: <CAJCQCtQWYM5Hb6-9QhRujcrP9Ou8u5N+RFLFzA=Za7Z1FeuakQ@mail.gmail.com>
Subject: Re: Unmountable root partition
To: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 31, 2018 at 12:03 PM, Cerem Cem ASLAN <ceremcem@ceremcem.net> wrote:

> 3. mount -t btrfs /dev/mapper/foo--vg-root /mnt/foo
> Gives the following error:
>
> mount: wrong fs type, bad option, bad superblock on ...
>
> 4. dmesg | tail
> Outputs the following:
>
>
> [17755.840916] sd 3:0:0:0: [sda] tag#0 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [17755.840919] sd 3:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 07 c0 02 00 00
> 02 00
> [17755.840921] blk_update_request: I/O error, dev sda, sector 507906
> [17755.840941] EXT4-fs (dm-4): unable to read superblock


Are you sure this is the output for the command? Because you're
explicitly asking for type btrfs, which fails, and then the kernel
reports EXT4 superblock unreadable. What do you get if you omit -t
btrfs and just let it autodetect?

But yeah, this is an IO error from the device and there's nothing
Btrfs can do about that unless there is DUP or raid1+ metadata
available.

Is it possible this LV was accidentally reformatted ext4?


-- 
Chris Murphy

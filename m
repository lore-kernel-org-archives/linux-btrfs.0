Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:55280 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbdJNTBI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Oct 2017 15:01:08 -0400
Received: by mail-it0-f50.google.com with SMTP id 72so13971472itk.3
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Oct 2017 12:01:08 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?Wm9sdMOhbiBJdsOhbmZp?= <zoltan1980@gmail.com>
Date: Sat, 14 Oct 2017 21:00:26 +0200
Message-ID: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
Subject: Is it safe to use btrfs on top of different types of devices?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear Btrfs Experts,

A few years ago I tried to use a RAID1 mdadm array of a SATA and a USB
disk, which lead to strange error messages and data corruption. I did
some searching back then and found out that using hot-pluggable
devices with mdadm is a paved road to data corruption. Reading through
that old bug again I see that it was autoclosed due to old age but
still hasn't been addressed:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/320638

I would like to ask whether btrfs may also be prone to data corruption
issues in this scenario (due to the same underlying issue as the one
described in the bug above for mdadm), or is btrfs unaffected by the
underlying issue and is safe to use with a mix of regular and
hot-pluggable devices as well?

Thanks,

Zoltan

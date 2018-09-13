Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f182.google.com ([209.85.215.182]:45520 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbeIMRbw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 13:31:52 -0400
Received: by mail-pg1-f182.google.com with SMTP id x26-v6so2662688pge.12
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2018 05:22:38 -0700 (PDT)
MIME-Version: 1.0
From: Serhat Sevki Dincer <jfcgauss@gmail.com>
Date: Thu, 13 Sep 2018 15:22:24 +0300
Message-ID: <CAPqC6xR1rbNqpPUUxU2OyvtCHoD2LOywE5cRDtNTbqJ2=5e_nQ@mail.gmail.com>
Subject: btrfs convert problem
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have an external usb HDD (WD my passport, just usb cable, no
external power) with a single ext4 partition occupying the whole disk
with 698 GiB capacity and 188 GiB empty space. The data on disk is not
very important.

I also have a laptop with Manjaro 64-bit XFCE, kernel 4.14.68,
btrfs-progs v4.17.1, all packages come with Manjaro.

I tried to convert my disk to btrfs with
sudo btrfs-convert /dev/sdb1
I have also tried -i, -n options, all failed with:

create btrfs filesystem:
    blocksize: 4096
    nodesize:  16384
    features:  extref, skinny-metadata (default)
creating ext2 image file
ERROR: failed to create ext2_saved/image: -1
WARNING: an error occurred during conversion, filesystem is partially
created but not finalized and not mountable

I could not find this error/warning combo on the net.
ext4 partition seems intact and working after these attempts.
How can I debug and complete this conversion?

Thanks..

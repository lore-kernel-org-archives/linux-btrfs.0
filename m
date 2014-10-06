Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61642 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaJFRGx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Oct 2014 13:06:53 -0400
Received: by mail-wi0-f173.google.com with SMTP id fb4so5309144wid.0
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Oct 2014 10:06:52 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 6 Oct 2014 10:06:52 -0700
Message-ID: <CAG+QAKVPcJPVL-mRsnG0m1NQCRrwaUbYDqKXBCjOnH_5A0ifHg@mail.gmail.com>
Subject: Two uncorrectable errors across RAID1 at same logical block?
From: Rich Rauenzahn <rrauenza@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fs is across two ssd drives.  Am I interpreting this right that the
same logical block is corrupt on both drives?  That seems odd.

How do I map it to a filename?

$ sudo dmesg --clear

$ dmesg

$ sudo btrfs scrub start -B /
scrub done for
35f0ce3f-0902-47a3-8ad8-86179d1f3e3a
        scrub started at Mon Oct  6 09:51:01 2014 and finished after 325 seconds
        total bytes scrubbed: 114.89GiB with 2 errors
        error details: csum=2
        corrected errors: 0, uncorrectable errors: 2, unverified errors: 0

$ dmesg
 btrfs: bdev /dev/sdg3 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
 btrfs: unable to fixup (regular) error at logical 58464632832 on dev /dev/sdg3
 btrfs: bdev /dev/sdf3 errs: wr 0, rd 0, flush 0, corrupt 6, gen 0
 btrfs: unable to fixup (regular) error at logical 58464632832 on dev /dev/sdf3

$ uname -a
Linux hostname 3.10.0-123.8.1.el7.x86_64 #1 SMP Mon Sep 22 19:06:58
UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

$ btrfs --version
Btrfs v3.12

$ btrfs fi show
Btrfs v3.12

$ btrfs fi df /
Data, RAID1: total=107.07GiB, used=55.47GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=4.00GiB, used=2.04GiB

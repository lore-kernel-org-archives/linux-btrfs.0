Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FROM_EXCESS_BASE64,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D0BC28CF8
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 07:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69E6120853
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 07:50:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=seravo.fi header.i=@seravo.fi header.b="JNbw8uMH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69E6120853
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=seravo.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbeJOPet (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 11:34:49 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:43666 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbeJOPet (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 11:34:49 -0400
Received: by mail-pf1-f170.google.com with SMTP id p24-v6so9239055pff.10
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2018 00:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=seravo.fi; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=DQyB4CZwpfSY2G+xVT4004JvPG6LanQduL39s8mlgRo=;
        b=JNbw8uMHIOtddVGRNtyDORIGzQ47RZIyl0xBhTJXlsauTGzNvabe0/KTR6R+18n7eI
         zdgmUcBw4H+dNoEwTkRCTpFyWGuJchDLHgsbs4sTNvmSBWJvvZqjFYMiaKHFPBNz9/XQ
         iZ9ERzcOmQWAJ0PesgKaG/quxCScAOF5Mv5nw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=DQyB4CZwpfSY2G+xVT4004JvPG6LanQduL39s8mlgRo=;
        b=B3GzspOVQpQ8yAK+N7LCsi9K1hmbC7Ab/YFWCeF2YCYD2BDgXvp0r6gLvlr1EPgHcd
         9IhZy6QV4TFrfmfXYLy5IWUFTBsNy7329qhs5fn9m6Ov60f/Yy7oWUlrNIXUyaHZRR8W
         lzPs+Bm0yqglVeebWZZLDYvN2vUTbtpwQxDtpjHVoeQ59Ve9RJNB+ZVd+3g7Fmn2nCEp
         r5CuwwXtXsh1LTqcshpypKHnoHGKQYBLyGIkOee66VWgUMLyohTgIzbOs6k5jm6G5wKT
         H8g2IvE2hNw53s/jXnwOzdkGwioptRjNcEkx9zMNGKt/d4QOitrfeqKHgEVU5LIpstKn
         1svA==
X-Gm-Message-State: ABuFfoixAkVNaLLLUcRvgygtCMCUHVaGAh5O6ZVpIi0GCFuCtdmaLgdV
        q+el3CJmC/E4+cjJnzNJj8TreVOhmfv5mboNSXUkoO/ZYg==
X-Google-Smtp-Source: ACcGV63G2KnE3hLZF9Dw4cBfLUqx4msnZj7TM+vbmtz91YTF4YSSwzYMsce5t/xm4h3fwB45/ScJFgaYusrND+PuXSY=
X-Received: by 2002:a63:2356:: with SMTP id u22-v6mr15003317pgm.122.1539589841922;
 Mon, 15 Oct 2018 00:50:41 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?T3R0byBLZWvDpGzDpGluZW4=?= <otto@seravo.fi>
Date:   Mon, 15 Oct 2018 10:50:14 +0300
Message-ID: <CAHj_TLCsG52NUJf6DbKCO9iQ6Fr2-jOUAsfHs=_UM_LJBYtdMA@mail.gmail.com>
Subject: How to recover from btrfs scrub errors? (uncorrectable errors,
 checksum error at logical)
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello!

I am trying to figure out how to recover from errors detected by btrfs scrub.

Scrub status reports:

scrub status for 4f4479d5-648a-45b9-bcbf-978c766aeb41
        scrub started at Mon Oct 15 10:02:28 2018, running for 00:35:39
        total bytes scrubbed: 791.15GiB with 18 errors
        error details: csum=18
        corrected errors: 0, uncorrectable errors: 18, unverified errors: 0

Kernel log contains lines like

  BTRFS warning (device dm-8): checksum error at logical 7351706472448 on dev
  /dev/mapper/disk6tb, sector 61412648, root 12725, inode 152358265,
offset 483328:
  path resolving failed with ret=-2

I've tried so far:
- deleting the files (when path is visible)
- overwriting the files with new data
- changed disk (with btrfs replace)

The checksum errors however persist.
How do I get rid of them?


The files are logs and other non-vital information. I am fine by
deleting the corrupted files. It is OK to recover so that I loose a
few gigabytes of data, but not the entire filesystem.

Setup is a multi-disk btrfs filesystem, data single, metadata RAID-1
Mounted with:

/dev/mapper/wdc3td on /data type btrfs
(rw,noatime,compress=lzo,space_cache,subvolid=5,subvol=/)

I've read lots of online sources on the topic but none of these help
me on how to recover from the current state:

https://btrfs.wiki.kernel.org/index.php/Btrfsck
http://marc.merlins.org/perso/btrfs/post_2014-03-19_Btrfs-Tips_-Btrfs-Scrub-and-Btrfs-Filesystem-Repair.html
https://wiki.archlinux.org/index.php/Identify_damaged_files#Find_damaged_files

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:36050 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab2JXGkQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 02:40:16 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so98154lag.19
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2012 23:40:15 -0700 (PDT)
MIME-Version: 1.0
From: Ins <insfocus@gmail.com>
Date: Wed, 24 Oct 2012 14:39:34 +0800
Message-ID: <CAMRmmpK8rYQDRWVM6nxsc2kouFNPyAnwAfB6Y19Ha40rLdeejA@mail.gmail.com>
Subject: mkfs.btrfs allow to set the sectorsize by the -s option but the
 kernel doesnot
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,


  mkfs.btrfs allows to set the sectorsize by the -s option.


  mkfs.btrfs -s 8192 /dev/loop0

  Then when I do mount, I got these messages:

  [13912.224463] btrfs: Incompatible sector size(8192) found on loop0
  [13912.224660] btrfs: open_ctree failed


  The related codes in the kernel fs/btrfs/disk-io.c!2366


2366        if (sectorsize != PAGE_SIZE) {
2367                printk(KERN_WARNING "btrfs: Incompatible sector
size(%lu) "
2368                       "found on %s\n", (unsigned long)sectorsize,
sb->s_id);
2369                goto fail_sb_buffer;
2370        }


So the actually reason is?




Thanks.
-Rock

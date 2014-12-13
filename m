Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:59363 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964963AbaLMMEb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Dec 2014 07:04:31 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so4895725wiw.16
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Dec 2014 04:04:30 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH][BTRFS-PROGS] Print metadata profile instead of data profile
Date: Sat, 13 Dec 2014 13:05:50 +0100
Message-Id: <1418472351-5113-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


The function test_num_disk_vs_raid() show an error message if
the raid profile is incompatible with the number of devices.
    
Unfortunately when the error is related to data profile,
the message print the metadata profile.

How reproduce:

  $ mkfs.btrfs -f -m dup -d raid5 /dev/vdb"
  Error: unable to create FS with data profile 32 (have 1 devices)

Expected result:

  Error: unable to create FS with data profile 128 (have 1 devices)

mkfs.btrfs should print the profile 128 (==raid5) and not 32 (==dup)

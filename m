Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:35323 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbbFGXKT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Jun 2015 19:10:19 -0400
Received: by qkhq76 with SMTP id q76so69757646qkh.2
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Jun 2015 16:10:19 -0700 (PDT)
MIME-Version: 1.0
From: Peter Foley <pefoley2@pefoley.com>
Date: Sun, 7 Jun 2015 16:09:58 -0700
Message-ID: <CAOFdcFPb7cDMC8EUwZeVpTvSUf6TYRYZKOUZ_MQGY51O2U-0gA@mail.gmail.com>
Subject: BTRFS corruption causing fsck segfaults.
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I recently converted a ext4 fs to btrfs and then ran an offline defrag on it.
After the defrag had been running for 24 hours, I tried to cancel it,
but it hung so I hard reset the machine.
In hindsight, this was probably not a good idea as this majorly
screwed up the fs, so that running btrfs check --repair segfaults.
I'm running the 4.0.4 kernel with btrfs-progs 4.0.1.

I've got a coredump, btrfs-image output, and the output from running
btrfs check and btrfs check --repair at http://pefoley.com/btrfs/
Any help would be appreciated.

Thanks,

Peter Foley

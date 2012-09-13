Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44246 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab2IMGCE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Sep 2012 02:02:04 -0400
Received: by obbuo13 with SMTP id uo13so3963126obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 23:02:04 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 13 Sep 2012 14:02:04 +0800
Message-ID: <CACHiF8Bg+od7tyq_5QeXAN1uo+Gs+D_Mnof00RPJZRoP2RC6ZA@mail.gmail.com>
Subject: ssd alignment and btrfs sector size
From: ching lu <lsching17@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am trying to test btrfs on my ssd, i am studying about btrfs and alignment.

I have read this old mail:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg16177.html

According to the thread, 3 parameters should be tuned

1. leafsize
2. nodesize
3. sectorsize

The first two parameters are easy to understand, but how does
"sectorsize" affect the alignment?

If the erase block size of my SSD is 16k, and i set
leafsize=nodesize=16k, leave the sectorsize=4k (default), will it
causes misalignment?

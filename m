Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:44095 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752362AbdKOIv0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 03:51:26 -0500
Received: by mail-lf0-f42.google.com with SMTP id s16so25074148lfs.1
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Nov 2017 00:51:26 -0800 (PST)
MIME-Version: 1.0
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Wed, 15 Nov 2017 10:51:24 +0200
Message-ID: <CAK5rZE51onZEE_f2xg4nxPriU9YQq5AARDLs-BTZL2RaGSCTXA@mail.gmail.com>
Subject: zstd compression
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kernel 4.14 now includes btrfs zstd compression support.

My question:
I currently have a fs mounted and used with "compress=lzo"
option. What happens if I change it to "compress=zstd"?

My guess is that existing files will be read and uncompressed via lzo.
And new files will be written with zstd compression. And
everything will run smoothly.

Is this optimistic guess valid? What are possible pitfalls,
if there are any? Any further advices?

Regards,
Imran

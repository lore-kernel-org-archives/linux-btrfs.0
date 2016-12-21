Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:35045 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755986AbcLUVJw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Dec 2016 16:09:52 -0500
Received: by mail-yb0-f194.google.com with SMTP id d59so2536288ybi.2
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Dec 2016 13:09:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1482323222.585a7516d6aa4@webmail.adria.it>
References: <1479730155.5832e3eb3fde8@webmail.adria.it> <9712851.I7FUyRd5GC@exnet.gdb.it>
 <trinity-46cbb3e7-b072-4e9a-a504-e67b58cc9c9c-1482096970056@3capp-mailcom-bs08>
 <1843121.XhPNI7cFmJ@exnet.gdb.it> <trinity-f5b0b96e-286c-4485-a02e-1f96bca7a906-1482255789582@3capp-mailcom-bs06>
 <1482323222.585a7516d6aa4@webmail.adria.it>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 21 Dec 2016 14:09:41 -0700
Message-ID: <CAJCQCtR0k9gr5XQ=5jUXYTFrntui3t6-tdf6uvAJpAV_ue6B0w@mail.gmail.com>
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system
 during the snapshot receive
To: Giuseppe Della Bianca <bepi@adria.it>
Cc: Xin Zhou <xin.zhou@gmx.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What about CONFIG_BTRFS_FS_CHECK_INTEGRITY? And then using check_int
mount option?


Chris Murphy

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from forward8m.cmail.yandex.net ([5.255.216.201]:56726 "EHLO
        forward8m.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755337AbcH1LxF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 07:53:05 -0400
Received: from mxback6m.mail.yandex.net (mxback6m.mail.yandex.net [37.140.138.66])
        by forward8m.cmail.yandex.net (Yandex) with ESMTP id 3E601214A0
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Aug 2016 14:17:11 +0300 (MSK)
From: Alexander Tomokhov <alexoundos@ya.ru>
To: linux-btrfs@vger.kernel.org
Subject: Is there a performance advantage in using Btrfs subvolumes over raw (MBR/GPT) partitions on rotational disks?
MIME-Version: 1.0
Message-Id: <17621472383031@web11m.yandex.ru>
Date: Sun, 28 Aug 2016 14:17:11 +0300
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Let's say I use a 128GiB MBR partition for OS and remaining 800GiB+ on disk serves another purpose. Then all OS files will be physically close to each other on the disk, thus reducing seek times.
If I use the whole disk for OS partition, then files will be spread across the disk and even OS-only operations will require hard drive heads to perform longer seeks.

What effect have Btrfs subvolumes in this case if I use them instead of MBR partitions?
Btrfs wiki says: "btrfs does write optimisation (sequential writes) across a filesystem", "subvolume write performance will benefit from this algorithm". I don't understand what it means and couldn't find explanation. Does Btrfs optimize file data placement on rotational disk inside single subvolume, so that storing similar (accessed together) data inside single subvolume will benefit in terms of performance?

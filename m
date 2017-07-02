Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:35523 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751608AbdGBOBA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Jul 2017 10:01:00 -0400
Received: by mail-vk0-f45.google.com with SMTP id 191so84748586vko.2
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Jul 2017 07:00:57 -0700 (PDT)
MIME-Version: 1.0
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Sun, 2 Jul 2017 19:30:15 +0530
Message-ID: <CAKuJGC-p49NKDzjOoPUODQ6t8JSN_R39Mij_G2OEcmENwN9Q8w@mail.gmail.com>
Subject: btrfs-convert --no-datasum & btrfs check: check_owner_ref: BUG_ON
 `rec->is_root` triggered, value 1
To: btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.
While using btrfs-convert with '--no-datasum' option & running btrfs
check crashes:

steps:
mkfs.ext4 tests/t1
mount tests/t1 /data
cp -r *.c /data
umount /data
./btrfs-convert --no-datasum tests/t1
./btrfs check tests/t1
<crash>
cmds-check.c:5488: check_owner_ref: BUG_ON `rec->is_root` triggered, value 1

Is this a bug or something wrong with my environment?

More info: https://bugzilla.kernel.org/show_bug.cgi?id=196217
----
Cheers,
Lakshmipathi.G

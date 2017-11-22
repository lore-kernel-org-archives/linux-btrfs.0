Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f180.google.com ([74.125.82.180]:34378 "EHLO
        mail-ot0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751249AbdKVTTA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Nov 2017 14:19:00 -0500
Received: by mail-ot0-f180.google.com with SMTP id o23so14482921otd.1
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 11:19:00 -0800 (PST)
MIME-Version: 1.0
From: Jorge Bastos <jorge.mrbastos@gmail.com>
Date: Wed, 22 Nov 2017 19:18:59 +0000
Message-ID: <CAHzMYBQ7tsHFuHkJ5zjK6Wx0bD0XHp0TGti_uJNV5pz4ak7wJA@mail.gmail.com>
Subject: btrfs restore corrupt file
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

While doing btrfs checksum testing I purposely corrupted a file and
got the expect I/O error when trying to copy it, I also tested btrfs
restore to see if I could recover a known corrupt file and it did copy
it but there was no checksum error or warning. I used btrfs restore -v

Is this expect behavior or should restore warn about checksum failures?

Kernel used was 4.13.13,  btrfs-progs v4.13.2

Thanks,
Jorge

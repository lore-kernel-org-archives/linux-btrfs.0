Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:42990 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751599AbdKVSqc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Nov 2017 13:46:32 -0500
Received: by mail-oi0-f47.google.com with SMTP id p23so8504078oie.9
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 10:46:32 -0800 (PST)
MIME-Version: 1.0
From: Jorge Bastos <jorge.mrbastos@gmail.com>
Date: Wed, 22 Nov 2017 18:46:31 +0000
Message-ID: <CAHzMYBRbse+X50P614eX_frubWGSYUN3zB5WWOz7p_9eNKz5Dw@mail.gmail.com>
Subject: btrfs restore corrupt file
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

While doing btrfs checksum testing I purposely corrupted a file and
got the expect I/O error when trying to copy it, I also tested btrfs
restore to see if I could recover a known corrupt file and it did copy
it and there was no checksum error or warning, is this expect behavior
or should restore warn about checksum failures?

Kernel used was 4.13.13,  btrfs-progs v4.13.2

Thanks,
Jorge

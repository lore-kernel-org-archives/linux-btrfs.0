Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:36508 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932352AbdABJzX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jan 2017 04:55:23 -0500
Received: by mail-lf0-f44.google.com with SMTP id t196so268109405lff.3
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jan 2017 01:55:22 -0800 (PST)
Received: from [192.168.1.3] (ppp109-252-90-129.pppoe.spdop.ru. [109.252.90.129])
        by smtp.gmail.com with ESMTPSA id j9sm3947593lfe.23.2017.01.02.01.55.20
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Jan 2017 01:55:21 -0800 (PST)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Subject: Will fstrim discard unused parts of chunks?
Message-ID: <d538b76e-ecdc-19bb-2395-281a5c7c44e5@gmail.com>
Date: Mon, 2 Jan 2017 12:55:20 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I try to understand what exactly is trimmed in case of btrfs. Using
installation in QEMU I see that host file size is about 9GB, allocated
size in guest approximately matches it and used space in guest is 7.6GB.
After some experimenting it looks like host size follows "Device
allocated" value in "btrfs filesystem usage" which leads me to believe
trim only considers space outside of allocated chunks. Is it correct?

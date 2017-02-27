Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:36689 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751594AbdB0SxT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Feb 2017 13:53:19 -0500
Received: by mail-lf0-f54.google.com with SMTP id y193so9118415lfd.3
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Feb 2017 10:51:32 -0800 (PST)
Received: from [192.168.1.6] (ppp109-252-90-129.pppoe.spdop.ru. [109.252.90.129])
        by smtp.gmail.com with ESMTPSA id u18sm10708228ljd.28.2017.02.27.10.51.30
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Feb 2017 10:51:30 -0800 (PST)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Subject: "parent transid verify failed" out of blue sky
Message-ID: <30195f78-a741-7e51-338d-7b96b7a0fe4a@gmail.com>
Date: Mon, 27 Feb 2017 21:51:29 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is VM under QEMU/KVM running openSUSE Tumbleweed. I boot it
infrequently for short time to test something. Last time it installed
quite a lot of updates including kernel (I think 4.9.11 was the last
version); I do not remember whether I rebooted it after that. Today I
booted it to check something, after 10 minutes did "reboot" and was
greeted with grub rescue prompt (it is located on btrfs itself and
apparently failed to read its modules as well). Any attempt to mount it
fails with "parent transid verfy failed". btrfsck --mode=lowmem from
current Tumbleweed snapshot runs for half an hour now with never-ending
same message.

I do not care in disk content really, but I would be interested in
trying to recover it under guidance. Also if it may be useful I can
provide image or other information.

TIA

-andrei

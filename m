Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:64690 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab3KHWJF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Nov 2013 17:09:05 -0500
Received: by mail-pb0-f44.google.com with SMTP id rp16so2684382pbb.31
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Nov 2013 14:09:04 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 9 Nov 2013 06:09:04 +0800
Message-ID: <CAOeUAF_80gVV-uDAw1Z_kQreOze-mW6uUCSheM_eBb_TYq_fuw@mail.gmail.com>
Subject: Btrfs resize problem after device add/delete
From: Lester B <b.lester011+btrfs@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I create a new btrfs filesystem and then add a new device and delete
the original device. When I run 'btrfs filesystem show', the total
device is two and there is an error that some devices are missing.


I also tried to resize the filesystem but didn't work. Resizing
without device id have an error that there is no such device. When the
device id is explicitly pass, an error 'invalid argument' is
displayed.

I tried to unmount and then remount and the first problem disappeared
while the second one didn't.

3.11.6-1-ARCH #1 SMP PREEMPT Fri Oct 18 23:22:36 CEST 2013 x86_64 GNU/Linux

Btrfs v0.20-rc1-358-g194aa4a-dirty

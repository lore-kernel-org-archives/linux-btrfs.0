Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:36802 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756890AbcJSQwT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 12:52:19 -0400
Received: by mail-lf0-f49.google.com with SMTP id b75so31898442lfg.3
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Oct 2016 09:52:18 -0700 (PDT)
Received: from [192.168.1.44] (ppp109-252-90-102.pppoe.spdop.ru. [109.252.90.102])
        by smtp.gmail.com with ESMTPSA id s63sm4315759lja.3.2016.10.19.09.52.15
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Oct 2016 09:52:15 -0700 (PDT)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Subject: Cross subvolume "cp --reflink"?
Message-ID: <678dcd2e-13ca-0b83-6561-b7c6c10468b9@gmail.com>
Date: Wed, 19 Oct 2016 19:52:14 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I get "Failed to clone: Invalid cross-device link". Is it expected?
Basically this is (on openSUSE TW which has root on subvolume)

mount -o subvol=/ /dev/vda1 /mnt
btrfs sub create /mnt/var/cache
cp -a --reflink=always /var/cache/* /mnt/var/cache

Kernel 4.7.5-1-default.


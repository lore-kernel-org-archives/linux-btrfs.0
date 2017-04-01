Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-afa67.mailout.artfiles.de ([212.72.176.67]:56541 "EHLO
        mailout-afa67.mailout.artfiles.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751297AbdDAJsz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 1 Apr 2017 05:48:55 -0400
Received: from [209.85.218.50] (helo=mail-oi0-f50.google.com)
        auth=smtp_senderkonto@kai-herlemann.de
        by mailout.artfiles.de with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.80.1)
        id 1cuFeO-0006Vb-Vp
        for linux-btrfs@vger.kernel.org; Sat, 01 Apr 2017 11:48:53 +0200
Received: by mail-oi0-f50.google.com with SMTP id b187so84415789oif.0
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Apr 2017 02:48:52 -0700 (PDT)
MIME-Version: 1.0
From: Kai Herlemann <btrfs@linux.kai-herlemann.de>
Date: Sat, 1 Apr 2017 11:48:50 +0200
Message-ID: <CADN-S7MzE=6x25DK0XOPzfBGCEpTjdUSokBkuCPGhCvCURzLPg@mail.gmail.com>
Subject: Is btrfs-convert able to deal with sparse files in a ext4 filesystem?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I have on my ext4 filesystem some sparse files, mostly images from
ext4 filesystems.
Is btrfs-convert (4.9.1) able to deal with sparse files or can that
cause any problems?

Thanks in advance,
Kai

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:37190 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754196AbeAQRfC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jan 2018 12:35:02 -0500
Received: by mail-vk0-f52.google.com with SMTP id g83so11989868vki.4
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jan 2018 09:35:01 -0800 (PST)
MIME-Version: 1.0
From: MegaBrutal <megabrutal@gmail.com>
Date: Wed, 17 Jan 2018 18:35:00 +0100
Message-ID: <CAE8gLhkWRUO=UQh6cvM=D=7AYsuNxDG3yjUSCkuyTUVPnFW4Yw@mail.gmail.com>
Subject: Can rsync use reflink to synchronize directories?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

Does rsync support copying files with reflink on local btrfs file
system? Of course it could only work if the necessary conditions for
reflinking are met, but it would be very useful.


Regards,
MegaBrutal

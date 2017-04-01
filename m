Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:34014 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbdDAGGM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Apr 2017 02:06:12 -0400
Received: by mail-vk0-f49.google.com with SMTP id z204so106779449vkd.1
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Mar 2017 23:06:12 -0700 (PDT)
MIME-Version: 1.0
Reply-To: matianfu@gmail.com
From: UGlee <matianfu@gmail.com>
Date: Sat, 1 Apr 2017 14:06:11 +0800
Message-ID: <CAEgruXvAEBfpQaAxCi42Vq6v8w7v1dqthpn9TpE3FDDHoTWRcw@mail.gmail.com>
Subject: mix ssd and hdd in single volume
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We are working on a small NAS server for home user. The product is
equipped with a small fast SSD (around 60-120GB) and a large HDD (2T
to 4T).

We have two choices:

1. using bcache to accelerate io operation
2. combining SSD and HDD into a single btrfs volume.

Bcache is certainly designed for our purpose. But bcache requires
complex configuration and can only start from clean disk. Also in our
test in Ubuntu 16.04, data inconsistence was observed at least once,
resulting total HDD data lost.

So we wonder if simply putting SSD and HDD into a single btrfs volume,
in whatever mode, the general read operation (mostly readdir and
getxattr) will also be significantly faster than a single HDD without
SSD.

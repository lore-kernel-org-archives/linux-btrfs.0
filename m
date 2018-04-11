Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:33873 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751409AbeDKKWY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 06:22:24 -0400
Received: by mail-yw0-f169.google.com with SMTP id h14so383219ywm.1
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 03:22:24 -0700 (PDT)
MIME-Version: 1.0
From: Ilan Schwarts <ilan84@gmail.com>
Date: Wed, 11 Apr 2018 13:22:23 +0300
Message-ID: <CAJUuSvEgV0NU8Gu89eM=pM4mnYtKZgyNG31BASeHkiuH6Xj_nA@mail.gmail.com>
Subject: error: redefinition of 'struct btrfs_ioctl_defrag_range_args
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi
While trying to compile my kernel module on suse 12.2 kernel
4.4.103-92.53-default
I recieve the following warning: error: redefinition of 'struct
btrfs_ioctl_defrag_range_args
I see that struct is defined in 2 places:
/lib/modules/4.4.103-92.53-default/source/fs/btrfs/ctree.h:1985:8
/usr/src/linux-4.4.103-92.53/include/uapi/linux/btrfs.h:497:8

Why is it defined in 2 places ?
No one else is getting that warning (which treated as error for me) ?

Thanks

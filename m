Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:56687 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753002AbdKBFum (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 01:50:42 -0400
Received: by mail-vk0-f42.google.com with SMTP id g11so2860047vkd.13
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Nov 2017 22:50:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <92334609-a0a2-6cb4-5127-0c3767917ad2@gmx.com>
References: <CAKuJGC8M3NFbZ5Ky0gsuwz3oioCayPWK+JcxtC+BZ9=DuG4TXw@mail.gmail.com>
 <92334609-a0a2-6cb4-5127-0c3767917ad2@gmx.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Thu, 2 Nov 2017 11:20:01 +0530
Message-ID: <CAKuJGC_pagdiUy-csrK4G1KL01iib+CVdtW5wwd8dsiWTjrysQ@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/ctree.h:3457!
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>
> I'll try to reproduce it with FS_CHECK_INTEGRITY enabled.
>

Okay thanks for the details.  Here's the kernel config file which hits
this issue:
https://github.com/Lakshmipathi/btrfsqa/blob/master/setup/config/kernel.config#L3906

thanks!
----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org

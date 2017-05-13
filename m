Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:36560 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752043AbdEMNiR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 May 2017 09:38:17 -0400
Received: by mail-vk0-f54.google.com with SMTP id p85so9053487vkd.3
        for <linux-btrfs@vger.kernel.org>; Sat, 13 May 2017 06:38:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <fdd3a98e-1c7c-2339-ece1-ea71977594d9@cn.fujitsu.com>
References: <20170330062116.14379-1-quwenruo@cn.fujitsu.com> <fdd3a98e-1c7c-2339-ece1-ea71977594d9@cn.fujitsu.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Sat, 13 May 2017 19:07:36 +0530
Message-ID: <CAKuJGC-R=5j=rzMJioBtftq1305wpT1tcy+WuRzTv9+Q065qvQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/19] Btrfs-progs offline scrub
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>, "dsterba@suse.cz" <dsterba@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>
> Ping?
>
> Any comments?
>
> Thanks,
> Qu

Can  I inject corruption with existing script [1] and expect offline
scrub to fix it? If so, I'll give it try and let you know the results.

[1] https://patchwork.kernel.org/patch/9583455/

----
Cheers,
Lakshmipathi.G

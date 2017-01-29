Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:33397 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751231AbdA2P6q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Jan 2017 10:58:46 -0500
Received: by mail-ua0-f180.google.com with SMTP id i68so235424466uad.0
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jan 2017 07:57:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHMMHbe0MB0cVu9-tQgKu9pKpHqOrBx8bSKqF6fdDGvVqPRpTw@mail.gmail.com>
References: <CAHMMHbe4Py0JBxOQ7Z7Vv4r0UQ4ZJPKjKUXZqNo+Pdi6L_gAaw@mail.gmail.com>
 <CAHMMHbe0MB0cVu9-tQgKu9pKpHqOrBx8bSKqF6fdDGvVqPRpTw@mail.gmail.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Sun, 29 Jan 2017 21:27:03 +0530
Message-ID: <CAKuJGC8dEBj+promXTA=zgvnVA8F9P7PW2xTJwECwAs1oYpaPQ@mail.gmail.com>
Subject: Re: Raid1 won't mount degraded
To: Subscription Account <4subsacct+btrfs@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>powered off the system added a
>new disk

>root@NAS:~# btrfs fi show
>Label: none  uuid: f89c12fb-2304-4dce-bed5-fda008b86bde
>       Total devices 2 FS bytes used 2.49TiB
>      devid    1 size 2.73TiB used 2.52TiB path /dev/sdb1
>     *** Some devices missing

Are you sure 'device add' was successful? Whats the new  device name?
'btrfs fi show' shows only device (sdb1).



----
Cheers,
Lakshmipathi.G

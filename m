Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:35197 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751258AbdA2QCz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Jan 2017 11:02:55 -0500
Received: by mail-qk0-f196.google.com with SMTP id u25so15486537qki.2
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jan 2017 08:02:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKuJGC8dEBj+promXTA=zgvnVA8F9P7PW2xTJwECwAs1oYpaPQ@mail.gmail.com>
References: <CAHMMHbe4Py0JBxOQ7Z7Vv4r0UQ4ZJPKjKUXZqNo+Pdi6L_gAaw@mail.gmail.com>
 <CAHMMHbe0MB0cVu9-tQgKu9pKpHqOrBx8bSKqF6fdDGvVqPRpTw@mail.gmail.com> <CAKuJGC8dEBj+promXTA=zgvnVA8F9P7PW2xTJwECwAs1oYpaPQ@mail.gmail.com>
From: Subscription Account <4subsacct+btrfs@gmail.com>
Date: Sun, 29 Jan 2017 11:02:43 -0500
Message-ID: <CAHMMHbd_q2wT7OSKezHUpZF=3Uvytndvab8S5GkATrF64t0i6A@mail.gmail.com>
Subject: Re: Raid1 won't mount degraded
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: Subscription Account <4subsacct+btrfs@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 29, 2017 at 10:57 AM, Lakshmipathi.G
<lakshmipathi.g@gmail.com> wrote:
>>powered off the system added a
>>new disk
>
>>root@NAS:~# btrfs fi show
>>Label: none  uuid: f89c12fb-2304-4dce-bed5-fda008b86bde
>>       Total devices 2 FS bytes used 2.49TiB
>>      devid    1 size 2.73TiB used 2.52TiB path /dev/sdb1
>>     *** Some devices missing
>
> Are you sure 'device add' was successful? Whats the new  device name?
> 'btrfs fi show' shows only device (sdb1).
>

I haven't been able to get to the device add stage since I cannot
mount degraded :(.

>
>
> ----
> Cheers,
> Lakshmipathi.G

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io1-f41.google.com ([209.85.166.41]:36279 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727724AbeITVzz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 17:55:55 -0400
Received: by mail-io1-f41.google.com with SMTP id q5-v6so7930633iop.3
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2018 09:11:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOc3t=ssEVxn5Z-WN2fFRuEde=UeGNZEFUz+yawn6O-6D3t7oA@mail.gmail.com>
References: <CAOc3t=v+ZTN7wZRSZO0afx5BVJYzrorD3HWoWkeJyUoUZ2KoTg@mail.gmail.com>
 <53806b04-c239-cb23-1d8a-e84d7453950a@gmx.com> <CAOc3t=ssEVxn5Z-WN2fFRuEde=UeGNZEFUz+yawn6O-6D3t7oA@mail.gmail.com>
From: "Zbigniew 'zibi' Jarosik" <zibi@nora.pl>
Date: Thu, 20 Sep 2018 18:11:42 +0200
Message-ID: <CAOc3t=t1dVGsXBnHJobNX5hgmUO+QKtY5ztioLRtn893WnAyVg@mail.gmail.com>
Subject: Re: cannot mount btrfs as root
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20 September 2018 at 08:20, Zbigniew 'zibi' Jarosik <zibi@nora.pl> wrote:
> On 19 September 2018 at 15:54, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>> Does the iniramfs do a "btrfs dev scan" to make populate btrfs devices
>> lists?
>
> This solved problem. Looks like btrfs scans disks to early, before
> bcache initializes. I need to debug initrfamfs scripts.

There is race condition - bcache initalizes slower than expected, so
btrfs cannot find devices, because they are not ready.

rootdelay=10 in grub solved problem temporary, need to write
boot-script that will handle it and wait until bcache devices will be
ready to use.


-- 
Zbigniew 'zibi' Jarosik
cell: +48 667956686
jid: tapiau@gmail.com
gg: 2830
http://zibi.nora.pl/

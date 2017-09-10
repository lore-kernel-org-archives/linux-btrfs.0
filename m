Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:36580 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751483AbdIJTR3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 15:17:29 -0400
Received: by mail-lf0-f51.google.com with SMTP id m199so14086108lfe.3
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Sep 2017 12:17:29 -0700 (PDT)
Subject: Re: Help me understand what is going on with my RAID1 FS
To: Dmitrii Tcvetkov <demfloro@demfloro.ru>, FLJ <feci2048@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAOsOv4morDsVyrWEitL8L+7mXjS+0mXXsd9213Y8cdR44qrLYg@mail.gmail.com>
 <1F3219B0-72B2-4201-8C96-E6FBFD02A413@demfloro.ru>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <bae7bedb-4f3a-3779-e6c7-9d3879cb1d27@gmail.com>
Date: Sun, 10 Sep 2017 22:17:26 +0300
MIME-Version: 1.0
In-Reply-To: <1F3219B0-72B2-4201-8C96-E6FBFD02A413@demfloro.ru>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

10.09.2017 19:11, Dmitrii Tcvetkov пишет:
>> Actually based on http://carfax.org.uk/btrfs-usage/index.html I
>> would've expected 6 TB of usable space. Here I get 6.4 which is odd,
>> but that only 1.5 TB is available is even stranger.
>>
>> Could anyone explain what I did wrong or why my expectations are wrong?
>>
>> Thank you in advance
> 
> I'd say df and the website calculate different things. In btrfs raid1 profile stores exactly 2 copies of data, each copy is on separate device. 
> So by adding third drive, no matter how big, effective free space didn't expand because btrfs still needs space on any one of other two drives to store second half of each raid1 chunk stored on that third drive. 
> 
> Basically:
> 
> Drive1      Drive2    Drive3
> X           X
> X                         X
>             X             X
> 
> Where X is a chunk of raid1 block group.

But this table clearly shows that adding third drive increases free
space by 50%. You need to reallocate data to actually make use of it,
but it was done in this case.

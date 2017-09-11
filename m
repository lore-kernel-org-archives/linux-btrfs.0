Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34459 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbdIKITG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 04:19:06 -0400
Received: by mail-pf0-f195.google.com with SMTP id g65so4385488pfe.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 01:19:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e7dd3f37-6088-c8e7-0c96-c7d5d612d29e@gmail.com>
References: <CAOsOv4morDsVyrWEitL8L+7mXjS+0mXXsd9213Y8cdR44qrLYg@mail.gmail.com>
 <1F3219B0-72B2-4201-8C96-E6FBFD02A413@demfloro.ru> <bae7bedb-4f3a-3779-e6c7-9d3879cb1d27@gmail.com>
 <20170910231727.65bbb2aa@demfloro.ru> <e7dd3f37-6088-c8e7-0c96-c7d5d612d29e@gmail.com>
From: FLJ <feci2048@gmail.com>
Date: Mon, 11 Sep 2017 10:18:25 +0200
Message-ID: <CAOsOv4nbUsaHisu9yGKJ8TsTaYwLwq80Hs7_t-dbtUStESwu1g@mail.gmail.com>
Subject: Re: Help me understand what is going on with my RAID1 FS
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Dmitrii Tcvetkov <demfloro@demfloro.ru>, FLJ <feci2048@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks everyone for the helpful and detailed responses.
Now that you confirmed that everything is fine with my FS, I'm all
relaxed because I can for sure live with the output of df.



On Mon, Sep 11, 2017 at 5:29 AM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 10.09.2017 23:17, Dmitrii Tcvetkov пишет:
>>>> Drive1      Drive2    Drive3
>>>> X           X
>>>> X                         X
>>>>             X             X
>>>>
>>>> Where X is a chunk of raid1 block group.
>>>
>>> But this table clearly shows that adding third drive increases free
>>> space by 50%. You need to reallocate data to actually make use of it,
>>> but it was done in this case.
>>
>> It increases it but I don't see how this space is in any way useful
>> unless data is in single profile. After full balance chunks will be
>> spread over 3 devices, how it helps in raid1 data profile case?
>>
> A1 A2  => A1 A2 - => A1 A2 B1 => A1 A2 B1
> B1 B2     B1 B2 -    -  B2  -    C1 B2 C2
>
> It is raid1 profile on three disks fully utilizing them (assuming equal
> sizes of course). Where "raid1" means - each data block has two copies
> on different devices.

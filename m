Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:35337 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752133AbdIKD30 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 23:29:26 -0400
Received: by mail-lf0-f49.google.com with SMTP id d17so15310131lfe.2
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Sep 2017 20:29:25 -0700 (PDT)
Subject: Re: Help me understand what is going on with my RAID1 FS
To: Dmitrii Tcvetkov <demfloro@demfloro.ru>
Cc: FLJ <feci2048@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAOsOv4morDsVyrWEitL8L+7mXjS+0mXXsd9213Y8cdR44qrLYg@mail.gmail.com>
 <1F3219B0-72B2-4201-8C96-E6FBFD02A413@demfloro.ru>
 <bae7bedb-4f3a-3779-e6c7-9d3879cb1d27@gmail.com>
 <20170910231727.65bbb2aa@demfloro.ru>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <e7dd3f37-6088-c8e7-0c96-c7d5d612d29e@gmail.com>
Date: Mon, 11 Sep 2017 06:29:20 +0300
MIME-Version: 1.0
In-Reply-To: <20170910231727.65bbb2aa@demfloro.ru>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

10.09.2017 23:17, Dmitrii Tcvetkov пишет:
>>> Drive1      Drive2    Drive3
>>> X           X
>>> X                         X
>>>             X             X
>>>
>>> Where X is a chunk of raid1 block group.  
>>
>> But this table clearly shows that adding third drive increases free
>> space by 50%. You need to reallocate data to actually make use of it,
>> but it was done in this case.
> 
> It increases it but I don't see how this space is in any way useful
> unless data is in single profile. After full balance chunks will be
> spread over 3 devices, how it helps in raid1 data profile case?
> 
A1 A2  => A1 A2 - => A1 A2 B1 => A1 A2 B1
B1 B2     B1 B2 -    -  B2  -    C1 B2 C2

It is raid1 profile on three disks fully utilizing them (assuming equal
sizes of course). Where "raid1" means - each data block has two copies
on different devices.

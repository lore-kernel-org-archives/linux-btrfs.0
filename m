Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:35981 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754169AbdBNQqP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 11:46:15 -0500
Received: by mail-it0-f50.google.com with SMTP id c7so40349052itd.1
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Feb 2017 08:46:15 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id z13sm552682ioz.3.2017.02.14.08.46.12
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Feb 2017 08:46:13 -0800 (PST)
Subject: Re: Unexpected behavior involving file attributes and snapshots.
References: <ea92c7c6-4b98-d683-eb66-593836bcc82a@gmail.com>
 <CAJCQCtQi56sVYccDPsVi8Av+FW=4SQjPpDskL0kJ-qY=P6rU1A@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <03288d87-0689-2cf5-0ab5-e625c97880dd@gmail.com>
Date: Tue, 14 Feb 2017 11:46:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQi56sVYccDPsVi8Av+FW=4SQjPpDskL0kJ-qY=P6rU1A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-14 11:07, Chris Murphy wrote:
> On Tue, Feb 14, 2017 at 8:30 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> I was just experimenting with snapshots on 4.9.0, and came across some
>> unexpected behavior.
>>
>> The simple explanation is that if you snapshot a subvolume, any files in the
>> subvolume that have the NOCOW attribute will not have that attribute in the
>> snapshot.  Some further testing indicates that this is the only file
>> attribute that isn't preserved (I checked all the chattr flags that BTRFS
>> supports).
>
> Huh, I can't reproduce this with 4.9.8 or 4.10rc7. systemd sets
> journal files with chattr +C, and I do manual snapshots of rootfs
> periodically, and those snapshots have journal files that have +C
> still set.
>
Just tested on a different filesystem, and I'm not seeing it there 
either, I'll take a closer look at the FS I saw this on and see if I can 
figure out what's up.


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:36554 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbdEVG1u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 May 2017 02:27:50 -0400
Received: by mail-vk0-f45.google.com with SMTP id p85so35345414vkd.3
        for <linux-btrfs@vger.kernel.org>; Sun, 21 May 2017 23:27:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <46db6693-3508-6845-e80f-0db1192d7bd2@cn.fujitsu.com>
References: <20170330062116.14379-1-quwenruo@cn.fujitsu.com>
 <fdd3a98e-1c7c-2339-ece1-ea71977594d9@cn.fujitsu.com> <CAKuJGC-R=5j=rzMJioBtftq1305wpT1tcy+WuRzTv9+Q065qvQ@mail.gmail.com>
 <46db6693-3508-6845-e80f-0db1192d7bd2@cn.fujitsu.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Mon, 22 May 2017 11:57:48 +0530
Message-ID: <CAKuJGC_LWzJKGPecweK93nXRm1=j22HkqZdUHrragwab6zAUDw@mail.gmail.com>
Subject: Re: [PATCH v3 00/19] Btrfs-progs offline scrub
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>, "dsterba@suse.cz" <dsterba@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When I ran the script, it produces below output. From the output it
looks like, it detected the error and corrected. But parity-block
corruption fix patch not yet merged or I missed something?

Run: (with scrub_offline repo)
btrfs scrub start /home/laks/centos/laks/BTRFS/scrub_offline/tests/mnt
scrub started on /home/laks/centos/laks/BTRFS/scrub_offline/tests/mnt,
fsid a5cf2e54-e8da-4570-8328-2cee46678de3 (pid=5943)
WARNING: errors detected during scrubbing, corrected.
Scrub corrected value: D1xxxxxxxxxxxxxx ##output from testscript
Scrub corrupted parity stripe.   ##output from testscript

(mkfs.btrfs -f -d raid5 -m raid5 /dev/loop18 /dev/loop19 /dev/loop20)

>>
>> Can  I inject corruption with existing script [1] and expect offline
>> scrub to fix it? If so, I'll give it try and let you know the results.
>>
>> [1] https://patchwork.kernel.org/patch/9583455/
>
> No fixing yet.
>
> This part is focusing on error detection and report.
>
> Feel free to inject corruption and to see if it behave as expected.
>
> Thanks,
> Qu
>
----
Cheers,
Lakshmipathi.G

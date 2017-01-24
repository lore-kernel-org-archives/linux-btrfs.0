Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:33444 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750871AbdAXVVR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 16:21:17 -0500
Received: by mail-ua0-f175.google.com with SMTP id i68so144293319uad.0
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 13:21:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHj_TLC5Fgzkd49wvU-6WDO-mbqnZs6MUwxje+0vowCcUJLmsw@mail.gmail.com>
References: <CAHj_TLC5Fgzkd49wvU-6WDO-mbqnZs6MUwxje+0vowCcUJLmsw@mail.gmail.com>
From: =?UTF-8?B?T3R0byBLZWvDpGzDpGluZW4=?= <otto@seravo.fi>
Date: Tue, 24 Jan 2017 23:20:21 +0200
Message-ID: <CAHj_TLDn6EkZ5B3UwnLwtWOKNhcw9WtCFVHHx6tAiQ-LRRt1Jg@mail.gmail.com>
Subject: Re: btrfs-check: Fix bitflipped keys from bad RAM
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-06-28 23:11 GMT+03:00 Otto Kekäläinen <otto@seravo.fi>:
> Hello!
>
> A patch with this subject was submitted in May 2014:
> http://www.spinics.net/lists/linux-btrfs/msg33777.html
>
> I don't see it among any of the ~360 open issues at
> https://bugzilla.kernel.org/buglist.cgi?bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&component=btrfs
>
> Unless somebody objects, I'll file it as a NEW issue with patch.
>
>
> I think the work done by Hugo Mills for this one is important and it
> would be a pity if those patches were forgotten. It is one of those
> things where btrfs could outperform zfs, which has not bitflip
> recovery. Btrfs could have one, and it would be great.
>
> I personally came across a machine with a bitflipped index and I would
> love to test these patches. I am however reluctant to invest time in
> it if there is no issue in the bug tracker and no visible progress.
> Without proper tracking all debugging/feedback would go in vain.

I eventually went ahead and filed this as
https://bugzilla.kernel.org/show_bug.cgi?id=17447

It would be very cool if the bitflip recovery patch was merged. It is
one of those
things where btrfs could outperform zfs.

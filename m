Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:43251 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933825AbeBMKWB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 05:22:01 -0500
Received: by mail-lf0-f43.google.com with SMTP id q69so6541974lfi.10
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 02:22:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e8d681cb-aa1b-6395-f968-38e8425ed8fb@cn.fujitsu.com>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
 <55C1F3DD.7020603@gmail.com> <CAJ3TwYSW+SvbBrh1u_x+c3HTRx03qSR6BoH5cj_VzCXxZYv6EA@mail.gmail.com>
 <126f9f09-4e28-3c12-5384-63032e17942f@cn.fujitsu.com> <CAJ3TwYRXwDVVfT0TRRiM9dEw-7TvY8qG=WvMYKczZOv6wkFWAQ@mail.gmail.com>
 <fd718727-9b54-ba58-5f39-63066181d13e@cn.fujitsu.com> <CAJ3TwYSTnQfj=qmBLtnmtXQKexMMD4x=9Gk3p3anf4uF+G26kw@mail.gmail.com>
 <CAJ3TwYTnMPVwkrZEU-=Q_Nq+9Bn0vM3z+EFC8RP=RTyaufSoqw@mail.gmail.com>
 <5cc93522-1bd2-bdc1-d5da-a11d5e4816a7@cn.fujitsu.com> <CAJ3TwYRpc_R-wVur0T6+Uy_aPVXTGpvp_ag1Ar9K2HoB0H1ySQ@mail.gmail.com>
 <799054c4-b4f5-2dc0-4f70-4345159d9078@cn.fujitsu.com> <CAJ3TwYRH8JVkuv2Hu7FYb+BSwKGrq1spx079zwOF_FO1y=9NFA@mail.gmail.com>
 <e51aaa6e-a4b9-c187-84fa-c57799865b0e@cn.fujitsu.com> <CAJ3TwYS6UTkWf=PNku3RG7hPrXMKz3yhk2WqCRLix4v_VwgrmA@mail.gmail.com>
 <36291cd0-64bc-8708-9e23-0aac30539785@cn.fujitsu.com> <CAJ3TwYQ47SVpbO1Pb-TWjhaTCCpMFFmijwTgmV8=7+1_a6_3Ww@mail.gmail.com>
 <e8d681cb-aa1b-6395-f968-38e8425ed8fb@cn.fujitsu.com>
From: John Ettedgui <john.ettedgui@gmail.com>
Date: Tue, 13 Feb 2018 02:21:58 -0800
Message-ID: <CAJ3TwYRgHfCNxKwWnfWXr=w_mBo2B2AuSDeE+PgYEtn7kyAx7w@mail.gmail.com>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 21, 2016 at 1:19 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> No more.
>
> The dump is already good enough for me to dig for some time.
>
> We don't usually get such large extent tree dump from a real world use case.
>
> It would help us in several ways, from determine how fragmented a block
> group is to determine if a defrag will help.
>
> Thanks,
> Qu
>
>


Hello there,

have you found anything good since then?
With a default system, the behavior is pretty much still the same,
though I have not recreated the partitions since.

Defrag helps, but I think balance helps even more.
clear_cache may help too, but I'm not really sure as I've not tried it
on its own.
I was actually able to get a 4TB partition on a 5400rpm HDD to mount
in around 500ms, quite faster that even some Gb partitions I have on
SSDs! Alas I wrote some files to it and it's taking over a second
again, so no more magic there.

The workarounds do work, so it's still not a major issue, but they're
slow and sometimes I have to workaround the "no space left on device"
which then takes even more time.

Thank you!
John

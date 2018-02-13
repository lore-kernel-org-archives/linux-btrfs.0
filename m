Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:34495 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935077AbeBMMwg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 07:52:36 -0500
Received: by mail-lf0-f41.google.com with SMTP id k19so24947342lfj.1
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 04:52:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <00946e24-cf79-92c0-9e70-5425b4b06b7c@gmx.com>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
 <CAJ3TwYTnMPVwkrZEU-=Q_Nq+9Bn0vM3z+EFC8RP=RTyaufSoqw@mail.gmail.com>
 <5cc93522-1bd2-bdc1-d5da-a11d5e4816a7@cn.fujitsu.com> <CAJ3TwYRpc_R-wVur0T6+Uy_aPVXTGpvp_ag1Ar9K2HoB0H1ySQ@mail.gmail.com>
 <799054c4-b4f5-2dc0-4f70-4345159d9078@cn.fujitsu.com> <CAJ3TwYRH8JVkuv2Hu7FYb+BSwKGrq1spx079zwOF_FO1y=9NFA@mail.gmail.com>
 <e51aaa6e-a4b9-c187-84fa-c57799865b0e@cn.fujitsu.com> <CAJ3TwYS6UTkWf=PNku3RG7hPrXMKz3yhk2WqCRLix4v_VwgrmA@mail.gmail.com>
 <36291cd0-64bc-8708-9e23-0aac30539785@cn.fujitsu.com> <CAJ3TwYQ47SVpbO1Pb-TWjhaTCCpMFFmijwTgmV8=7+1_a6_3Ww@mail.gmail.com>
 <e8d681cb-aa1b-6395-f968-38e8425ed8fb@cn.fujitsu.com> <CAJ3TwYRgHfCNxKwWnfWXr=w_mBo2B2AuSDeE+PgYEtn7kyAx7w@mail.gmail.com>
 <87975474-0cb9-13d7-f623-c0622b31f437@gmx.com> <CAJ3TwYQ-GgZCCoD07AgQ0EDtpOknt3Ta1=WNAH7sSvXO3R-u8w@mail.gmail.com>
 <a27b619e-6e39-20e6-413e-c9d5c7a90b6f@gmx.com> <CAJ3TwYTAhOc1eRUC_FoUFjpC=Ys_DRbHBp9NW6EdVSXArqiMww@mail.gmail.com>
 <00946e24-cf79-92c0-9e70-5425b4b06b7c@gmx.com>
From: John Ettedgui <john.ettedgui@gmail.com>
Date: Tue, 13 Feb 2018 04:52:33 -0800
Message-ID: <CAJ3TwYS0o_kUL7axbvW9N7mfHXn22Ozv7RiE6z3TM1UWx_Q7GA@mail.gmail.com>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 13, 2018 at 4:46 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018年02月13日 20:06, John Ettedgui wrote:
>>>>>
>>>> That's fairly straightforward to do, though it should be quite slow so
>>>> I'd hope not to have to do that too often.
>>>
>>> Then it could be tried on the most frequently updated files then.
>>
>> That's an interesting idea.
>> More than 3/4 of the data is just storage, so that should be very ok.
>
> BTW, how the initial data is created?
>
> If the initial data is all written once and doesn't get modified later,
> then the problem may not be fragments.
>
Mostly at once when I recreated the FS a few years ago, and then
adding on to it slowly.
Though I do try to somewhat balance the free space on all partitions
of similar drives, so it may be a tad further more from its original
condition.

>>
>>>
>>> And since you don't use snapshot, locate such files and then "chattr +C"
>>> would make them nodatacow, reducing later fragments.
>>
>> I don't understand, why would that reduce later fragments?
>
> Later overwrite will not create new extent, but overwrite existing extents.
> Other than CoW and cause new extents (fragments)
>
> Although expand write will still cause new extent, but that's
> unavoidable anyway.
>
That's why I didn't understand.
Fair enough!

Thank you!
John

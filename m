Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:33442 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752774AbdKWJI5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 04:08:57 -0500
Received: by mail-oi0-f43.google.com with SMTP id f135so12753521oib.0
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Nov 2017 01:08:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4799dfcb-2a05-f1f5-8f08-285b5dec3488@gmx.com>
References: <CAHzMYBQ7tsHFuHkJ5zjK6Wx0bD0XHp0TGti_uJNV5pz4ak7wJA@mail.gmail.com>
 <CAJCQCtQpCJc1h8qnLv6M_aMf-0q_9saNwCrNwt1HML1jFLHq8g@mail.gmail.com> <4799dfcb-2a05-f1f5-8f08-285b5dec3488@gmx.com>
From: Jorge Bastos <jorge.mrbastos@gmail.com>
Date: Thu, 23 Nov 2017 09:08:56 +0000
Message-ID: <CAHzMYBRQyrb+PDESNohKB5L=qBz369nFcHFwx0im4njTLJOL6g@mail.gmail.com>
Subject: Re: btrfs restore corrupt file
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the replies.

Good to know it's working as expected, and I'm glad restore permits
restoring a corrupt file since this may be desirable in some cases,
but agree with Chris that it would be nice to get a warning if
corruption is found or suspected.

Jorge

On Thu, Nov 23, 2017 at 7:43 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2017年11月23日 13:25, Chris Murphy wrote:
>> On Wed, Nov 22, 2017 at 12:18 PM, Jorge Bastos <jorge.mrbastos@gmail.com> wrote:
>>> Hello,
>>>
>>> While doing btrfs checksum testing I purposely corrupted a file and
>>> got the expect I/O error when trying to copy it, I also tested btrfs
>>> restore to see if I could recover a known corrupt file and it did copy
>>> it but there was no checksum error or warning. I used btrfs restore -v
>>>
>>> Is this expect behavior or should restore warn about checksum failures?
>>>
>>> Kernel used was 4.13.13,  btrfs-progs v4.13.2
>>
>> I think it's expected. "The checks done by restore are less strict"
>> from the man page. Although it'd be nice if -v option at least could
>> flag such files as possibly being corrupt.
>>
> I think people always consider "btrfs restore" as a tool to "restore" data.
>
> The proper name of it should be "salvage" and moved under "btrfs
> rescue", to reduce the confusion.
>
> Thanks,
> Qu
>

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:34689 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754141AbdFWRUz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Jun 2017 13:20:55 -0400
Received: by mail-wr0-f173.google.com with SMTP id 77so74431713wrb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Jun 2017 10:20:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANp8-fwAcNT735JTfmtK2T8YRg_WASZwT41pt8b0W9+uWDT3gA@mail.gmail.com>
References: <CANp8-fwAcNT735JTfmtK2T8YRg_WASZwT41pt8b0W9+uWDT3gA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 23 Jun 2017 11:20:52 -0600
Message-ID: <CAJCQCtQwJw9gU5nqftvUkBHxhgX9+rLGhxjMmUmAed-SS_vK+Q@mail.gmail.com>
Subject: Re: btrfs fi usage crash when multiple device volume contains seed device
To: "Cengiz C." <cengizc@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 23, 2017 at 3:46 AM, Cengiz C. <cengizc@gmail.com> wrote:
> Hello Chris,
>
> Sorry, I'm a newbie on LKML flow, I didn't copy you while replying.
>
> If you have any spare time to talk about this issue, I'd be extremely happy.
>
> Thanks again
>
> On Sun, Jun 18, 2017 at 10:12 PM, Cengiz Can <cengizc@gmail.com> wrote:
>> Hello,
>>
>> How should we proceed on this?
>>
>> I want to deep dive and contribute to btrfs and its toolings with this issue
>> but I don't have enough experience with them.
>>
>> As far as I understand, fixing this would require some design decisions
>> which I hope to hear in this thread soon.

No idea how to proceed. Anand Jain understands the issues related to
seed devices much better than I do. The multiple device stuff is
always complicated.



-- 
Chris Murphy

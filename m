Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:36779 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932241AbcIAOhy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 10:37:54 -0400
Received: by mail-oi0-f49.google.com with SMTP id r205so39239059oih.3
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Sep 2016 07:37:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <SY3PR01MB13864A03DC2503EF7E0381A49EE20@SY3PR01MB1386.ausprd01.prod.outlook.com>
References: <CAJCQCtT5YA9EMq1ZC-qeZcNLUeg1GocBm3nT2nZFEBigmV4BxQ@mail.gmail.com>
 <CAJCQCtQjX+0nAWRNPK2gYNoi8wvHxTMEzm6v84PZKXnTLxc50Q@mail.gmail.com>
 <CAJCQCtT0=gEwBerYXYnyueMk3JnmGZp71qBJFB5N4qR4ASF7cg@mail.gmail.com>
 <CAJCQCtRZNNTZ5ymH-X9Cq=h+_aaATym40W42BJ-xM5ECJOQnDg@mail.gmail.com>
 <CAJCQCtTo7nS7grh-9XWTKXX_h2pXPXCbLMRGmTfa=NzHq2Aa6g@mail.gmail.com>
 <CAJCQCtS374FCEqSx0qBdF1oa6=y48A4p0pMN0u456adQETyS_Q@mail.gmail.com> <SY3PR01MB13864A03DC2503EF7E0381A49EE20@SY3PR01MB1386.ausprd01.prod.outlook.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 1 Sep 2016 08:37:51 -0600
Message-ID: <CAJCQCtTMrA=CutAMjXy+_CPqLGyfwCfYnpug1rAJuLQWv2rKDA@mail.gmail.com>
Subject: Re: btrfs-progs 4.7, check reports many "incorrect local backref
 count" messages
To: Paul Jones <paul@pauljones.id.au>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 1, 2016 at 12:51 AM, Paul Jones <paul@pauljones.id.au> wrote:
>> -----Original Message-----
>> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
>> owner@vger.kernel.org] On Behalf Of Chris Murphy
>> Sent: Thursday, 1 September 2016 7:59 AM
>> To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
>> Subject: Re: btrfs-progs 4.7, check reports many "incorrect local backref
>> count" messages
>>
>> This is still happening with btrfs-progs 4.7.1 and there is zero information in
>> the long result what to do about the problem, and whether it's sane to try
>> have --repair fix it, let alone what the original cause of the problem was.
>
> I just potentially damaged a perfectly good filesystem because of this. I was getting hundreds of "Incorrect local backref count" so I decided to try repair, which seemed to complete ok. I then rescanned without repair and btrfs check eventually crashed with an assertion. That's when I figured something may be wrong.

Wait, so you did a --repair and then the following-up check crashes?
But does the file system mount and does it still work? The first is
bad enough, but if it won't mount this is terrible.



-- 
Chris Murphy

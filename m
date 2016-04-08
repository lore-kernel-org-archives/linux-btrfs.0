Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:33763 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbcDHSTv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2016 14:19:51 -0400
Received: by mail-qg0-f46.google.com with SMTP id j35so97239393qge.0
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Apr 2016 11:19:50 -0700 (PDT)
Subject: Re: unable to mount btrfs pool even with -oro,recovery,degraded,
 unable to do 'btrfs restore'
To: Chris Murphy <lists@colorremedies.com>
References: <CAFKQ2BsxWYejWOPMCw5JuF-SXM03-papUu6LXM5KBNKthxAPxg@mail.gmail.com>
 <CAJCQCtQCLWca9YycOSTC8Q4c78a8AVe7uFXAoe2vqEUQVFHiNA@mail.gmail.com>
 <57064231.2070201@gmail.com>
 <CAJCQCtSAaTYYMJhTTAsEXXDUzUdLEpJARHPRfihDNZrvZtEo4Q@mail.gmail.com>
 <5707961D.6000803@gmail.com>
 <CAJCQCtQwNDoB75XYdsdcvedbnc1ox3YOi8aaiw0DZ=1Q=21WBw@mail.gmail.com>
Cc: Ank Ular <ankular.anime@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5707F602.9020504@gmail.com>
Date: Fri, 8 Apr 2016 14:18:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQwNDoB75XYdsdcvedbnc1ox3YOi8aaiw0DZ=1Q=21WBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-08 14:05, Chris Murphy wrote:
> On Fri, Apr 8, 2016 at 5:29 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>> I entirely agree.  If the fix doesn't require any kind of decision to be
>> made other than whether to fix it or not, it should be trivially fixable
>> with the tools.  TBH though, this particular issue with devices disappearing
>> and reappearing could be fixed easier in the block layer (at least, there
>> are things that need to be fixed WRT it in the block layer).
>
> Another feature needed for transient failures with large storage, is
> some kind of partial scrub, along the lines of md partial resync when
> there's a bitmap write intent log.
>
In this case, I would think the simplest way to do this would be to have 
scrub check if generation matches and not further verify anything that 
does (I think we might be able to prune anything below objects whose 
generation matches, but I'm not 100% certain about how writes cascade up 
the trees).  I hadn't really thought about this before, but now that I 
do, it kind of surprises me that we don't have something to do this.


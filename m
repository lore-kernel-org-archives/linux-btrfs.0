Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36048 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbcDHSaP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2016 14:30:15 -0400
Received: by mail-io0-f195.google.com with SMTP id s2so17450826iod.3
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Apr 2016 11:30:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5707F602.9020504@gmail.com>
References: <CAFKQ2BsxWYejWOPMCw5JuF-SXM03-papUu6LXM5KBNKthxAPxg@mail.gmail.com>
	<CAJCQCtQCLWca9YycOSTC8Q4c78a8AVe7uFXAoe2vqEUQVFHiNA@mail.gmail.com>
	<57064231.2070201@gmail.com>
	<CAJCQCtSAaTYYMJhTTAsEXXDUzUdLEpJARHPRfihDNZrvZtEo4Q@mail.gmail.com>
	<5707961D.6000803@gmail.com>
	<CAJCQCtQwNDoB75XYdsdcvedbnc1ox3YOi8aaiw0DZ=1Q=21WBw@mail.gmail.com>
	<5707F602.9020504@gmail.com>
Date: Fri, 8 Apr 2016 12:30:08 -0600
Message-ID: <CAJCQCtSBX1Uk2Ojx0=tePGGO9tdS+6691cM9Gy=K7RK7HAZVoQ@mail.gmail.com>
Subject: Re: unable to mount btrfs pool even with -oro,recovery,degraded,
 unable to do 'btrfs restore'
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Ank Ular <ankular.anime@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 8, 2016 at 12:18 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-04-08 14:05, Chris Murphy wrote:
>>
>> On Fri, Apr 8, 2016 at 5:29 AM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>
>>> I entirely agree.  If the fix doesn't require any kind of decision to be
>>> made other than whether to fix it or not, it should be trivially fixable
>>> with the tools.  TBH though, this particular issue with devices
>>> disappearing
>>> and reappearing could be fixed easier in the block layer (at least, there
>>> are things that need to be fixed WRT it in the block layer).
>>
>>
>> Another feature needed for transient failures with large storage, is
>> some kind of partial scrub, along the lines of md partial resync when
>> there's a bitmap write intent log.
>>
> In this case, I would think the simplest way to do this would be to have
> scrub check if generation matches and not further verify anything that does
> (I think we might be able to prune anything below objects whose generation
> matches, but I'm not 100% certain about how writes cascade up the trees).  I
> hadn't really thought about this before, but now that I do, it kind of
> surprises me that we don't have something to do this.
>


And I need to better qualify this: this scrub (or balance) needs to be
initiated automatically, perhaps have some reasonable delay after the
block layer informs Btrfs the missing device as reappeared. Both the
requirement of a full scrub as well as it being a manual scrub, are
pretty big gotchas.


-- 
Chris Murphy

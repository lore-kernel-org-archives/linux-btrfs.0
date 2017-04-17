Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:36455 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757362AbdDQTXB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Apr 2017 15:23:01 -0400
Received: by mail-lf0-f51.google.com with SMTP id c80so19523544lfh.3
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Apr 2017 12:22:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170417232419.04474015@natsu>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com> <CAJCQCtS=xqcWMqiRxC_uoqTRUaW6aMwayoqjtMqq6XhcCJNVRg@mail.gmail.com>
 <8f046fa5-a458-9db8-b616-907afd34383b@gmail.com> <20170417232419.04474015@natsu>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Mon, 17 Apr 2017 21:22:54 +0200
Message-ID: <CAK5rZE548XNECYL5PaEqT01-tvpKbnyfKvf0ZekpcLwqsZ_V6w@mail.gmail.com>
Subject: Re: Btrfs/SSD
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/17/17, Roman Mamedov <rm@romanrm.net> wrote:
> "Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:

>> * Compression should help performance and device lifetime most of the
>> time, unless your CPU is fully utilized on a regular basis (in which
>> case it will hurt performance, but still improve device lifetimes).

> Days are long gone since the end user had to ever think about device lifetimes
> with SSDs. Refer to endurance studies such as
> It has been demonstrated that all SSDs on the market tend to overshoot even
> their rated TBW by several times, as a result it will take any user literally
> dozens of years to wear out the flash no matter which filesystem or what
> settings used. And most certainly it's not worth it changing anything
> significant in your workflow (such as enabling compression if it's
> otherwise inconvenient or not needed) just to save the SSD lifetime.

Going over the thread following questions come to my mind:

- What exactly does btrfs ssd option does relative to plain mode?

- Most(all?) SSDs employ wear leveling. Isn't it? That is they are
constrantly remapping their blocks under the hood. So isn't it
meaningless to speak of some kind of a block forging/fragmentation/etc..
affect of any writing pattern?

- If it is so, Doesn't it mean that there is no better ssd usage strategy
other than minimizing the total bytes written? That is whatever we do,
if it contributes to this fact it is good, otherwise bad. Are all other things
are beyond any user control? Is there a recommended setting?

- How about "data retension" experiences? It is known that
new ssds can hold data safely for longer period. As they age
that margin gets shorter. As an extreme case if I write into a new
ssd and shelve it, can i get back my data back after 5 years?
How about a file written 5 years ago and never touched again although
rest of the ssd is in active use during that period?

- Yes may be lifetimes getting irrelevant. However TBW has
still direct relation with data retension capability.
Knowing that writing more data to a ssd can reduce the
"life time of your data" is something strange.

- But someone can come and say: Hey don't worry about
"data retension years". Because your ssd will already be dead
before data retension becomes a problem for you... Which is
relieving.. :)) Anyway what are your opinions?

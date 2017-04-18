Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34036 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752776AbdDRM0v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 08:26:51 -0400
Received: by mail-io0-f180.google.com with SMTP id a103so189132774ioj.1
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 05:26:50 -0700 (PDT)
Subject: Re: Btrfs/SSD
To: Imran Geriskovan <imran.geriskovan@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
 <CAJCQCtS=xqcWMqiRxC_uoqTRUaW6aMwayoqjtMqq6XhcCJNVRg@mail.gmail.com>
 <8f046fa5-a458-9db8-b616-907afd34383b@gmail.com>
 <20170417232419.04474015@natsu>
 <CAK5rZE548XNECYL5PaEqT01-tvpKbnyfKvf0ZekpcLwqsZ_V6w@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <340c087e-f0ba-36e8-a94a-50b0dbd3a810@gmail.com>
Date: Tue, 18 Apr 2017 08:26:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5rZE548XNECYL5PaEqT01-tvpKbnyfKvf0ZekpcLwqsZ_V6w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-17 15:22, Imran Geriskovan wrote:
> On 4/17/17, Roman Mamedov <rm@romanrm.net> wrote:
>> "Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:
>
>>> * Compression should help performance and device lifetime most of the
>>> time, unless your CPU is fully utilized on a regular basis (in which
>>> case it will hurt performance, but still improve device lifetimes).
>
>> Days are long gone since the end user had to ever think about device lifetimes
>> with SSDs. Refer to endurance studies such as
>> It has been demonstrated that all SSDs on the market tend to overshoot even
>> their rated TBW by several times, as a result it will take any user literally
>> dozens of years to wear out the flash no matter which filesystem or what
>> settings used. And most certainly it's not worth it changing anything
>> significant in your workflow (such as enabling compression if it's
>> otherwise inconvenient or not needed) just to save the SSD lifetime.
>
> Going over the thread following questions come to my mind:
>
> - What exactly does btrfs ssd option does relative to plain mode?
Assuming I understand what it does correctly, it prioritizes writing 
into larger, 2MB aligned chunks of free-space, whereas normal mode goes 
for 64k alignment.
>
> - Most(all?) SSDs employ wear leveling. Isn't it? That is they are
> constrantly remapping their blocks under the hood. So isn't it
> meaningless to speak of some kind of a block forging/fragmentation/etc..
> affect of any writing pattern?
Because making one big I/O request to fetch a file is faster than a 
bunch of small ones.  If your file is all in one extent in the 
filesystem, it takes less work to copy to memory than if you're pulling 
form a dozen places on the device.  This doesn't have much impact on 
light workloads, but when you're looking at heavy server workloads, it's 
big.
>
> - If it is so, Doesn't it mean that there is no better ssd usage strategy
> other than minimizing the total bytes written? That is whatever we do,
> if it contributes to this fact it is good, otherwise bad. Are all other things
> are beyond any user control? Is there a recommended setting?
As a general strategy, yes, that appears to be the case.  ON a specific 
SSD, it may not be.  For example, on the Crucial MX300's I have in most 
of my systems, the 'ssd' mount option actually makes things slower by 
anywhere from 2-10%.
>
> - How about "data retension" experiences? It is known that
> new ssds can hold data safely for longer period. As they age
> that margin gets shorter. As an extreme case if I write into a new
> ssd and shelve it, can i get back my data back after 5 years?
> How about a file written 5 years ago and never touched again although
> rest of the ssd is in active use during that period?
>
> - Yes may be lifetimes getting irrelevant. However TBW has
> still direct relation with data retension capability.
> Knowing that writing more data to a ssd can reduce the
> "life time of your data" is something strange.
Explaining this and your comment above requires a bit of understanding 
of how flash memory actually works.  The general structure of a single 
cell is that of a field-effect transistor (almost always a MOSFET) with 
a floating gate which consists of a bit of material electrically 
isolated from the rest of the transistor.  Data is stored by trapping 
electrons on this floating gate, but getting them there requires a 
strong enough current to break through the insulating layer that keeps 
it isolated from the rest of the transistor.  This process breaks down 
the insulating layer over time, making it easier for the electrons 
trapped in the floating gate to leak back into the rest of the 
transistor, thus losing data.

Aside from the write-based degradation of the insulating layer, there 
are other things that can cause it to break down or for the electrons to 
leak out, including very high temperatures (we're talking industrial 
temperatures here, not the type you're likely to see in most consumer 
electronics), strong electromagnetic fields (again, we're talking 
_really_ strong here, not stuff you're likely to see in most consumer 
electronics), cosmic background radiation, and even noise from other 
nearby cells being rewritten (known as a read disturb error, only an 
issue in NAND flash (but that's what all SSD's are these days)).
>
> - But someone can come and say: Hey don't worry about
> "data retension years". Because your ssd will already be dead
> before data retension becomes a problem for you... Which is
> relieving.. :)) Anyway what are your opinions?
On this in particular, my opinion is that that claim is bogus unless you 
have an SSD designed to brick itself after a fixed period of time.  That 
statement is about the same as saying that you don't need to worry about 
uncorrectable errors in ECC RAM because you'll lose entire chips before 
they ever happen.  In both cases, you should indeed be worrying more 
about catastrophic failure, but that's because it will have a bigger 
impact and is absolutely unavoidable (it will eventually happen, and 
there's not really anything you can do to prevent it from happening), 
but that does not mean you shouldn't worry about other failure modes, 
especially ones that still have a significant impact (and losing data in 
a persistent storage device generally qualifies as a significant impact).

This study by CMU [1] may be of particular interest, especially since it 
particularly worries about data retention rates, not device lifetime, 
and seems to indicate that the opposite of the above statement is in 
fact true if you don't do prophylactic rewrites.  Note that this has 
little to no bearing on my argument above (I stand by that argument 
irrespective of this study).

[1] 
https://users.ece.cmu.edu/~omutlu/pub/flash-memory-data-retention_hpca15.pdf

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36777 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbcFIRjZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jun 2016 13:39:25 -0400
Received: by mail-oi0-f54.google.com with SMTP id p204so74719055oih.3
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jun 2016 10:39:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <aa93e9e0-eade-085c-c955-2f7e433d92f8@gmail.com>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
	<aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com>
	<CAGQ70YeZzDgiT_v1Z0eGcWsn8prnji30hCkyjrBg8vNziLUkiQ@mail.gmail.com>
	<dd952b29-1bea-59e1-1857-418b86951b47@gmail.com>
	<pan$f0f75$1ba12fd1$de89e173$5dda67a@cox.net>
	<aa93e9e0-eade-085c-c955-2f7e433d92f8@gmail.com>
Date: Thu, 9 Jun 2016 11:39:23 -0600
Message-ID: <CAJCQCtR_s6qt_4PXRDu4e78KiaKM+SrTDB6WMw8MzZNuP+B5rA@mail.gmail.com>
Subject: Re: Recommended why to use btrfs for production?
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 9, 2016 at 5:38 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-06-09 02:16, Duncan wrote:
>>
>> Austin S. Hemmelgarn posted on Fri, 03 Jun 2016 10:21:12 -0400 as
>> excerpted:
>>
>>> As far as BTRFS raid10 mode in general, there are a few things that are
>>> important to remember about it:
>>> 1. It stores exactly two copies of everything, any extra disks just add
>>> to the stripe length on each copy.
>>
>>
>> I'll add one more, potentially very important, related to this one:
>>
>> Btrfs raid mode (any of them) works in relation to individual chunks,
>> *NOT* individual devices.
>>
>> What that means for btrfs raid10 in combination with the above exactly
>> two copies rule, is that it works rather differently than a standard
>> raid10, which can tolerate loss of two devices as long as they're from
>> the same mirror set, as the other mirror set will then still be whole.
>> Because with btrfs raid10 the mirror sets are dynamic per-chunk, loss of
>> a second device close to assures loss of data, because the very likely
>> true assumption is that both mirror sets will be affected for some
>> chunks, but not others.
>
> Actually, that's not _quite_ the case.  Assuming that you have an even
> number of devices, BTRFS raid10 will currently always span all the available
> devices with two striped copies of the data (if there's an odd number, it
> spans one less than the total, and rotates which one gets left out of each
> chunk).  This means that as long as all the devices are the same size and
> you have have stripes that are the full width of the array (you can end up
> with shorter ones if you have run in degraded mode or expanded the array),
> your probability of data loss per-chunk goes down as you add more devices
> (because the probability of a two device failure affecting both copies of a
> stripe in a given chunk decreases), but goes up as you add more chunks
> (because you then have to apply that probability for each individual chunk).
> Once you've lost one disk, the probability that losing another will
> compromise a specific chunk is:
> 1/(N - 1)
> Where N is the total number of devices.
> The probability that it will compromise _any_ chunk is:
> (1/(N - 1))/C
> Where C is the total number of chunks
> BTRFS raid1 mode actually has the exact same probabilities, but they apply
> even if you have an odd number of disks.

Yeah but somewhere there's a chunk that's likely affected by two
losses, with a probability much higher than for conventional raid10
where such a loss is very binary: if the loss is a mirrored pair, the
whole array and filesystem implodes; if the loss does not affect an
entire mirrored pair, the whole array survives.

The thing with Btrfs raid 10 is you can't really tell in advance to
what degree you have loss. It's not a binary condition, it has a gray
area where a lot of data can still be retrieved, but the instant you
hit missing data it's a loss, and if you hit missing metadata then the
fs will either go read only or crash, it just can't continue. So that
"walking on egg shells" behavior in a 2+ drive loss is really
different from a conventional raid10 where it's either gonna
completely work or completely fail.

-- 
Chris Murphy

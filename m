Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:33481 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbcD0QkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 12:40:09 -0400
Received: by mail-lf0-f43.google.com with SMTP id y84so56402962lfc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Apr 2016 09:40:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHaPQf1vpOqcXwM41_0U-vh9njtserYhydZHC9phCemiCptVPA@mail.gmail.com>
References: <CAHaPQf0-qh0sLpUotSdESi8W6dnMOBQPXVJvBP8f2sEj2MC9EA@mail.gmail.com>
	<pan$c3f48$4829429e$7ab0117b$7d124f52@cox.net>
	<571DFCF2.6050604@gmail.com>
	<pan$193a9$b381fd2b$1c0f329f$7b14e34b@cox.net>
	<571E154C.9060604@gmail.com>
	<CAHaPQf03yMAxMZRa=zr3Fjh_B+-ggwwuzRFwDsUyK3t=jW2WFw@mail.gmail.com>
	<571F4CD0.9050004@gmail.com>
	<CAHaPQf39H-JRhQmCssmgJ98RCxL_36poE_kObAmgmH6nkn4xoA@mail.gmail.com>
	<CAJCQCtQbCbR9V7z4jZCejbKLJyhBbtrZJmcQBkX=VnxReBf46g@mail.gmail.com>
	<5720A0E8.5000407@gmail.com>
	<CAHaPQf3cR4jXKziSCqp0CnrB6oKQoO=2kywsKuo7BLqHqBjBRw@mail.gmail.com>
	<5720E8FE.2000407@googlemail.com>
	<CAHaPQf1vpOqcXwM41_0U-vh9njtserYhydZHC9phCemiCptVPA@mail.gmail.com>
Date: Wed, 27 Apr 2016 10:40:07 -0600
Message-ID: <CAHaPQf1=rGHLTR17Q5e08X195KsErDrnjX38VOVPQw3jJY8kbQ@mail.gmail.com>
Subject: Re: Add device while rebalancing
From: Juan Alberto Cirez <jacirez@rdcsafety.com>
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Holger,
If this is so, then it leaves even confused. I was under the
impression that the driving imperative for the creation of btrfs was
to address the shortcomings of current filesystems (within the context
of distributed data). That the idea was to create a low level
filesystem that would be the primary choice as a block/brick layer for a
scale-out, distributed data storage...

On Wed, Apr 27, 2016 at 10:38 AM, Juan Alberto Cirez
<jacirez@rdcsafety.com> wrote:
> Holger,
> If this is so, then it leaves with even confused. I was under the
> impression that the driving imperative for the creation of btrfs was
> to address the shortcomings of current filesystem within the context
> of distributed data. That the idea was to create a low level
> filesystem that would the primary choice as a block/brick layer for a
> scale-out, distributed data storage...
>
> On Wed, Apr 27, 2016 at 10:29 AM, Holger Hoffstätte
> <holger.hoffstaette@googlemail.com> wrote:
>> On 04/27/16 17:58, Juan Alberto Cirez wrote:
>>> Correct me if I'm wrong but the sum total of the above seems to
>>> suggest (at first glance) that BRTFS add several layers of complexity,
>>> but for little real benefit (at least in the case use of btrfs at the
>>> brick layer with a distributed filesystem on top)...
>>
>> This may come as a surprise, but the same can be said for every other
>> (common) filesystem (+ device management stack) that can be used
>> standalone.
>>
>> Jeff Darcy (of GlusterFS) just wrote a really nice blog post why
>> current filesystems and their historically grown requirements (mostly
>> as they relate to the POSIX interface standard) are in many ways
>> just not a good fit for scale-out/redundant storage:
>> http://pl.atyp.us/2016-05-updating-posix.html
>>
>> Quite a few of the capabilities & features which are useful or
>> necessary in standalone operation (regardless of single- or multi-
>> device setup) are *actively unhelpful* in a distributed context, which
>> is why e.g. Ceph will soon do away with the on-disk filesystem for
>> data, and manage metadata exclusively by itself.
>>
>> cheers,
>> Holger
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

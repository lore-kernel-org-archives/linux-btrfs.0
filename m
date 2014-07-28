Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:52815 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaG1DVz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Jul 2014 23:21:55 -0400
MIME-Version: 1.0
In-Reply-To: <53D5BBCA.3020109@gmail.com>
References: <CAPDOMViXEgN1U8Og52Fd7EaM86Ad2Dfex9TVQ-+tRZ9SL9Kcig@mail.gmail.com>
	<53D5BBCA.3020109@gmail.com>
Date: Sun, 27 Jul 2014 23:21:53 -0400
Message-ID: <CAPDOMVjB9ErEwA7mf91X7pff5LAkeT=BT4pR7TuoEp3LL333Lg@mail.gmail.com>
Subject: Re: Multi Core Support for compression in compression.c
From: Nick Krause <xerofoify@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 27, 2014 at 10:56 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 07/27/2014 04:47 PM, Nick Krause wrote:
>> This may be a bad idea , but compression in brtfs seems to be only
>> using one core to compress.
>> Depending on the CPU used and the amount of cores in the CPU we can
>> make this much faster
>> with multiple cores. This seems bad by my reading at least I would
>> recommend for writing compression
>> we write a function to use a certain amount of cores based on the load
>> of the system's CPU not using
>> more then 75% of the system's CPU resources as my system when idle has
>> never needed more
>> then one core of my i5 2500k to run when with interrupts for opening
>> eclipse are running. For reading
>> compression on good core seems fine to me as testing other compression
>> software for reads , it's
>> way less CPU intensive.
>> Cheers Nick
> We would probably get a bigger benefit from taking an approach like
> SquashFS has recently added, that is, allowing multi-threaded
> decompression fro reads, and decompressing directly into the pagecache.
>  Such an approach would likely make zlib compression much more scalable
> on large systems.
>
>

Austin,
That seems better then my idea as you seem to be more up to date on
brtfs devolopment.
If you and the other developers of brtfs are interested in adding this
as a feature please let
me known as I would like to help improve brtfs as the file system as
an idea is great just
seems like it needs a lot of work :).
Nick

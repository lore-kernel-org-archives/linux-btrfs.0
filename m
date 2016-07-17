Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:35868 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbcGQUsk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jul 2016 16:48:40 -0400
Received: by mail-vk0-f51.google.com with SMTP id j126so162467422vkg.3
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Jul 2016 13:48:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0e3dfcb6-c635-5904-9e97-1aa11a84dcd4@friedels.name>
References: <b2b863cf-214a-6774-27a4-c41208a578ff@friedels.name>
 <56C7BB16-91D2-42AB-B81A-33403CAFE0ED@gmail.com> <9d52a64a-eb5a-e626-2c62-2ff9bede2eef@friedels.name>
 <CAKinxcUBhsh_b6en_4B9cQ77UPMTtbYPusedPegucW3ZP0Fkuw@mail.gmail.com> <0e3dfcb6-c635-5904-9e97-1aa11a84dcd4@friedels.name>
From: Henk Slager <eye1tm@gmail.com>
Date: Sun, 17 Jul 2016 22:48:38 +0200
Message-ID: <CAPmG0jYM0ShNejuintdQXmV4Bn1+wY1KbP2e4E6BOAm4wDSagA@mail.gmail.com>
Subject: Re: Status of SMR with BTRFS
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>> It's a Seagate Expansion Desktop 5TB (USB3). It is probably a
>>> ST5000DM000.
>>
>>
>> this is TGMR not SMR disk:
>>
>> http://www.seagate.com/www-content/product-content/desktop-hdd-fam/en-us/docs/100743772a.pdf
>> So it still confirms to standard record strategy ...
>
>
> I am not convinced. I had not heared TGMR before. But I find TGMR as a
> technology for the head.
> https://pics.computerbase.de/4/0/3/4/4/29-1080.455720475.jpg
>
> In any case: the drive behaves like a SMR drive: I ran a benchmark on it
> with up to 200MB/s.
> When copying a file onto the drive in parallel the rate in the benchmark
> dropped to 7MB/s, while that particular file was copied at 40MB/s.

It is very well possible that for a normal drive of 4TB or so you get
this kind of behaviour. Suppose you have 2 tasks, 1 writing in with 4k
blocksize to a 1G file at the beginning of the disk and the 2nd with
4k blocksize to a 1G file at the end of the disk. At the beginning you
get sustained ~150MB/s, at the end ~75MB/s. Between every 4k write (or
read) you move the head(s), so ~4ms lost.

I was wondering how big the zones etc are and hopefully this is still true:
http://blog.schmorp.de/data/smr/fast15-paper-aghayev.pdf


> https://github.com/kdave/drafts/blob/master/btrfs/smr-mode.txt
> And this does sound like improvements to BTRFS can be done for SMR in a
> generic, not vendor/device specific manner.

Maybe have a look at recent patches from Hannes R from SUSE (to 4.7
kernel AFAIK) and see what will be possible with Btrfs once this
'zone-handling' is all working on the lower layers. Currently, there
is nothing special in Btrfs for SMR drives in recent kernels, but in
my experience it works, if you keep device-managed SMR
characteristics/limitations in mind. Maybe like a tape-archive or
dvd-burner.

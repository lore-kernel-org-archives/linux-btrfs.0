Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:36189 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbcGQDJz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jul 2016 23:09:55 -0400
Received: by mail-lf0-f43.google.com with SMTP id g62so1306071lfe.3
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Jul 2016 20:09:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9d52a64a-eb5a-e626-2c62-2ff9bede2eef@friedels.name>
References: <b2b863cf-214a-6774-27a4-c41208a578ff@friedels.name>
 <56C7BB16-91D2-42AB-B81A-33403CAFE0ED@gmail.com> <9d52a64a-eb5a-e626-2c62-2ff9bede2eef@friedels.name>
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Date: Sun, 17 Jul 2016 04:09:52 +0100
Message-ID: <CAKinxcUBhsh_b6en_4B9cQ77UPMTtbYPusedPegucW3ZP0Fkuw@mail.gmail.com>
Subject: Re: Status of SMR with BTRFS
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just please don't take it as picking or something:

> It's a Seagate Expansion Desktop 5TB (USB3). It is probably a ST5000DM000.

this is TGMR not SMR disk:
http://www.seagate.com/www-content/product-content/desktop-hdd-fam/en-us/docs/100743772a.pdf
So it still confirms to standard record strategy ...


>> There are two types:
>> 1. SMR managed by device firmware. BTRFS sees that as a normal block
>> device … problems you get are not related to BTRFS it self …
>
> That for sure. But the way BTRFS uses/writes data could cause problems in
> conjunction with these devices still, no?
I'm sorry but I'm confused now, what "magical way of using/writing
data" you actually mean ? AFAIK btrfs sees the disk as a block device
... for example devices has a very varying sector size, which is a 512
bytes + some CRC + maybe ECC ... btrfs does not access this data,
drive does ... to be honest drives tend to lie to you continuously !
They use this ECC to magically bail out of bad sector, give you data
and silently switch to spare sector ...

Now think slowly and thoroughly about it: who would write a code (and
maintain it) for a file system that access device specific data for X
amount of vendors with each having Y amount of model specific
configurations/caveats/firmwares/protocols ... S.M.A.R.T. emerged to
give a unifying interface to device statistics ... this is how bad it
was ...


FYI,
in 2009 I was creating a product with linux that was starting from a
flash based FS ... some people required that data after 20 years would
boot up unchanged ... my answer was: "HOW", yes I could ensure a
certain files integrity in readout by checking md5, but I could not
warrant a whole FS integrity ... specially at the time when j2ffs was
only option on flash memories (yeah it had to be RW as well @#$*@#$)
... so btrfs comes along and takes away most of problems ... if you
care about your data, do some research ... if not ... maybe raiserFS
is for you :)

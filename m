Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay01.ispgateway.de ([80.67.31.24]:42332 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbcGQJIr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jul 2016 05:08:47 -0400
Subject: Re: Status of SMR with BTRFS
To: Tomasz Kusmierz <tom.kusmierz@gmail.com>
References: <b2b863cf-214a-6774-27a4-c41208a578ff@friedels.name>
 <56C7BB16-91D2-42AB-B81A-33403CAFE0ED@gmail.com>
 <9d52a64a-eb5a-e626-2c62-2ff9bede2eef@friedels.name>
 <CAKinxcUBhsh_b6en_4B9cQ77UPMTtbYPusedPegucW3ZP0Fkuw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, dave@jikos.cz
From: Hendrik Friedel <hendrik@friedels.name>
Message-ID: <0e3dfcb6-c635-5904-9e97-1aa11a84dcd4@friedels.name>
Date: Sun, 17 Jul 2016 11:08:40 +0200
MIME-Version: 1.0
In-Reply-To: <CAKinxcUBhsh_b6en_4B9cQ77UPMTtbYPusedPegucW3ZP0Fkuw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Thomasz,

@Dave I have added you to the conversation, as I refer to your notes 
(https://github.com/kdave/drafts/blob/master/btrfs/smr-mode.txt)

thanks for your reply!

>> It's a Seagate Expansion Desktop 5TB (USB3). It is probably a ST5000DM000.
>
> this is TGMR not SMR disk:
> http://www.seagate.com/www-content/product-content/desktop-hdd-fam/en-us/docs/100743772a.pdf
> So it still confirms to standard record strategy ...

I am not convinced. I had not heared TGMR before. But I find TGMR as a 
technology for the head.
https://pics.computerbase.de/4/0/3/4/4/29-1080.455720475.jpg

In any case: the drive behaves like a SMR drive: I ran a benchmark on it 
with up to 200MB/s.
When copying a file onto the drive in parallel the rate in the benchmark 
dropped to 7MB/s, while that particular file was copied at 40MB/s.

>
>>> There are two types:
>>> 1. SMR managed by device firmware. BTRFS sees that as a normal block
>>> device … problems you get are not related to BTRFS it self …
>>
>> That for sure. But the way BTRFS uses/writes data could cause problems in
>> conjunction with these devices still, no?
> I'm sorry but I'm confused now, what "magical way of using/writing
> data" you actually mean ? AFAIK btrfs sees the disk as a block device

Well, btrfs does write data very different to many other file systems. 
On every write the file is copied to another place, even if just one bit 
is changed. That's special and I am wondering whether that could cause 
problems.

> Now think slowly and thoroughly about it: who would write a code (and
> maintain it) for a file system that access device specific data for X
> amount of vendors with each having Y amount of model specific
> configurations/caveats/firmwares/protocols ... S.M.A.R.T. emerged to
> give a unifying interface to device statistics ... this is how bad it
> was ...

Well, I'm no pro. But I found this:
https://github.com/kdave/drafts/blob/master/btrfs/smr-mode.txt
And this does sound like improvements to BTRFS can be done for SMR in a 
generic, not vendor/device specific manner.

And I am wondering:
a) whether it is advisable to use BTRFS on these drives before these 
improvements have been made already
   i) if not: Are there specific btrfs features that should be avoided, 
or btrfs in general?
b) whether these improvements have been made already

> care about your data, do some research ... if not ... maybe raiserFS
> is for you :)

You are right for sure. And that's what I do here. But I am far away 
from being able to judge myself, so I rely on support.

Greetings,
Hendrik


---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus


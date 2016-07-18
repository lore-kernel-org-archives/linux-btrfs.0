Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay05.ispgateway.de ([80.67.31.93]:57394 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbcGRSbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jul 2016 14:31:17 -0400
Subject: Re: Status of SMR with BTRFS
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Tomasz Kusmierz <tom.kusmierz@gmail.com>
References: <b2b863cf-214a-6774-27a4-c41208a578ff@friedels.name>
 <56C7BB16-91D2-42AB-B81A-33403CAFE0ED@gmail.com>
 <9d52a64a-eb5a-e626-2c62-2ff9bede2eef@friedels.name>
 <CAKinxcUBhsh_b6en_4B9cQ77UPMTtbYPusedPegucW3ZP0Fkuw@mail.gmail.com>
 <0e3dfcb6-c635-5904-9e97-1aa11a84dcd4@friedels.name>
 <96008b98-0100-35e5-50b0-43e923c92010@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, dave@jikos.cz
From: Hendrik Friedel <hendrik@friedels.name>
Message-ID: <bd311710-35c8-ce52-5b5a-96876330bde6@friedels.name>
Date: Mon, 18 Jul 2016 20:31:09 +0200
MIME-Version: 1.0
In-Reply-To: <96008b98-0100-35e5-50b0-43e923c92010@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello and thanks for your replies,

>>>> It's a Seagate Expansion Desktop 5TB (USB3). It is probably a
>>>> ST5000DM000.
>>>
>>> this is TGMR not SMR disk:
> TGMR is a derivative of giant magneto-resistance, and is what's been
> used in hard disk drives for decades now.  With limited exceptions in
> recent years and in ancient embedded systems, all modern hard drives are
> TGMR based.

Ok, thanks; So, TGMR does not say whether or not the Device is SMR or 
not, right?
While the Data-Sheet does not mention SMR and the 'Desktop' in the name 
rather than 'Archive' would indicate no SMR, some reviews indicate SMR 
(http://www.legitreviews.com/seagate-barracuda-st5000dm000-5tb-desktop-hard-drive-review_161241)

>> In any case: the drive behaves like a SMR drive: I ran a benchmark on it
>> with up to 200MB/s.
>> When copying a file onto the drive in parallel the rate in the benchmark
>> dropped to 7MB/s, while that particular file was copied at 40MB/s.
> This type of performance degradation is actually not unexpected

Ok. I was not aware. I expected some, but less impact.


> There's two things that should be clarified here:
[...]
Thanks for clarifying.

>> Well, I'm no pro. But I found this:
>> https://github.com/kdave/drafts/blob/master/btrfs/smr-mode.txt
>> And this does sound like improvements to BTRFS can be done for SMR in a
>> generic, not vendor/device specific manner.
>>
>> And I am wondering:
[...]
>> b) whether these improvements have been made already
> Not yet.

Ok, thanks.
So I conclude that on SMR Drives, BTRFS has all benefits that it has on 
all other devices and there are no BTRFS related disadvantages in 
relation with BTRFS. Nevertheless, some improvements to BTRFS can be 
made in order to improve BTRFS with these drives.

Greetings,
Hendrik

---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus


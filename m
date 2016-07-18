Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:36181 "EHLO
	mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbcGRSo5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jul 2016 14:44:57 -0400
Received: by mail-it0-f45.google.com with SMTP id f6so74759259ith.1
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jul 2016 11:44:57 -0700 (PDT)
Subject: Re: Status of SMR with BTRFS
To: Hendrik Friedel <hendrik@friedels.name>,
        Tomasz Kusmierz <tom.kusmierz@gmail.com>
References: <b2b863cf-214a-6774-27a4-c41208a578ff@friedels.name>
 <56C7BB16-91D2-42AB-B81A-33403CAFE0ED@gmail.com>
 <9d52a64a-eb5a-e626-2c62-2ff9bede2eef@friedels.name>
 <CAKinxcUBhsh_b6en_4B9cQ77UPMTtbYPusedPegucW3ZP0Fkuw@mail.gmail.com>
 <0e3dfcb6-c635-5904-9e97-1aa11a84dcd4@friedels.name>
 <96008b98-0100-35e5-50b0-43e923c92010@gmail.com>
 <bd311710-35c8-ce52-5b5a-96876330bde6@friedels.name>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, dave@jikos.cz
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <667a14be-4a01-02f6-79f9-a8cd585f360d@gmail.com>
Date: Mon, 18 Jul 2016 14:44:49 -0400
MIME-Version: 1.0
In-Reply-To: <bd311710-35c8-ce52-5b5a-96876330bde6@friedels.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-18 14:31, Hendrik Friedel wrote:
> Hello and thanks for your replies,
>
>>>>> It's a Seagate Expansion Desktop 5TB (USB3). It is probably a
>>>>> ST5000DM000.
>>>>
>>>> this is TGMR not SMR disk:
>> TGMR is a derivative of giant magneto-resistance, and is what's been
>> used in hard disk drives for decades now.  With limited exceptions in
>> recent years and in ancient embedded systems, all modern hard drives are
>> TGMR based.
>
> Ok, thanks; So, TGMR does not say whether or not the Device is SMR or
> not, right?
I'm not 100% certain about that.  Technically, the only non-firmware 
difference is in the read head and the tracking.  If it were me, I'd be 
listing SMR instead of TGMR on the data sheet, but I'd be more than 
willing to bet that many drive manufacturers won't think like that.
> While the Data-Sheet does not mention SMR and the 'Desktop' in the name
> rather than 'Archive' would indicate no SMR, some reviews indicate SMR
> (http://www.legitreviews.com/seagate-barracuda-st5000dm000-5tb-desktop-hard-drive-review_161241)
I know for a fact that at least through 2015, all 'Desktop' branded 3.5 
inch Seagate hard drives up through 4TB in capacity used TGMR with 1TB 
platters (500GB per side of the platter).  I've got one of their 5TB 
external drives at work (with 'Expansion' branding) which uses a 3.5 
inch disk which based on testing I've done appears to be traditional 
TGMR with either thinner platters (and thus more of them) or some other 
method of improving areal storage density.  Beyond that, I'm not sure, 
but I believe that their 'Desktop' branding still means it's TGMR and 
not SMR.
>
>
>>> In any case: the drive behaves like a SMR drive: I ran a benchmark on it
>>> with up to 200MB/s.
>>> When copying a file onto the drive in parallel the rate in the benchmark
>>> dropped to 7MB/s, while that particular file was copied at 40MB/s.
>> This type of performance degradation is actually not unexpected
>
> Ok. I was not aware. I expected some, but less impact.
There are a number of factors that contribute to this, I see less 
degradation on enterprise disks than regular retail units, but it's 
still there.  Even with the insane precision they already have using 
voice-coils for actuation of the head, there's a functional upper limit 
on how fast it can move without risking damaging anything.
>
>
>> There's two things that should be clarified here:
> [...]
> Thanks for clarifying.
>
>>> Well, I'm no pro. But I found this:
>>> https://github.com/kdave/drafts/blob/master/btrfs/smr-mode.txt
>>> And this does sound like improvements to BTRFS can be done for SMR in a
>>> generic, not vendor/device specific manner.
>>>
>>> And I am wondering:
> [...]
>>> b) whether these improvements have been made already
>> Not yet.
>
> Ok, thanks.
> So I conclude that on SMR Drives, BTRFS has all benefits that it has on
> all other devices and there are no BTRFS related disadvantages in
> relation with BTRFS. Nevertheless, some improvements to BTRFS can be
> made in order to improve BTRFS with these drives.
I've come to pretty much the same conclusion in my usage.  That said, 
quite a few improvements could be made to BTRFS in general, not just 
with respect to SMR drives.

I'd very much suggest avoiding USB connected SMR drives though, USB is 
already poorly designed for storage devices (even with USB attached 
SCSI), and most of the filesystem issues I see personally (not just with 
BTRFS, but any other filesystem as well) are on USB connected storage, 
so I'd be very wary of adding all the potential issues with SMR drives 
on top of that as well.

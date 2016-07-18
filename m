Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:38770 "EHLO
	mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbcGRTbF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jul 2016 15:31:05 -0400
Received: by mail-it0-f51.google.com with SMTP id j124so41785452ith.1
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jul 2016 12:31:04 -0700 (PDT)
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
 <667a14be-4a01-02f6-79f9-a8cd585f360d@gmail.com>
 <f7dec129-0aa2-832a-1842-95cd2ddd940e@friedels.name>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, dave@jikos.cz
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <aa570d41-872d-bfde-e569-85e8b274b029@gmail.com>
Date: Mon, 18 Jul 2016 15:30:57 -0400
MIME-Version: 1.0
In-Reply-To: <f7dec129-0aa2-832a-1842-95cd2ddd940e@friedels.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-18 15:05, Hendrik Friedel wrote:
> Hello Austin,
>
> thanks for your reply.
>
>>> Ok, thanks; So, TGMR does not say whether or not the Device is SMR or
>>> not, right?
>> I'm not 100% certain about that.  Technically, the only non-firmware
>> difference is in the read head and the tracking.  If it were me, I'd be
>> listing SMR instead of TGMR on the data sheet, but I'd be more than
>> willing to bet that many drive manufacturers won't think like that.
>>> While the Data-Sheet does not mention SMR and the 'Desktop' in the name
>>> rather than 'Archive' would indicate no SMR, some reviews indicate SMR
>>> (http://www.legitreviews.com/seagate-barracuda-st5000dm000-5tb-desktop-hard-drive-review_161241)
>>>
>>>
>>  Beyond that, I'm not sure,
>> but I believe that their 'Desktop' branding still means it's TGMR and
>> not SMR.
>
> ... which in the Seagate nomenclature might not exclude each other (TGMR
> could still be SMR). I will just ask them...
> How did you find out on your drives whether they use SMR?
I've actually manually deconstructed quite a few hard disks for work. 
We have to wipe old disks before they leave the building, and if we 
can't do it in software because of something like a head crash, we have 
to take them apart and physically destroy the platters.  There are 
actually visible differences in regular TGMR and SMR heads, so if you 
know what to look for, you can tell by the write heads (it's also a dead 
giveaway when a drive has significantly fewer platters than TB's of 
space).  There's also measurable performance differences for certain 
access patterns, but that doesn't work as reliably as it sounds like it 
should (the actual physical data layout on disk these days may look 
nothing like what software sees).
>
>> I'd very much suggest avoiding USB connected SMR drives though, USB is
>> already poorly designed for storage devices (even with USB attached
>> SCSI), and most of the filesystem issues I see personally (not just with
>> BTRFS, but any other filesystem as well) are on USB connected storage,
>> so I'd be very wary of adding all the potential issues with SMR drives
>> on top of that as well.
>
> Understood. But I use this drive as a Backup. The Drive must not be
> connected to the System unless doing a backup. Otherwise a Virus, or
> just an issue with the power (peak due to lightning strike) might vanish
> both the Source data and Backup at once (single point of failure).
In that case, I'd be very careful to wait for a while after finishing a 
backup before disconnecting the disk (and make sure to unmount the 
filesystem before waiting so that everything gets flushed to disk), and 
make sure to validate your backups as well.  Once the disk has been 
safely disconnected, you're fine though, the issues arise if the device 
suddenly disappears from the bus or loses power (which is of course an 
issue for regular drives, the filesystem damage just tends to be much 
worse with SMR drives).  For what it's worth, I've seen fewer issues 
with (recent) USB 3.0 devices than USB 2.0, but even just bumping the 
cable can cause issues sometimes.

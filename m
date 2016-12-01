Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38749 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752147AbcLAJh3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Dec 2016 04:37:29 -0500
Received: by mail-wm0-f44.google.com with SMTP id f82so242634254wmf.1
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Dec 2016 01:37:15 -0800 (PST)
Received: from [10.50.10.124] (HSI-KBW-37-209-73-100.hsi15.kabel-badenwuerttemberg.de. [37.209.73.100])
        by smtp.googlemail.com with ESMTPSA id c202sm14671502wme.1.2016.12.01.01.37.13
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Dec 2016 01:37:14 -0800 (PST)
From: Wilson Meier <wilson.meier@gmail.com>
Subject: Re: Convert from RAID 5 to 10
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de>
 <fce2df8b-0775-1ecf-c08d-960018822c20@googlemail.com>
 <20161130103808.74e5ae95@natsu> <3713990.abIjkpnqyF@merkaba>
 <73d0d10c-7a06-b282-ee76-4512aaed5723@googlemail.com>
 <pan$7a75f$e48f1aa5$204a0630$9d1c1cc4@cox.net>
 <b13f13a4-639d-d460-7642-c8f8fe646832@googlemail.com>
 <19671a71-5d1c-c42e-db3d-c870ec08b2ff@gmail.com>
 <e9a4cba5-53b7-b6f0-af83-467f5f95f5b8@googlemail.com>
 <21e6765c-21f9-1726-b06f-9bd5f67c7b49@gmail.com>
Message-ID: <668d0396-e0aa-8f67-f96a-490924175bb9@googlemail.com>
Date: Thu, 1 Dec 2016 10:37:13 +0100
MIME-Version: 1.0
In-Reply-To: <21e6765c-21f9-1726-b06f-9bd5f67c7b49@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 30/11/16 um 17:48 schrieb Austin S. Hemmelgarn:
> On 2016-11-30 10:49, Wilson Meier wrote:
>> Am 30/11/16 um 15:37 schrieb Austin S. Hemmelgarn:
>>
>> Transferring this to car analogy, just to make it a bit more funny:
>> The airbag (raid level whatever) itself is ok but the micro controller
>> (general btrfs) which has the responsibility to inflate the airbag is
>> suffers some problems, sometimes doesn't inflate and the manufacturer
>> doesn't mention about that fact.
>> From your point of you the airbag is ok. From my point of view -> Don't
>> buy that car!!!
>> Don't you mean that the fact that the live safer suffers problems should
>> be noted and every dependent component should point to that fact?
>> I think it should.
>> I'm not talking about performance issues, i'm talking about data loss.
>> Now the next one can throw in "Backups, always make backups!".
>> Sure, but backup is backup and raid is raid. Both have their own
>> concerns.
> A better analogy for a car would be something along the lines of the
> radio working fine but the general wiring having issues that cause all
> the electronics in the car to stop working under certain
> circumstances. In that case, the radio itself is absolutely OK, but it
> suffers from issues caused directly by poor design elsewhere in the
> vehicle.
Ahm, no. You cannot exchange a security mechanism (raid) with a comfort
one (compression) and treat them as the same in terms of importance.
It makes a serious difference to have a not properly working airbag or
not being able to listen to music while your a driving against a wall.
Anyway, we should stop this here.
>>>> I'm not angry or something like that :) .
>>>> I just would like to have the possibility to read such information
>>>> about
>>>> the storage i put my personal data (> 3 TB) on its official wiki.
> There are more places than the wiki to look for info about BTRFS (and
> this is the case about almost any piece of software, not just BTRFS,
> very few things have one central source for everything).  I don't mean
> to sound unsympathetic, but given what you're saying, it's sounding
> more and more like you didn't look at anything beyond the wiki and
> should have checked other sources as well.
This is your assumption.


Am 01/12/16 um 07:47 schrieb Duncan:
> Austin S. Hemmelgarn posted on Wed, 30 Nov 2016 11:48:57 -0500 as
> excerpted:
>> On 2016-11-30 10:49, Wilson Meier wrote:
>>> Do you also have all home users in mind, which go to vacation (sometime
>>>> 3 weeks) and don't have a 24/7 support team to replace monitored disks
>>> which do report SMART errors?
>> Better than 90% of people I know either shut down their systems when
>> they're going to be away for a long period of time, or like me have
>> ways to log in remotely and tell the FS to not use that disk anymore.
> https://btrfs.wiki.kernel.org/index.php/Getting_started ... ... has
> two warnings offset in red right in the first section: * If you have
> btrfs filesystems, run the latest kernel.
I do. Ok not the very latest but i'm always on the latest major version.
Right now i have 4.8.4 and the very latest is 4.8.11.
> * You should keep and test backups of your data, and be prepared to use 
> them.
I have daily backups.
> As to the three weeks vacation thing... And "daily use" != "three
> weeks without physical access to something you're going to actually be
> relying on for parts of those three weeks".
>
Maybe i have my own mailserver and owncloud to server files to my
family? Maybe i'm out of country and somewhere i have no internet access?
I will not comment this any further as it leads us nowhere.


In general i think that this discussion is taking a complete wrong
direction.
The only thing i have asked for is to document the *known*
problems/flaws/limitations of all raid profiles and link to them from
the stability matrix.

Regarding raid10:
Even if one knows about the fact that btrfs handles things on chunk
level one would assume that the code is written in a way to put the
copies on different stripes.
Otherwise raid10 ***can*** become pretty useless in terms of data
redundancy and 2 x raid1 with an lvm should be considered as a replacement.
This is a serious thing and should be documented. If this is documented
somewhere then please point me to it as i cannot find a word about that
anywhere.

Cheers,
Wilson



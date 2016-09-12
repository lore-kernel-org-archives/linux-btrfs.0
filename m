Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nmsh3.e.nsc.no ([193.213.121.74]:61014 "EHLO nmsh3.e.nsc.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755886AbcILRpJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 13:45:09 -0400
Subject: Re: Is stability a joke?
To: Chris Mason <clm@fb.com>, Waxhead <waxhead@online.no>,
        linux-btrfs@vger.kernel.org
References: <57D51BF9.2010907@online.no>
 <b40d108d-004f-827b-7d4b-0b93be853e73@fb.com> <57D6E7B9.60207@online.no>
From: Waxhead <waxhead@online.no>
Message-ID: <57D6E994.5090608@online.no>
Date: Mon, 12 Sep 2016 19:44:52 +0200
MIME-Version: 1.0
In-Reply-To: <57D6E7B9.60207@online.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zoiled wrote:
> Chris Mason wrote:
>>
>>
>> On 09/11/2016 04:55 AM, Waxhead wrote:
>>> I have been following BTRFS for years and have recently been 
>>> starting to
>>> use BTRFS more and more and as always BTRFS' stability is a hot topic.
>>> Some says that BTRFS is a dead end research project while others claim
>>> the opposite.
>>>
>>> Taking a quick glance at the wiki does not say much about what is safe
>>> to use or not and it also points to some who are using BTRFS in 
>>> production.
>>> While BTRFS can apparently work well in production it does have some
>>> caveats, and finding out what features is safe or not can be 
>>> problematic
>>> and I especially think that new users of BTRFS can easily be bitten if
>>> they do not do a lot of research on it first.
>>>
>>> The Debian wiki for BTRFS (which is recent by the way) contains a bunch
>>> of warnings and recommendations and is for me a bit better than the
>>> official BTRFS wiki when it comes to how to decide what features to 
>>> use.
>>>
>>> The Nouveau graphics driver have a nice feature matrix on it's webpage
>>> and I think that BTRFS perhaps should consider doing something like 
>>> that
>>> on it's official wiki as well
>>>
>>> For example something along the lines of .... (the statuses are taken
>>> our of thin air just for demonstration purposes)
>>>
>>
>> The out of thin air part is a little confusing, I'm not sure if 
>> you're basing this on reports you've read?
>>
> Well to be honest I used "whatever I felt was right" more or less in 
> that table and as I wrote it was only for demonstration purposes only 
> to show how such a table could look.
>> I'm in favor flagged device replace with raid5/6 as not supported 
>> yet. That seems to be where most of the problems are coming in.
>>
>> The compression framework shouldn't allow one to work well with the 
>> other unusable.
> Ok good to know , however from the Debian wiki as well as the link to 
> the mailing list only LZO compression are mentioned (as far as I 
> remember) and I have no idea myself how much difference there is 
> between LZO and the ZLIB code,
>>
>> There were  problems with autodefrag related to snapshot-aware 
>> defrag, so Josef disabled the snapshot aware part.
>>
>> In general, we put btrfs through heavy use at facebook.  The crcs 
>> have found serious hardware problems the other filesystems missed.
>>
>> We've also uncovered performance problems and a some serious bugs, 
>> both in btrfs and the other filesystems.  With the other filesystems 
>> the fixes were usually upstream (doubly true for the most serious 
>> problems), and with btrfs we usually had to make the fixes ourselves.
>>
>> -chris
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
> I'll just pop this in here since I assume most people will read the 
> response from your comment:
>
> I think I made my point. The wiki lacks some good documentation on 
> what's safe to use and what's not. Yesterday I (Svein Engelsgjerd) did 
> put a table on the main wiki and someone have moved that away to a 
> status page and also improved the layout a bit. It is a tad more 
> complex than my version, but also a lot better for the slightly more 
> advanced users and it actually made my view on things a bit clearer as 
> well.
>
> I am glad that I by bringing this up (hopefully) contributed slightly 
> to improving the documentation a tiny bit! :)
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
Just for the record - sorry for using my "crap mail" - I sometimes 
forget to change to the correct sender. I am therefore Svein Engelsgjerd 
a.k.a. Waxhead a.k.a. "Zoiled" :)
...sorry for the confusion


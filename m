Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36213 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751792AbeFXPGL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Jun 2018 11:06:11 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fX6YV-0000FV-Ni
        for linux-btrfs@vger.kernel.org; Sun, 24 Jun 2018 17:03:55 +0200
To: linux-btrfs@vger.kernel.org
From: Ferry Toth <ftoth@telfort.nl>
Subject: Re: unsolvable technical issues?
Date: Sun, 24 Jun 2018 17:06 +0200
Message-ID: <pgobsl$eh$1@blaine.gmane.org>
References: <b255d0fb-5cee-36c5-d49f-5f014d20e518@dirtcellar.net> <1c1b0945-81b1-ac6f-2f16-2527ca382d9f@suse.com> <95342f33-dd4e-e143-b2c1-4f526ce84714@dirtcellar.net> <64e632f6-0d26-f8cc-91ff-329eeb28f7f5@aarghimedes.fi> <7309fa6b-d892-cff9-dcdf-639070ea073e@dirtcellar.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

waxhead wrote:

> Jukka Larja wrote:
>> waxhead wrote 24.6.2018 klo 1.01:
>>> Nikolay Borisov wrote:
>>>>
>>>> On 22.06.2018 02:13, waxhead wrote:
>>>>> According to this:
>>>>>
>>>>> https://stratis-storage.github.io/StratisSoftwareDesign.pdf
>>>>> Page 4 , section 1.2
>>>>>
>>>>> It claims that BTRFS still have significant technical issues that may
>>>>> never be resolved.
>>>>> Could someone shed some light on exactly what these technical issues
>>>>> might be?! What are BTRFS biggest technical problems?
>>>>
>>>> That's a question that needs to be directed at the author of the
>>>> statement.
>>>>
>>> I think not, and here's why: I am asking the BTRFS developers a
>>> general question , with some basis as to why I became curious. The
>>> question is simply what (if any) are the biggest technical issues in
>>> BTRFS because one must expect that if anyone is going to give me a
>>> credible answer it must be the people that hack on BTRFS and
>>> understand what they are working on and not the stratis guys. It would
>>> surprise me if they knew better than the BTRFS devs.
>> 
>> I think the problem with that question is that it is too general.
>> Duncan's post already highlights several things that could be a
>> significant problem for some user while being non-issue for most.
>> Without more specific problem description, best you can hope for is
>> speculation on things that Btrfs currently does badly.
>> 
>> -Jukka Larja
> 
> Well, I still don't agree (apparently I am starting to become
> difficult). There is a "roadmap" on the BTRFS wiki that describes
> features implemented and feature planned for example. Naturally people
> are working on improvements to existing features and prep-work for new
> features. If some of this work is not moving ahead due to design issues
> it sounds likely that someone would know about it by now.

This one doesn't seem to be moving ahead, while it seems like a very 
promising one: Hot data tracking and moving to faster devices (or provided 
on the generic VFS layer)

It would be really fantastic to just add a ssd to a pool of hdd's and have 
fsync sensitive stuff run normally (dpkg on raid10 with 50 snapshots 
currently can take hours to do a few minute job)

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



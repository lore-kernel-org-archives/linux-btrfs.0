Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aarghimedes.fi ([62.75.165.48]:45844 "EHLO aarghimedes.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750734AbeFXEDK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Jun 2018 00:03:10 -0400
Subject: Re: unsolvable technical issues?
To: waxhead@dirtcellar.net, linux-btrfs@vger.kernel.org
References: <b255d0fb-5cee-36c5-d49f-5f014d20e518@dirtcellar.net>
 <1c1b0945-81b1-ac6f-2f16-2527ca382d9f@suse.com>
 <95342f33-dd4e-e143-b2c1-4f526ce84714@dirtcellar.net>
From: Jukka Larja <roskakori@aarghimedes.fi>
Message-ID: <64e632f6-0d26-f8cc-91ff-329eeb28f7f5@aarghimedes.fi>
Date: Sun, 24 Jun 2018 06:55:27 +0300
MIME-Version: 1.0
In-Reply-To: <95342f33-dd4e-e143-b2c1-4f526ce84714@dirtcellar.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

waxhead wrote 24.6.2018 klo 1.01:
> Nikolay Borisov wrote:
>>
>> On 22.06.2018 02:13, waxhead wrote:
>>> According to this:
>>>
>>> https://stratis-storage.github.io/StratisSoftwareDesign.pdf
>>> Page 4 , section 1.2
>>>
>>> It claims that BTRFS still have significant technical issues that may
>>> never be resolved.
>>> Could someone shed some light on exactly what these technical issues
>>> might be?! What are BTRFS biggest technical problems?
>>
>> That's a question that needs to be directed at the author of the statement.
>>
> I think not, and here's why: I am asking the BTRFS developers a general 
> question , with some basis as to why I became curious. The question is 
> simply what (if any) are the biggest technical issues in BTRFS because one 
> must expect that if anyone is going to give me a credible answer it must be 
> the people that hack on BTRFS and understand what they are working on and 
> not the stratis guys. It would surprise me if they knew better than the 
> BTRFS devs.

I think the problem with that question is that it is too general. Duncan's 
post already highlights several things that could be a significant problem 
for some user while being non-issue for most. Without more specific problem 
description, best you can hope for is speculation on things that Btrfs 
currently does badly.

-Jukka Larja

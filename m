Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64273 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751814AbbHaCDU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Aug 2015 22:03:20 -0400
Subject: Re: (renamed thread) btrfs metrics, free space reporting
To: Daniel Pocock <daniel@pocock.pro>,
        "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
References: <4F01BF5D.2070801@pocock.com.au>
 <CAE5mzviX5kJ70nG3bLPwE7E3ZjmdQvsKNUbs6XXqVhs+MEeSXw@mail.gmail.com>
 <4F01C6DC.3040609@pocock.com.au> <20120102151422.GA27122@carfax.org.uk>
 <4F01DA85.4050107@pocock.com.au> <20120102163944.GB27122@carfax.org.uk>
 <4F043C75.1080204@pocock.com.au>
 <CABsxX9+J9XvBzV8OEHfKJSaYtB8RziysW4JDtYW75Qje7tt4vQ@mail.gmail.com>
 <4F0576C3.90502@pocock.com.au> <55E2F791.80008@pocock.pro>
CC: Hugo Mills <hugo@carfax.org.uk>, cwillu <cwillu@cwillu.com>,
        <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55E3B5E4.1060106@cn.fujitsu.com>
Date: Mon, 31 Aug 2015 10:03:16 +0800
MIME-Version: 1.0
In-Reply-To: <55E2F791.80008@pocock.pro>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Daniel Pocock wrote on 2015/08/30 14:31 +0200:
>
>
> On 05/01/12 11:09, Daniel Pocock wrote:
>>
>>>
>>>  From there on, one could potentially create a matrix: (proportional
>>> font art, apologies):
>>>
>>>            | subvol1  | subvol2  | subvol3  |
>>> ----------+----------+----------+----------+
>>>   subvol1  |   200M   |     20M  |     50M  |
>>> ----------+----------+----------+----------+
>>>   subvol2  |    20M   |    350M  |     22M  |
>>> ----------+----------+----------+----------+
>>>   subvol3  |    50M   |     22M  |    634M  |
>>> ----------+----------+----------+----------+
>>>
>>> The diagonal obviously shows the "unique" blocks, subvol2 and subvol1
>>> share 20M data, etc. Missing from this plot would be "how much is
>>> shared between subvol1, subvol2, and subvol3" together, but it's a
>>> start and not something that hard to understand. One might add a
>>> column for "total size" of each subvol, which may obviously not be an
>>> addition of the rest of the columns in this diagram.
>>>
>>> Anyway, something like this would be high on my list of `df` numbers
>>> I'd like to see - since I think they are useful numbers.
>>>
>>
>> This is an interesting way to look at it
>>
>> Ganglia typically records time series data, it is quite conceivable to
>> create a metric for every permutation in each and store that in rrdtool
>>
>> The challenge would then be in reporting on the data: the rrdtool graphs
>> use time as an X-axis, and then it can display multiple Y values
>>
>> However, now that I've started thinking about the type of data generated
>> from btrfs, I was wondering if some kind of rr3dtool is needed - a 3D
>> graphing solution - or potentially making graphs that do not include
>> time on any axis?
>>
>> Has anyone seen anything similar for administering ZFS, for example?
>>
>
>
> I just wanted to follow up on this and see if anybody had any more
> comments or if the situation has changed?
>
> One other thing that came to mind for me is the idea of letting the
> local system administrator define views (similar to views in SQL) and
> also nominate which of the views should be used to return values for the
> standard df command.
>
> This would allow existing monitoring tools and scripts to continue
> getting some data that is considered sensible for a specific context.

The matrix seems intersting.

But have you guys tried qgroups?
That will do the thing for you and it should be more flex than you 
imagination.

For your use case, qgroup should be quite stable after v4.2-rc1, as you 
only want to see how much unique/shared extents between subvolumes.

Thanks,
Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

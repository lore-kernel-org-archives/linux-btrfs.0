Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:34422 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbdIEOVz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Sep 2017 10:21:55 -0400
Subject: Re: \o/ compsize
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Timofey Titovets <nefelim4ag@gmail.com>,
        Adam Borowski <kilobyte@angband.pl>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Nick Terrell <terrelln@fb.com>,
        David Sterba <dsterba@suse.cz>
References: <20170904151154.vkhshc57t2mi2sze@angband.pl>
 <CAGqmi762p8wKRv3Gz0Z5BABUvKLn7-8XhB6=v-gbdqsGMV8rUg@mail.gmail.com>
 <20170904184229.cjarg6p7tbgy7gka@angband.pl>
 <CAGqmi76KhL7QosRQ5yE86_Q7NCxSRcG_rypODwhwazPJRv71Rg@mail.gmail.com>
 <721d94dc-2c1b-2e2d-d778-cd8f98e3fcd2@gmx.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <a3f089c4-ffdc-266e-bf29-7b5b91e5c251@mendix.com>
Date: Tue, 5 Sep 2017 16:21:53 +0200
MIME-Version: 1.0
In-Reply-To: <721d94dc-2c1b-2e2d-d778-cd8f98e3fcd2@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/05/2017 04:02 PM, Qu Wenruo wrote:
> 
> 
> On 2017年09月05日 03:52, Timofey Titovets wrote:
>> 2017-09-04 21:42 GMT+03:00 Adam Borowski <kilobyte@angband.pl>:
>>> On Mon, Sep 04, 2017 at 07:07:25PM +0300, Timofey Titovets wrote:
>>>> 2017-09-04 18:11 GMT+03:00 Adam Borowski <kilobyte@angband.pl>:
>>>>> Here's an utility to measure used compression type + ratio on a set
>>>>> of files
>>>>> or directories: https://github.com/kilobyte/compsize
>>>>>
>>>>> It should be of great help for users, and also if you:
>>>>> * muck with compression levels
>>>>> * add new compression types
>>>>> * add heurestics that could err on withholding compression too much
> 
> Did a brief review, and the result looks quite good.
> Especially same disk bytenr is handled well, so same file extent
> referring to different part of the large extent won't get count twice.
> 
> Nice job.
> 
> But still some smaller improvement can be done:
> (Please keep in mind I can go totally wrong since I'm not doing a
> comprehensive review)
> 
> Search key min_type and max_type can be set to BTRFS_EXTENT_DATA_KEY,
> which should filtered out unrelated results.

No, it does not.

https://patchwork.kernel.org/patch/9767619/

> And to improve readability, using BTRFS_SETGET_STACK_FUNCS() defined
> functions will be a big improvement for reviewers.
> (So I can check if the magic numbers are right or not, since I'm a lazy
> bone and don't want to manually calculate the offset)
> 
>>>>
>>>> Packaged to AUR:
>>>> https://aur.archlinux.org/packages/compsize-git/
> 
> Nice, I don't even need to build it myself!
> (Well, no much dependency anyway)
> 
>>>
>>> Cool!  I'd wait until people say the code is sane (I don't really
>>> know these
>>> ioctls) but if you want to make poor AUR folks our beta testers,
>>> that's ok.
> 
> The code is sane!
> And it even considered inline extent! (Which I didn't consider BTW as
> inline extent counts as metadata, not data so my first thought just is
> to just ignore them).
> 
>>
>> This just are too handy =)
>>
>>> However, one issue: I did not set a license; your packaging says GPL3.
>>> It would be better to have something compatible with btrfs-progs
>>> which are
>>> GPL2-only.  What about GPL2-or-higher?
>>
>> Sorry for license, just copy-paste error, fixed
>>
>>> After adding some related info (like wasted space in pinned extents,
>>> reuse
>>> of extents), it'd be nice to have this tool inside btrfs-progs,
>>> either as a
>>> part of "fi du" or another command.
>>
>> That will be useful =)
> 
> If improved, I think there is the chance to get it into btrfs-progs.
> 
> Thanks,
> Qu
> 
>>
>> P.S.
>> your code work amazing fast on my ssd and data %)
>> 150Gb data
>> -O0 2.12s
>> -O2 0.51s
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Hans van Kranenburg

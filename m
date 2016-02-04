Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7458 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965678AbcBDJPO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Feb 2016 04:15:14 -0500
Subject: Re: btrfs-progs and btrfs(8) inconsistencies
To: Moviuro <moviuro@gmail.com>
References: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com>
 <56B2AA51.80908@cn.fujitsu.com>
 <CAM=f9=X5BU0N4iueXtVf4y5SAxrnMQgtgbrsx0Gbc8W6SEspMg@mail.gmail.com>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56B3169A.10508@cn.fujitsu.com>
Date: Thu, 4 Feb 2016 17:15:06 +0800
MIME-Version: 1.0
In-Reply-To: <CAM=f9=X5BU0N4iueXtVf4y5SAxrnMQgtgbrsx0Gbc8W6SEspMg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Moviuro wrote on 2016/02/04 09:57 +0100:
> On Thu, Feb 4, 2016 at 2:33 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> Moviuro wrote on 2016/02/03 22:54 +0100:
>>>
>>> Hi all,
>>>
>>> ...
>>>
>>> # btrfs subvolume create foo # should be silent
>>> # btrfs subvolume create -v foo
>>> /absolute/path/foo
>>> # btrfs subvolume create [--details|-vv] foo
>>> PATH:/absolute/path/foo
>>> UUID:082df386-98c2-44d9-9012-07fb2b22ea20
>>> [And whatnot]
>>
>>
>> The idea itself makes a lot of sense.
>> But I have at least two things to worry about:
>>
>> 1) Old scripts backward compatibility
>>     Especially xfstests. Maintainer will hate it a lot.
>>     As we have changed it several times and broken existing test cases.
> Right now, I can think of the following:
> - add a "backward-compatibility switch", like -o|--old, which would
> have no effect on the output on version 4.X.
> - add a "use the new behavior switch", like -n|--new, which would have
> no effect starting with the next big release (5.X)
>
>>     Although personally I like to let all the backward compatibility
>>     things go hell, but that's definitely not how things work. :(
>>
>> 2) End-user taste.
>>     Some end-users like such info as feedback of success.
>>     Of course other users like it act as silent as possible.
> I'm pretty sure that's... not the case. Almost everything on GNU/Linux
> is silent. cd(1) is silent, cp(1) is silent, rm(1)...
> What they all have though is a -v|--verbose switch.
>
>>>
>>> That's a first example. Same should go for all the commands. I have no
>>> idea
>>> how/where we could share about good/bad outputs (Google Drive? Framapad?
>>> git[hub|lab]?)
>>
>>
>> Maybe it's overkilling, but I like the idea to have a good example about how
>> CLI interface should be designed.
>> But it may be harder for all developer/reviewer to follow that restrict
>> example.
>>
>> And even more, I hope there will be a nice btrfs-progs CLI design guideline.
>> (Although it's surely overkilling)
> What kind of format do you think we should write this in? drop a
> stylesheet.md in the repo?

Markdown is good enough for me.
But I'm not sure where to put it.
Btrfs wiki? Btrfs-progs repo?

Maybe you can write one and put it in btrfs-progs, and send out as a 
patch for us to review?

Thanks,
Qu

>
>> Thanks,
>> Qu
>>> Then come inconsistencies: compare the outputs of
>>> ...
>>
>
>



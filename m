Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35113 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965221AbcBDI5y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Feb 2016 03:57:54 -0500
Received: by mail-ig0-f181.google.com with SMTP id hb3so30529989igb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Feb 2016 00:57:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56B2AA51.80908@cn.fujitsu.com>
References: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com>
	<56B2AA51.80908@cn.fujitsu.com>
Date: Thu, 4 Feb 2016 09:57:54 +0100
Message-ID: <CAM=f9=X5BU0N4iueXtVf4y5SAxrnMQgtgbrsx0Gbc8W6SEspMg@mail.gmail.com>
Subject: Re: btrfs-progs and btrfs(8) inconsistencies
From: Moviuro <moviuro@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 4, 2016 at 2:33 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> Moviuro wrote on 2016/02/03 22:54 +0100:
>>
>> Hi all,
>>
>> ...
>>
>> # btrfs subvolume create foo # should be silent
>> # btrfs subvolume create -v foo
>> /absolute/path/foo
>> # btrfs subvolume create [--details|-vv] foo
>> PATH:/absolute/path/foo
>> UUID:082df386-98c2-44d9-9012-07fb2b22ea20
>> [And whatnot]
>
>
> The idea itself makes a lot of sense.
> But I have at least two things to worry about:
>
> 1) Old scripts backward compatibility
>    Especially xfstests. Maintainer will hate it a lot.
>    As we have changed it several times and broken existing test cases.
Right now, I can think of the following:
- add a "backward-compatibility switch", like -o|--old, which would
have no effect on the output on version 4.X.
- add a "use the new behavior switch", like -n|--new, which would have
no effect starting with the next big release (5.X)

>    Although personally I like to let all the backward compatibility
>    things go hell, but that's definitely not how things work. :(
>
> 2) End-user taste.
>    Some end-users like such info as feedback of success.
>    Of course other users like it act as silent as possible.
I'm pretty sure that's... not the case. Almost everything on GNU/Linux
is silent. cd(1) is silent, cp(1) is silent, rm(1)...
What they all have though is a -v|--verbose switch.

>>
>> That's a first example. Same should go for all the commands. I have no
>> idea
>> how/where we could share about good/bad outputs (Google Drive? Framapad?
>> git[hub|lab]?)
>
>
> Maybe it's overkilling, but I like the idea to have a good example about how
> CLI interface should be designed.
> But it may be harder for all developer/reviewer to follow that restrict
> example.
>
> And even more, I hope there will be a nice btrfs-progs CLI design guideline.
> (Although it's surely overkilling)
What kind of format do you think we should write this in? drop a
stylesheet.md in the repo?

> Thanks,
> Qu
>> Then come inconsistencies: compare the outputs of
>> ...
>

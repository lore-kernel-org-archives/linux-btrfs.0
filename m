Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:34066 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808AbcDELpD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Apr 2016 07:45:03 -0400
Received: by mail-qg0-f44.google.com with SMTP id c6so7657525qga.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 04:45:02 -0700 (PDT)
Received: from [127.0.0.1] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id 139sm14225258qho.2.2016.04.05.04.45.01
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Tue, 05 Apr 2016 04:45:01 -0700 (PDT)
Subject: Re: Scrub priority, am I using it wrong?
To: linux-btrfs@vger.kernel.org
References: <CA+WRLO-vu4B8X3Td12F0gueU70G6KwjRTD07MNwDrJfodAscNA@mail.gmail.com>
 <pan$603b6$4c4f876d$1daf06de$ec75378d@cox.net>
 <CA+WRLO_fkZWsZJFdvMQud1aMTR7kErJVxr9JT0vNpjhQrh2e2Q@mail.gmail.com>
 <pan$1084d$87b30d83$4860fe5b$19700f4b@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5703A50C.6050707@gmail.com>
Date: Tue, 5 Apr 2016 07:44:12 -0400
MIME-Version: 1.0
In-Reply-To: <pan$1084d$87b30d83$4860fe5b$19700f4b@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-05 00:19, Duncan wrote:
> Gareth Pye posted on Tue, 05 Apr 2016 13:44:05 +1000 as excerpted:
>
>> On Tue, Apr 5, 2016 at 12:37 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>>> 1) It appears btrfs scrub start's -c option only takes numeric class,
>>> so try -c3 instead of -c idle.
>>
>>
>> Does it count as a bug if it silently accepts the way I was doing it?
>>
>> I've switched to -c3 and at least now the idle class listed in iotop is
>> idle, so I hope that means it will be more friendly to other processes.
>
> I'd say yes, particularly given that the value must be the numeric class
> isn't documented in the manpage at all.
>
> Whether the bug is then one of documentation (say it must be numeric) or
> of implementation (take the class name as well) is then up for debate.
> I'd call fixing either one a fix.  If it must be numeric, document that
> (and optionally change the implementation to error in some way if a
> numeric parameter isn't supplied for -c), else change the implementation
> so the name can be taken as well (and optionally change the documentation
> to explicitly mention that either one can be used).  Doesn't matter to me
> which.
>
In general, I'd say:
1. The documentation needs to be updated.  Even if it's intended to 
accept class names eventually, it should match the implementation.
2. The implementation needs error checking added.  At the very least, it 
should say something to the effect of "Hey, this doesn't work the way 
you appear to think it does.", and possibly bail.

That said, I don't think there's a huge amount of value in adding the 
ability to accept symbolic names.  Nothing that I know of accepts them 
on the command line, because most things pass the integer directly to 
the syscall, thus allowing for people to use new classes (if any are 
ever introduced) with old tools.

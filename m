Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:33087 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbbIYNMQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 09:12:16 -0400
Received: by igbkq10 with SMTP id kq10so11085001igb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2015 06:12:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56052E0D.3090702@gmail.com>
References: <4362384.AA8xu4anSN@hoefnix>
	<56052E0D.3090702@gmail.com>
Date: Fri, 25 Sep 2015 09:12:15 -0400
Message-ID: <CAGfcS_nFn=AH6Y-4dFQEmy42KVJLBvLuaEHRtoYrBDUtNategw@mail.gmail.com>
Subject: Re: Latest kernel to use?
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Sjoerd <sjoerd@sjomar.eu>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 25, 2015 at 7:20 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-09-24 17:07, Sjoerd wrote:
>>
>> Maybe a silly question for most of you, but the wiki states to always try
>> to
>> use the latest kernel with btrfs. Which one would be best:
>> - 4.2.1 (currently latest stable and matches the btrfs-progs versioning)
>> or
>> - the 4.3.x (mainline)?
>>
>> Stable sounds more stable to me(hence the name ;) ), but the mainline
>> kernel
>> seems to be in more active development?
>>
> Like Hugo said, 4.2.1 is what you want right now.  In general, go with the
> highest version number that isn't a -rc version (4.3 isn't actually released
> yet, IIRC they're up to 4.3-rc2 right now, and almost at -rc3) (we should
> probably be specific like this on the wiki).
>

I'll just say that my btrfs stability has gone WAY up when I stopped
following this advice and instead followed a recent longterm.  Right
now I'm following 3.18.  There were some really bad corruption issues
in 3.17/18/19 that burned me, and today while considering moving up to
4.1 I'm still seeing a lot of threads about issues during balance/etc.
I still run into the odd issue with 3.18, but not nearly to the degree
that I used to.

Now, I would stick with a recent longterm.  The older longterms go
back to a time when btrfs was far more experimental.  Even 3.16
probably has a lot of issues that are fixed in 3.18.

That said, if you do run into an issue on a longterm kernel nobody
around here is likely to be able to help you much unless you can
reproduce it on the most recent stable kernel.

Just tossing that out as an alternative opinion.  Right now I'm
sticking with 3.18, but I'm interested in making the 4.1 switch once
issues with that seem to have died down.

--
Rich

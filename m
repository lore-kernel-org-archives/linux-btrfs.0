Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:51841 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753298AbdJSWsn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 18:48:43 -0400
Received: by mail-io0-f176.google.com with SMTP id b186so11500830iof.8
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 15:48:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171019153940.GL3521@twin.jikos.cz>
References: <20170928143341.24491-1-nefelim4ag@gmail.com> <20170929162200.GP31640@twin.jikos.cz>
 <20171019153940.GL3521@twin.jikos.cz>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 20 Oct 2017 01:48:01 +0300
Message-ID: <CAGqmi75Zz=RqsOymdFOHwHNE7X+2G3Viiitmq+ZROurBOon=FQ@mail.gmail.com>
Subject: Re: [PATCH v8 0/6] Btrfs: populate heuristic with code
To: David Sterba <dsterba@suse.cz>, Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-10-19 18:39 GMT+03:00 David Sterba <dsterba@suse.cz>:
> On Fri, Sep 29, 2017 at 06:22:00PM +0200, David Sterba wrote:
>> On Thu, Sep 28, 2017 at 05:33:35PM +0300, Timofey Titovets wrote:
>> > Compile tested, hand tested on live system
>> >
>> > Change v7 -> v8
>> >   - All code moved to compression.c (again)
>> >   - Heuristic workspaces inmplemented another way
>> >     i.e. only share logic with compression workspaces
>> >   - Some style fixes suggested by Devid
>> >   - Move sampling function from heuristic code
>> >     (I'm afraid of big functions)
>> >   - Much more comments and explanations
>>
>> Thanks for the update, I went through the patches and they looked good
>> enough to be put into for-next. I may have more comments about a few
>> things, but nothing serious that would hinder testing.
>
> I did a final pass through the patches and edited comments wehre I was
> not able to undrerstand them. Please check the updated patches in [1] if
> I did not accidentally change the meaning.

I don't see a link [1] in mail, may be you missed it?
I look at my patches in for-next branch, and that's not looks like
changed, so i assume your link not point at kernel.org %).

> I'm about to add the patchset to the main patch pile for 4.15 soon.
> Further tuning is possible and such patches will be probably accepted
> during the 4.15 development cycle once the as parts have landed. It's
> desirable to gather some testing results of heuristic effects on various
> data types. So far I've been watching for performance drops only.

Just for my information, you compare compress + heuristic with
compression force?

P.S.
Just to sync that we expect from heuristic:
it's expected to get some performance drops on easy compressible data, because
heuristic not free,
but how much this drops?
Main reason for heuristic, it's to win cpu/latency cost for bad
compressible data.
In compare to direct compression.
That allow to provide some worst case stable latency/throughput for userspace.

P.S.S.
I send some emails before, where i show slow paths in heuristic
(sort(), ilog2()).
So i expect that kernel can see same slow downs on that paths.
But i'm don't have enough skills for now, to perform kernel profiling.

> In case the heuristic would turn out to cause problems we can't fix
> during 4.15 cycle, we can still disable it. This is only a last resort
> measure but we need to be prepared.
kk

Thanks.


-- 
Have a nice day,
Timofey.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:52042 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbdJVNop (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 22 Oct 2017 09:44:45 -0400
Received: by mail-io0-f172.google.com with SMTP id b186so17561450iof.8
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Oct 2017 06:44:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171020134511.GQ3521@suse.cz>
References: <20170928143341.24491-1-nefelim4ag@gmail.com> <20170929162200.GP31640@twin.jikos.cz>
 <20171019153940.GL3521@twin.jikos.cz> <CAGqmi75Zz=RqsOymdFOHwHNE7X+2G3Viiitmq+ZROurBOon=FQ@mail.gmail.com>
 <20171020134511.GQ3521@suse.cz>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sun, 22 Oct 2017 16:44:04 +0300
Message-ID: <CAGqmi75xXn7gmAG5DNCH=drfVH0oboP_tDLWzHUQJtvzyDsjGQ@mail.gmail.com>
Subject: Re: [PATCH v8 0/6] Btrfs: populate heuristic with code
To: David Sterba <dsterba@suse.cz>, Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-10-20 16:45 GMT+03:00 David Sterba <dsterba@suse.cz>:
> On Fri, Oct 20, 2017 at 01:48:01AM +0300, Timofey Titovets wrote:
>> 2017-10-19 18:39 GMT+03:00 David Sterba <dsterba@suse.cz>:
>> > On Fri, Sep 29, 2017 at 06:22:00PM +0200, David Sterba wrote:
>> >> On Thu, Sep 28, 2017 at 05:33:35PM +0300, Timofey Titovets wrote:
>> >> > Compile tested, hand tested on live system
>> >> >
>> >> > Change v7 -> v8
>> >> >   - All code moved to compression.c (again)
>> >> >   - Heuristic workspaces inmplemented another way
>> >> >     i.e. only share logic with compression workspaces
>> >> >   - Some style fixes suggested by Devid
>> >> >   - Move sampling function from heuristic code
>> >> >     (I'm afraid of big functions)
>> >> >   - Much more comments and explanations
>> >>
>> >> Thanks for the update, I went through the patches and they looked good
>> >> enough to be put into for-next. I may have more comments about a few
>> >> things, but nothing serious that would hinder testing.
>> >
>> > I did a final pass through the patches and edited comments wehre I was
>> > not able to undrerstand them. Please check the updated patches in [1] if
>> > I did not accidentally change the meaning.
>>
>> I don't see a link [1] in mail, may be you missed it?
>
> Yeah, sorry:
> https://github.com/kdave/btrfs-devel/commits/ext/timofey/heuristic

I did re-read updated comments, looks ok to me
(i only found one typo, leave a comment).


Thanks
-- 
Have a nice day,
Timofey.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34848 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756493AbcIKUOY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 16:14:24 -0400
Received: by mail-oi0-f46.google.com with SMTP id d191so51041234oih.2
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Sep 2016 13:14:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160911130221.GE7138@carfax.org.uk>
References: <57D51BF9.2010907@online.no> <57D53E3A.1030106@online.no>
 <15194548.valIGHoaRh@merkaba> <2682119.DRdtbgPpNZ@merkaba>
 <57D55072.2010701@online.no> <20160911130221.GE7138@carfax.org.uk>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 11 Sep 2016 14:14:21 -0600
Message-ID: <CAJCQCtSW0L_mw7LhrggUO8sAQY4TK5AhhmaSJP_79cf15Whi+A@mail.gmail.com>
Subject: Re: Is stability a joke?
To: Hugo Mills <hugo@carfax.org.uk>, Waxhead <waxhead@online.no>,
        Martin Steigerwald <martin@lichtvoll.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 11, 2016 at 7:02 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sun, Sep 11, 2016 at 02:39:14PM +0200, Waxhead wrote:
>> Martin Steigerwald wrote:
>> >Am Sonntag, 11. September 2016, 13:43:59 CEST schrieb Martin Steigerwald:
>> >>>>Thing is: This just seems to be when has a feature been implemented
>> >>>>matrix.
>> >>>>Not when it is considered to be stable. I think this could be done with
>> >>>>colors or so. Like red for not supported, yellow for implemented and
>> >>>>green for production ready.
>> >>>Exactly, just like the Nouveau matrix. It clearly shows what you can
>> >>>expect from it.
>> >I mentioned this matrix as a good *starting* point. And I think it would be
>> >easy to extent it:
>> >
>> >Just add another column called "Production ready". Then research / ask about
>> >production stability of each feature. The only challenge is: Who is
>> >authoritative on that? I´d certainly ask the developer of a feature, but I´d
>> >also consider user reports to some extent.
>> >
>> >Maybe thats the real challenge.
>> >
>> >If you wish, I´d go through each feature there and give my own estimation. But
>> >I think there are others who are deeper into this.
>> That is exactly the same reason I don't edit the wiki myself. I
>> could of course get it started and hopefully someone will correct
>> what I write, but I feel that if I start this off I don't have deep
>> enough knowledge to do a proper start. Perhaps I will change my mind
>> about this.
>
>    Given that nobody else has done it yet, what are the odds that
> someone else will step up to do it now? I would say that you should at
> least try. Yes, you don't have as much knowledge as some others, but
> if you keep working at it, you'll gain that knowledge. Yes, you'll
> probably get it wrong to start with, but you probably won't get it
> *very* wrong. You'll probably get it horribly wrong at some point, but
> even the more knowledgable people you're deferring to didn't identify
> the problems with parity RAID until Zygo and Austin and Chris (and
> others) put in the work to pin down the exact issues.
>
>    So I'd strongly encourage you to set up and maintain the stability
> matrix yourself -- you have the motivation at least, and the knowledge
> will come with time and effort. Just keep reading the mailing list and
> IRC and bugzilla, and try to identify where you see lots of repeated
> problems, and where bugfixes in those areas happen.
>
>    So, go for it. You have a lot to offer the community.

I agree.

Mistakes happen, but there should be explanations. My suggestion is to
keep it really concise. It will be easier to maintain, less prone to
interpretation (better to get it flat out wrong, which gives it a
better chance of being caught and fixed, than being vague), and make
it more readable.

I recently received a beat down over on opensuse-factory list because
I said they should revert quotas by default. And the reason for that
was, hanging out here and connecting the only dots that are really
available upstream suggested they're ready for testing not production
usage. But suse/opensuse have a different opinion, and yet that
opinion hasn't been expressed on this list until recently. On the one
hand I'm a little annoyed the developer to user communication is
lacking significantly enough that this miscommunication can happen, on
the other hand I realize they're up to their eyeballs doing things
they do best which is fixing bugs and adding features. I don't know
that anyone has a perfect idea of what is "stable" until it passes the
test of time.

So you can expect things to change. Something might become clearly
less stable than we thought, more likely it'll become more stable than
it is now but in slow not so obvious ways.



-- 
Chris Murphy

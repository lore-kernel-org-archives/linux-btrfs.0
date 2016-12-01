Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:33045 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751758AbcLAVku (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Dec 2016 16:40:50 -0500
Received: by mail-lf0-f46.google.com with SMTP id c13so181497827lfg.0
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Dec 2016 13:40:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSuVNKnXVdOzWamNGGh+43a0PQacjAHGrFyjPYCPYPfvQ@mail.gmail.com>
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de> <fce2df8b-0775-1ecf-c08d-960018822c20@googlemail.com>
 <20161130103808.74e5ae95@natsu> <3713990.abIjkpnqyF@merkaba>
 <73d0d10c-7a06-b282-ee76-4512aaed5723@googlemail.com> <pan$7a75f$e48f1aa5$204a0630$9d1c1cc4@cox.net>
 <b13f13a4-639d-d460-7642-c8f8fe646832@googlemail.com> <19671a71-5d1c-c42e-db3d-c870ec08b2ff@gmail.com>
 <CAJCQCtRnqp15QZ9V+AtBu1_7QwChdoRMs0nHg3stWnJOyy8qMw@mail.gmail.com>
 <CAKinxcUBNa5durypXVvesfkYY_bTj8W79wuj-2SeNYmFEZMfjw@mail.gmail.com> <CAJCQCtSuVNKnXVdOzWamNGGh+43a0PQacjAHGrFyjPYCPYPfvQ@mail.gmail.com>
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Date: Thu, 1 Dec 2016 21:40:48 +0000
Message-ID: <CAKinxcU39Rz4vJ651X+AZt9VGtRmwJwjq0sxR98MSZ0QgQ0U9A@mail.gmail.com>
Subject: Re: Convert from RAID 5 to 10
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Wilson Meier <wilson.meier@gmail.com>, Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

FYI.
There is an old saying in embedded circles that I revolve that evolved
from Arthur C Clarke "Any sufficiently advanced technology is
indistinguishable from magic." Engineering version states "Any
sufficiently advanced incompetence is indistinguishable from malice"
Also I'll quote you on throwing under the bus thing :) (I actually
like that justification)

On 1 December 2016 at 17:28, Chris Murphy <lists@colorremedies.com> wrote:
> On Wed, Nov 30, 2016 at 1:29 PM, Tomasz Kusmierz <tom.kusmierz@gmail.com> wrote:
>
>> Please, I beg you add another column to man and wiki stating clearly
>> how many devices every profile can withstand to loose. I frequently
>> have to explain how btrfs profiles work and show quotes from this
>> mailing list because "dawning-kruger effect victims" keep poping up
>> with statements like "in btrfs raid10 with 8 drives you can loose 4
>> drives" ... I seriously beg you guys, my beating stick is half broken
>> by now.
>
> You need a new stick. It's called the ad hominem attack. When stupid
> people say stupid things, the dispute is not about the facts or
> opinions in the argument itself, but rather the person involved. There
> is the possibility this is more than stupidity, it really borders on
> maliciousness. Any ethical code of conduct for a list will accept ad
> hominem attacks over the willful dissemination of provably wrong
> information. When stupid assholes throw users under the bus with
> provably wrong (and bad) advice, it becomes something of an obligation
> to resort to name calling.
>
> Of course, I'd also like the wiki to clearly state the only profile
> that tolerates more than one device loss is raid6; and be very
> explicit with the manifestly wrong terminology being used by Btrfs's
> raid10 terminology. That is a fairly egregious violation of common
> terminology and the trust we're supposed to be developing, both in the
> usage of common terms, but also in Btrfs specifically.
>
>
>
> --
> Chris Murphy

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33248 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753693AbcIKUVR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 16:21:17 -0400
Received: by mail-oi0-f51.google.com with SMTP id y2so267893276oie.0
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Sep 2016 13:21:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3528227.b3qLKf8xnv@merkaba>
References: <57D51BF9.2010907@online.no> <2682119.DRdtbgPpNZ@merkaba>
 <57D55072.2010701@online.no> <3528227.b3qLKf8xnv@merkaba>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 11 Sep 2016 14:21:14 -0600
Message-ID: <CAJCQCtRQrXGDbR65ZwDw6nUbxGsTM3dFhPVh+MqU5gomuN-X2g@mail.gmail.com>
Subject: Re: Is stability a joke?
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Waxhead <waxhead@online.no>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 11, 2016 at 8:54 AM, Martin Steigerwald <martin@lichtvoll.de> wrote:
> Am Sonntag, 11. September 2016, 14:39:14 CEST schrieb Waxhead:
>> Martin Steigerwald wrote:
>> > Am Sonntag, 11. September 2016, 13:43:59 CEST schrieb Martin Steigerwald:
>> >>>>> The Nouveau graphics driver have a nice feature matrix on it's webpage
>> >>>>> and I think that BTRFS perhaps should consider doing something like
>> >>>>> that
>> >>>>> on it's official wiki as well
>> >>>>
>> >>>> BTRFS also has a feature matrix. The links to it are in the "News"
>> >>>> section
>> >>>> however:
>> >>>>
>> >>>> https://btrfs.wiki.kernel.org/index.php/Changelog#By_feature
> […]
>> > I mentioned this matrix as a good *starting* point. And I think it would
>> > be
>> > easy to extent it:
>> >
>> > Just add another column called "Production ready". Then research / ask
>> > about production stability of each feature. The only challenge is: Who is
>> > authoritative on that? I´d certainly ask the developer of a feature, but
>> > I´d also consider user reports to some extent.
>> >
>> > Maybe thats the real challenge.
>> >
>> > If you wish, I´d go through each feature there and give my own estimation.
>> > But I think there are others who are deeper into this.
>>
>> That is exactly the same reason I don't edit the wiki myself. I could of
>> course get it started and hopefully someone will correct what I write,
>> but I feel that if I start this off I don't have deep enough knowledge
>> to do a proper start. Perhaps I will change my mind about this.
>
> Well one thing would be to start with the column and start filling the more
> easy stuff. And if its not known since what kernel version, but its known to
> be stable I suggest to conservatively just put the first kernel version into
> it where people think it is stable or in doubt even put 4.7 into it. It can
> still be reduced to lower kernel versions.
>
> Well: I made a tiny start. I linked "Features by kernel version" more
> prominently on the main page, so it is easier to find and also added the
> following warning just above the table:
>
> "WARNING: The "Version" row states at which version a feature has been merged
> into the mainline kernel. It does not tell anything about at which kernel
> version it is considered mature enough for production use."
>
> Now I wonder: Would adding a "Production ready" column, stating the first
> known to be stable kernel version make sense in this table? What do you think?
> I can add the column and give some first rough, conservative estimations on a
> few features.
>
> What do you think? Is this a good place?

Yes. Again I'd emphasize keeping it simple, even at some risk of
oversimplification. There can be the "bird's eye view" matrix, with
some footnotes to further qualify things. And the rest of the wiki for
details that are often repeated on the list but shouldn't need to be
repeated on the list. And then the list for conversations/evaluations.
It is really a lot easier to make the wiki too verbose, making good
info harder to find. Wherever possible just take a stand, have an
opinion, defer explanations to links to posts. That way people who
want to read volumes of source material can, those who just need to
get on with business can too, rather than having to filter a volume of
stale material.

Production ready comes with some assumptions, like stable hardware. In
what ways is Btrfs less tolerant of device problems than other
configurations? In what was is Btrfs more tolerant? That might be a
good thread down the road.


-- 
Chris Murphy

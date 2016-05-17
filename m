Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33337 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbcEQV6W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 17:58:22 -0400
Received: by mail-wm0-f66.google.com with SMTP id r12so8165073wme.0
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 14:58:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTKDoZEKovqm4k=pPNDenDVAiFDGZDMvns4T9DD4tJsZw@mail.gmail.com>
References: <CABt16=EDFKFj4duaWJ0qCS_SO9TE2jn8UMCx5e_u+X+M328yeA@mail.gmail.com>
	<4218ab2f-def8-6541-427d-49091f70e342@gmail.com>
	<CAJCQCtRCFTEHoGxDMccJx7CLSPwLqSiqhd6--niCzrQ1FtJ+Bg@mail.gmail.com>
	<CAJVJNe4Ek8UR3Qq+p9fAu3bU-2dCdDcothgR=S6CsQKOo6zKFg@mail.gmail.com>
	<CAJCQCtTKDoZEKovqm4k=pPNDenDVAiFDGZDMvns4T9DD4tJsZw@mail.gmail.com>
Date: Wed, 18 May 2016 00:58:21 +0300
Message-ID: <CAJVJNe6wp-dhDKB2u6x73fk3OQ0KOVozkOEJ-feZn8RT5wOecw@mail.gmail.com>
Subject: Re: Corrupted system due to imbalanced metadata chunks
From: Goni Zahavy <goni1993@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Peter Kese <peter.kese@viidea.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/18/16, Chris Murphy <lists@colorremedies.com> wrote:
> On Tue, May 17, 2016 at 2:27 PM, Goni Zahavy <goni1993@gmail.com> wrote:
>> Guys, just remember that this crappy-installer behavior works
>> "as-expected"
>> on every other filesystem.
>
> It also fails as expected on every other file system if the upgrade is
> interrupted for reasons that have nothing to do with the file system;
> what's in common is the lack of a fail safe upgrade design. And this
> is not a ding on Ubuntu, it's a widespread and well recognized risk.
> All that's happening here is Btrfs has one more vector to expose that
> deficiency.

I fully agree, but I talked about the "many small files unpacked to
temp on disk location then copied.." which is just plain badness

>
>> I think we need to treat this as a trigger to unwanted/unexpected
>> behavior
>> on btrfs's part, especially in this "dead-simple" setup, in order for us
>> to
>> gain a bug/behavior fix in the near future.
>
> There are work arounds:
>
> use -M when creating the file system, accepting some loss of
> performance and inline small file packing efficiency;
>
> run a preemptive filtered balance on a timer.
>
> Fixing it in the kernel is a great idea, but if that were trivial I
> think it'd have been done by now. It's not like this problem is
> unknown on this list.
>
>> In my opinion, we simply cannot "blame" the user/installer code in the
>> current state of btrfs especially in the "considered stable enough"
>> feature
>> sets.
>
>
> OK blame was the wrong word for me to use, but the root cause of the
> problem is shared.
>
> I agree the user is least to blame, but so long as the status of the
> fs overall is benchmarking and review it's difficult to say the user
> has no role whatsoever in helping prevent it, as tedious as that is.
>
> --
> Chris Murphy
>

It's great that we have workarounds for the user/distribution to
apply. And If this is a known issue, I would expect that Peter Kese
would be answered here with "it's a known issue, here is how you can
work around it the next time. And it was written in underlined bold
warning on this wiki page. Stay tuned.".

In addition, I would expect bugs like this one that hit even simple
single-mode setups to be prioritized way way higher then any new
feature or even some existing advanced feature enhancements..

Just to clarify, I think that your work is devine and I'm glad for it.
I'm just trying to contribute here since I'm unable to contribute in
code/tests :)

Goni Zahavy

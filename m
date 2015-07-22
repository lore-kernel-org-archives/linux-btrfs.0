Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:36170 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964849AbbGVB35 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jul 2015 21:29:57 -0400
Received: by oibn4 with SMTP id n4so135013140oib.3
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2015 18:29:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$3ae51$bc5b796f$ddf9ddc1$392a5e3c@cox.net>
References: <11148188.L9vtSMaNHV@merkaba> <559FA280.8090309@tty0.ch>
 <20150712035523.GI5274@merlins.org> <20150713004249.GP5274@merlins.org>
 <CAB3_QuKuTeT7t--=y917AASM9QQHSRin4ZKRm57A0b+z0m=yvA@mail.gmail.com>
 <20150715031412.GZ5274@merlins.org> <20150715080057.GA15200@panda>
 <CAC=t97CxDRoakqzoOAoHpN=1qS1jyvMEfOCe+RWvGTm6xSCqPQ@mail.gmail.com>
 <CAC=t97BS2gNNLZEatTRCmmiUHLH8m6NFbgtkbWnaqrEsCye1KQ@mail.gmail.com>
 <20150715214913.GG5274@merlins.org> <CAC=t97CcemZzBjABSLS5etSF6B-67SvwL25q62hxv2de3zLPbw@mail.gmail.com>
 <pan$7f5c7$63eed743$33fa939$36f57317@cox.net> <CAC=t97AK_4PMT4NAWiW_OwhGFidJOR6mrUh=9gnTqeRNHAjxRw@mail.gmail.com>
 <pan$3ae51$bc5b796f$ddf9ddc1$392a5e3c@cox.net>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Tue, 21 Jul 2015 20:29:37 -0500
Message-ID: <CAC=t97B-J2DhY5Bv9EUxSRo4g6xPg8E=n3TenrYa6X5xVQx5cg@mail.gmail.com>
Subject: Re: Anyone tried out btrbk yet?
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the feedback Duncan.

It doesn't appear to be a big deal to disable quotas so that's what
I'll do for now.

On Tue, Jul 21, 2015 at 4:29 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Donald Pearson posted on Mon, 20 Jul 2015 08:33:47 -0500 as excerpted:
>
>>> Also, FWIW, the btrfs quota subsystem increases snapshot management
>>> complexity dramatically, so if you're using that, aim for the low ends
>>> of the above recommendation if at all possible, and/or consider either
>>> turning off the quota stuff or using a filesystem other than btrfs, as
>>> in addition to the scaling issues, the quota management code has been a
>>> source of repeated bugs and isn't a feature I'd recommend relying on
>>> until it has at least several kernel cycles worth of trouble-free
>>> history behind it.
>>
>> Thanks for the insight.  I just took a look at dmesg and found this.
>> Is this coincidental or is this maybe the reason things appear to be
>> stuck?  I'm not sure how to read this.
>>
>> [195400.023165] ------------[ cut here ]------------
>> [195400.023199] WARNING: CPU: 2 PID: 16987 at fs/btrfs/qgroup.c:1028
>> __qgroup_excl_accounting+0x1dc/0x270 [btrfs]()
>
> I don't know.  I'm not a btrfs quota feature user.
>
> What I do know is that there has been... again... more quota code patches
> recently, fixing what sound like serious problems.
>
> You already have my recommendation above; unless you are actively testing
> the btrfs quota code, if you don't need it, don't use it; if you do need
> it, use something where it's actually working well enough to /rely/ on.
>
> But in fairness that's potentially a negatively biased view, since as I'm
> on the list but not actually using that feature I'm seeing the bug
> reports without much in the way of knowing how common they actually are.
> If it's a big deal to turn quotas off, I'd say wait and see if the dev
> actually working on it cares to comment with his opinion of quota feature
> stability in general, and perhaps of that specific trace, before deciding
> for sure.
>
> But if you have the inclination and don't really need quotas, and
> assuming disabling them isn't /too/ big a hassle, it might be worthwhile
> disabling the feature and seeing how things go.  I can't see how not
> having to deal with quotas could /hurt/ scaling, and with luck, it'll
> improve things noticeably.
>
> FWIW, the developer post where the effect of quotas on scaling was
> explained was actually in the context of snapshot-aware-defrag, which has
> been disabled for awhile now, /because/ of the scaling issues (it was so
> bad the defrag would basically hang, taking hours to defrag a single
> moderately sized file as it tracked it thru the various snapshots, so
> processing time for a full filesystem could easily be weeks and could in
> some cases be months, obviously well outside any practically workable
> range!), and while quota processing was explained to be horrible in that
> context at that time (I read it as at least doubling the necessary work),
> there has been at least one quota-code rewrite since then, as well as
> additional work, and it may actually not be nearly as bad any more,
> barring a direct bug, of course.  But I don't know as I've not seen any
> direct statements or numbers either way, only the bug reports and patches
> going by.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

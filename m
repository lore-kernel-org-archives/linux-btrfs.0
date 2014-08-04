Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:49945 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaHDKci (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 06:32:38 -0400
Received: by mail-vc0-f169.google.com with SMTP id le20so10548576vcb.14
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Aug 2014 03:32:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140804102206.GA31950@carfax.org.uk>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
 <53DEE40C.6020403@cn.fujitsu.com> <CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>
 <17833067.mzxAL4oqZq@quad> <CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com>
 <20140804102206.GA31950@carfax.org.uk>
From: Peter Waller <peter@scraperwiki.com>
Date: Mon, 4 Aug 2014 11:31:57 +0100
Message-ID: <CAFChkquonAbMbPynpxvayb3qpLAEcMSfC2TvGKCG+kFo-Qy7eA@mail.gmail.com>
Subject: Re: ENOSPC with mkdir and rename
To: Hugo Mills <hugo@carfax.org.uk>, Peter Waller <peter@scraperwiki.com>,
        Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Hugo, this is the most informative e-mail yet! (more inline)

On 4 August 2014 11:22, Hugo Mills <hugo@carfax.org.uk> wrote:
>
>  * btrfs fi show
>     - look at the total and used values. If used < total, you're OK.
>       If used == total, then you could potentially hit ENOSPC.

Another thing which is unclear and undocumented anywhere I can find is
what the meaning of `btrfs fi show` is.

I'm sure it is totally obvious if you are a developer or if you have
used it for long enough. But it isn't covered in the manpage, nor in
the oracle documentation, nor anywhere on the wiki that I could find.

When I looked at it in my problematic situation, it said "500 GiB /
500 GiB". That sounded fine to me because I interpreted the output as
what fraction of which RAID devices BTRFS was using. In other words, I
thought "Oh, BTRFS will just make use of the whole device that's
available to it.". I thought that `btrfs fi df` was the source of
information for how much space was free inside of that.

>  * btrfs fi df
>     - look at metadata used vs total. If these are close to zero (on
>       3.15+) or close to 512 MiB (on <3.15), then you are in danger of
>       ENOSPC.

Hmm. It's unfortunate that this could indicate an amount of space
which is free when it actually isn't.

>     - look at data used vs total. If the used is much smaller than
>       total, you can reclaim some of the allocation with a filtered
>       balance (btrfs balance start -dusage=5), which will then give
>       you unallocated space again (see the btrfs fi show test).

So the filtered balance didn't help in my situation. I understand it's
something to do with the "5" parameter. But I do not understand what
the impact of changing this parameter is. It is something to do with a
fraction of something, but those things are still not present in my
mental model despite a large amount of reading. Is there an
illustration which could clear this up?

Among other things I also got the kernel stack trace I pasted at the
bottom of the first e-mail to this thread when I did the rebalance.

>    This FAQ entry is pretty horrible, I'm afraid. I actually started
> rewriting it here to try to make it clearer what's going on. I'll try
> to work on it a bit more this week and put out a better version for
> the wiki.

This is great to hear! :)

Thanks for your response Hugo, that really cleared up a lot of mental
model problems. I hope the documentation can be improved so that
others can learn from my mistakes.

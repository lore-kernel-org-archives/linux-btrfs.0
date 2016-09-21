Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34503 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934347AbcIUPCd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 11:02:33 -0400
Received: by mail-oi0-f54.google.com with SMTP id a62so63062115oib.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Sep 2016 08:02:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <09b358f4-4564-e885-411a-27020a496755@cn.fujitsu.com>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it> <09b358f4-4564-e885-411a-27020a496755@cn.fujitsu.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 21 Sep 2016 09:02:31 -0600
Message-ID: <CAJCQCtTKzQHnfLGPEbiBhLRtRpiF=WtWLRXGCjtBvA76KStHrg@mail.gmail.com>
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Goffredo Baroncelli <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 21, 2016 at 1:28 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Hi,
>
> For this well-known bug, is there any one fixing it?
>
> It can't be more frustrating finding some one has already worked on it after
> spending days digging.
>
> BTW, since kernel scrub is somewhat scrap for raid5/6, I'd like to implement
> btrfsck scrub support, at least we can use btrfsck to fix bad stripes before
> kernel fix.

Well the kernel will fix it if the user just scrubs again. The problem
is the user doesn't know their file system might have bad parity. So I
don't know how implementing an optional check in btrfsk helps. If it's
non-optional that means reading 100% of the volume, not just metadata,
that's not workable for btrfsck. The user just needs to do another
scrub if they suspect they have been hit by this, and if they get no
errors they're OK. If they get an error that something is being fixed,
they might have to do a 2nd scrub to avoid this bug - but I'm not sure
if there's any different error message between a non-parity strip
being fixed compared to parity strip being replaced.

The central thing happening in this bug is it requires a degraded full
stripe [1] already exists. That is, a non-parity strip [2] is already
corrupt. What this bug does is it fixes that strip from good parity,
but then wrongly recomputes parity for some reason and writes bad
parity to disk. So it shifts the "degradedness" of the full stripe
from non-parity to parity. There's no actual additional loss of
redundancy, it's just that the messages will say a problem was found
and fixed, which is not entirely true. Non-parity data is fixed, but
now parity is wrong, silently. There is no consequence of this unless
it's raid5 and there's another strip loss in that same stripe.

Uncertain if the bug happens with raid6, or if raid6 extra redundancy
has just masked the problem. Uncertain if the bug happens with
balance, or passively with normal reads. Only scrub has been tested
and it's non-deterministic, maybe happens 1 in 3 or 4 attempts.


[1][2]
I'm using SNIA terms. Strip = stripe element = mdadm chunk = the 64KiB
per device block. Stripe = full stripe = data strips + parity strip
(or 2 strips for raid6).


-- 
Chris Murphy

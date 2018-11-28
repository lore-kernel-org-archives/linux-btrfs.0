Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF8CC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 20:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 316C92081C
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 20:08:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t7nzRI7r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 316C92081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbeK2HLE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 02:11:04 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:34119 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbeK2HLE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 02:11:04 -0500
Received: by mail-vs1-f67.google.com with SMTP id y27so16886787vsi.1
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 12:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=1XXoMC2vTak6FfFE2QzdJHlZqp8P4MNMgZUzW7QTEBk=;
        b=t7nzRI7rERFIZ/Z4D1irgzCjfzeFfbDmP1wVElTMXZJG55QujdzEH2Uf0LslEMo7R+
         AdiZIMEBKPv1oRTOjOeDgAcby8cUD/0lDqljt3BqUEV23ZYbUSBQMsx5YB9TfUeNODzs
         bnTE9D/52EyrxaEY4YwLNt6HiKmyMjWn66nPInbKxnrI5519s7WsUH6AOa5L8kfQ3ZIN
         uiPXWUBO2c2eZIJTPUWFdF/e0qK4Uc5C+HVkm1RKpjRZDD7+5+7Da1U7ME/liAqPwBHN
         JBgdGBMX3018IkAlUBSu434kDdnJwC1aobcI+yTlXtYSgb1AY5Lr0/GBwiWvylTZQQW8
         vx+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:content-transfer-encoding;
        bh=1XXoMC2vTak6FfFE2QzdJHlZqp8P4MNMgZUzW7QTEBk=;
        b=kFP27QldQtte726JDfrIwSg4RQk/pKPSxxKASIb3yPozIK6V95MBRHEnN2LhqrKLgR
         rZgaF9rRX3rIqj678a4Q0A05E9RPEMcKmOzXe4hz1ac1tU7N2Ur+RDvQkzUu26rcANtT
         9Pw2b/fubBC8T4yim28JUjQf4TTCm76LqebLuQxOEjxLWsC/0Es5D2m/IZTNbKfOGA3R
         r5txbxA6ICjitEBjYH4YoUjMEkXYttfkAtZ10QMwcn8/QkDJBUhhLciSWK4O11O590rs
         y2Vm7fH8VfAbDN4vygCV74KKuWzSJlgVBjv4of4C3ThYBA5J5bEm9rWsI7a7qavC3Qaq
         e4vg==
X-Gm-Message-State: AGRZ1gJO1k8MAyWGFrETGYFbm1AW3cLicwGX0bVYhH+SkxdlVw/rQFvc
        kiY6NKDztXd4vjEs8JbmuSvDzI+EqFDQ/6MX0jo=
X-Google-Smtp-Source: AJdET5cOGcupOOAEx6J2yGtheasQiw0dBeDcK7RmA5Qv21lv+eA39e9nDjZv78BNleFcjZRMCOjvFdL5Gk9XCoYluT4=
X-Received: by 2002:a67:4c51:: with SMTP id z78mr13868550vsa.99.1543435694049;
 Wed, 28 Nov 2018 12:08:14 -0800 (PST)
MIME-Version: 1.0
References: <20181121190922.25038-1-josef@toxicpanda.com> <20181121190922.25038-3-josef@toxicpanda.com>
 <4e8aad56-42e2-d666-c909-d5d058b799c9@suse.com> <20181127195450.fjor2gewhp3hri56@macbook-pro-91.dhcp.thefacebook.com>
 <13D3592A-3719-4F9E-8E8A-944FE88F30D4@fb.com> <20181127200807.bdnvwap2kuuwuarg@macbook-pro-91.dhcp.thefacebook.com>
 <20181128190633.GZ2842@twin.jikos.cz>
In-Reply-To: <20181128190633.GZ2842@twin.jikos.cz>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Wed, 28 Nov 2018 20:08:02 +0000
Message-ID: <CAL3q7H52+ELQBw4kn7aUJqX+TR=NMFHvtY4QTVvsM0UNJauQvw@mail.gmail.com>
Subject: Re: [PATCH 2/3] btrfs: wakeup cleaner thread when adding delayed iput
To:     dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        Chris Mason <clm@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, Kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 7:09 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Tue, Nov 27, 2018 at 03:08:08PM -0500, Josef Bacik wrote:
> > On Tue, Nov 27, 2018 at 07:59:42PM +0000, Chris Mason wrote:
> > > On 27 Nov 2018, at 14:54, Josef Bacik wrote:
> > >
> > > > On Tue, Nov 27, 2018 at 10:26:15AM +0200, Nikolay Borisov wrote:
> > > >>
> > > >>
> > > >> On 21.11.18 =D0=B3. 21:09 =D1=87., Josef Bacik wrote:
> > > >>> The cleaner thread usually takes care of delayed iputs, with the
> > > >>> exception of the btrfs_end_transaction_throttle path.  The cleane=
r
> > > >>> thread only gets woken up every 30 seconds, so instead wake it up=
 to
> > > >>> do
> > > >>> it's work so that we can free up that space as quickly as possibl=
e.
> > > >>
> > > >> Have you done any measurements how this affects the overall system=
. I
> > > >> suspect this introduces a lot of noise since now we are going to b=
e
> > > >> doing a thread wakeup on every iput, does this give a chance to ha=
ve
> > > >> nice, large batches of iputs that  the cost of wake up can be
> > > >> amortized
> > > >> across?
> > > >
> > > > I ran the whole patchset with our A/B testing stuff and the patchse=
t
> > > > was a 5%
> > > > win overall, so I'm inclined to think it's fine.  Thanks,
> > >
> > > It's a good point though, a delayed wakeup may be less overhead.
> >
> > Sure, but how do we go about that without it sometimes messing up?  In =
practice
> > the only time we're doing this is at the end of finish_ordered_io, so l=
ikely to
> > not be a constant stream.  I suppose since we have places where we forc=
e it to
> > run that we don't really need this.  IDK, I'm fine with dropping it.  T=
hanks,
>
> The transaction thread wakes up cleaner periodically (commit interval,
> 30s by default), so the time to process iputs is not unbounded.
>
> I have the same concerns as Nikolay, coupling the wakeup to all delayed
> iputs could result in smaller batches. But some of the callers of
> btrfs_add_delayed_iput might benefit from the extra wakeup, like
> btrfs_remove_block_group, so I don't want to leave the idea yet.

I'm curious, why do you think it would benefit btrfs_remove_block_group()?



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:45321 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751089AbdLAVDc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Dec 2017 16:03:32 -0500
Received: by mail-oi0-f51.google.com with SMTP id x20so8019127oix.12
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Dec 2017 13:03:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b2b86926-69b9-e44a-62c0-9e3233ed100f@techsquare.com>
References: <bb2cfbcb-31dd-715c-114f-59d574a2012b@techsquare.com>
 <9703c200-28af-f26d-b3b2-6982fb289ac8@mendix.com> <1d11e03c-7d02-3f66-8b97-4c1b857566fa@techsquare.com>
 <b52265f9-2703-7f25-b1b9-6e84bc7db62e@mendix.com> <c9e5ef0a-e60b-b892-272c-1594d47f0657@techsquare.com>
 <5ecddad2-bb6a-2991-c8d0-be97a4541b0d@mendix.com> <17ead8e4-106e-f568-e996-ab472814a749@techsquare.com>
 <62d9e40d-3a73-303e-51d5-1b146230fa0d@applied-asynchrony.com>
 <b7294c64-280e-7415-6ae9-7673a37f7370@mendix.com> <b2b86926-69b9-e44a-62c0-9e3233ed100f@techsquare.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 1 Dec 2017 14:03:31 -0700
Message-ID: <CAJCQCtRisOOUcJYrJO_mRjPpUjeoceCCgBnBzSMs2T-_5fnrkg@mail.gmail.com>
Subject: Re: btrfs-transacti hammering the system
To: Matt McKinnon <matt@techsquare.com>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 1, 2017 at 12:07 PM, Matt McKinnon <matt@techsquare.com> wrote:
> Right.  The file system is 48T, with 17T available, so we're not quite
> pushing it yet.
>
> So far so good on the space_cache=v2 mount.  I'm surprised this isn't on the
> gotcha page in the wiki; it may end up making a world of difference to the
> users here
>

I'd change one  thing at a time so you learn what change does/doesn't
resolve the problem. For storage of mostly large files, autodefrag
doesn't seem applicable, but I'd leave it on for now since you've
already made the space cache v2 change.


-- 
Chris Murphy

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36758 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934242AbcIOOPO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 10:15:14 -0400
Received: by mail-oi0-f41.google.com with SMTP id q188so70729771oia.3
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 07:15:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b21c740b-5d71-7edd-f2fd-1ba6ea156dba@gmail.com>
References: <57D51BF9.2010907@online.no> <20160912142714.GE16983@twin.jikos.cz>
 <52304724-5bca-a1e6-527f-040085c7ab19@gmail.com> <20160912165107.GG16983@twin.jikos.cz>
 <58a954fc-bbd5-3fb5-9f23-008ed7f7121d@gmail.com> <20160915010759.GD32452@DigitalMercury.dynalias.net>
 <5dec6544a78a0301a8e0cd9086179f99@crc.id.au> <1473905644.8603.44.camel@scientia.net>
 <c58cd350-a1e8-7d1c-cf8c-84f7f0c05682@mendix.com> <b21c740b-5d71-7edd-f2fd-1ba6ea156dba@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 15 Sep 2016 08:15:13 -0600
Message-ID: <CAJCQCtSJ0N3WHUcAym_N7fghRh08YnHEQD+AzCDGSkUyVxLKJQ@mail.gmail.com>
Subject: Re: stability matrix
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 15, 2016 at 5:54 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
>
>
> I specifically do not think we should worry about distro kernels though.

It will be essentially impossible to keep such a thing up to date.
It's difficult in the best case scenario to even track upstream's own
backports to longterm kernels, whether those would actually even
change anything in the matrix.

I'd say each major version gets it's own page, and just dup the page
for each version.

So for starters, the current page is for version 4.7. If when 4.8 is
released there's no significant change in stability that affects the
color (stability status) of any listed feature, then that page could
say 4.7 through current. If it's true that the status page has no
major changes going back to 4.4 through current, label it that way.

As soon as there's a change that affects the color coding of an item
in the grid, duplicate the page. Old page gets a fixed range of
kernels, say 4.4 to 4.7. And now the newest page is 4.8 - current.

I think a column for version will lose the historical perspective of
when something goes from red to yellow, yellow to green.


> If
> someone is using a specific distro, that distro's documentation should cover
> what they support and what works and what doesn't.  Some (like Arch and to a
> lesser extent Gentoo) use almost upstream kernels, so there's very little
> point in tracking them.  Some (like Ubuntu and Debian) use almost upstream
> LTS kernels, so there's little point tracking them either.  Many others
> though (like CentOS, RHEL, and OEL) Use forked kernels that have so many
> back-ported patches that it's impossible to track up-date to up-date what
> the hell they've got.  A rather ridiculous expression regarding herding of
> cats comes to mind with respect to the last group.

Yeah you need the secret decoder ring to sort it out. Forget it, not worth it.


-- 
Chris Murphy

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:32905 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758164AbdEVX01 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 May 2017 19:26:27 -0400
Received: by mail-yw0-f181.google.com with SMTP id p73so56315487ywp.0
        for <linux-btrfs@vger.kernel.org>; Mon, 22 May 2017 16:26:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170522163156.5hcuw5tqfavjkmnm@merlins.org>
References: <20170521214733.c62v7el4g66jf63x@merlins.org> <20170521234557.pu3vs3igdx7mqjzb@merlins.org>
 <20170522013553.hspdrwpmxe5kyoas@merlins.org> <20170522163156.5hcuw5tqfavjkmnm@merlins.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 22 May 2017 17:26:25 -0600
Message-ID: <CAJCQCtSO5O7Pi-4oLsZNr6r6PLVEL6EXA6wpWPjBSUKYe9m4Gg@mail.gmail.com>
Subject: Re: 4.11.1: cannot btrfs check --repair a filesystem, causes heavy
 memory stalls
To: Marc MERLIN <marc@merlins.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 22, 2017 at 10:31 AM, Marc MERLIN <marc@merlins.org> wrote:

>
> I already have 24GB of RAM in that machine, adding more for the real
> fsck repair to run, is going to be difficult and ndb would take days I
> guess (then again I don't have a machine with 32 or 48 or 64GB of RAM
> anyway).

If you can acquire an SSD, you can give the system a bunch of swap,
and at least then hopefully the check repair can complete. Yes it'll
be slower than with real RAM but it's not nearly as bad as you might
think it'd be, based on HDD based swap.



-- 
Chris Murphy

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:33034 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388884AbeHANGr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2018 09:06:47 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1fkpBx-0006ky-4O
        for linux-btrfs@vger.kernel.org; Wed, 01 Aug 2018 13:21:21 +0200
Date: Wed, 1 Aug 2018 13:21:21 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS and databases
Message-ID: <20180801112120.f4h535yge6vqcsdp@angband.pl>
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 01, 2018 at 05:45:15AM +0200, MegaBrutal wrote:
> But there is still one question that I can't get over: if you store a
> database (e.g. MySQL), would you prefer having a BTRFS volume mounted
> with nodatacow, or would you just simply use ext4?
> 
> I know that with nodatacow, I take away most of the benefits of BTRFS
> (those are actually hurting database performance – the exact CoW
> nature that is elsewhere a blessing, with databases it's a drawback).
> But are there any advantages of still sticking to BTRFS for a database
> albeit CoW is disabled, or should I just return to the old and
> reliable ext4 for those applications?

Is this database performance-critical?

If yes, you'd want ext4 -- nocow is a crappy ext4 lookalike, with no
benefits of btrfs.  Or, if you snapshot it, you get bad fragmentation yet no
checksums/etc.

If no, regular cow (especially with autodefrag) will be enough.  Sure, this
particular load won't be as performant (mysql really loves fsync, which is
an anathema to btrfs), but you get all the data safety improvements,
frequent cheap backups, and so on.

Thus: if the server's primary purpose is that database, you don't want
btrfs.  If the database is merely incidental, not microoptimizing it will
save a lot of your time.

In neither case nocow is a good idea.  Especially if raid (!= 0) is
involved.


Meow!
-- 
// If you believe in so-called "intellectual property", please immediately
// cease using counterfeit alphabets.  Instead, contact the nearest temple
// of Amon, whose priests will provide you with scribal services for all
// your writing needs, for Reasonable And Non-Discriminatory prices.

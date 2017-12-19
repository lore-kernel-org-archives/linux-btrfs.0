Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:41644 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759867AbdLSMbL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 07:31:11 -0500
Date: Tue, 19 Dec 2017 13:30:58 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Murphy <lists@colorremedies.com>
Cc: Anand Jain <anand.jain@oracle.com>,
        Peter Grandi <pg@btrfs.list.sabi.co.uk>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Unexpected raid1 behaviour
Message-ID: <20171219123058.hypaf3wyjzoqk3fx@angband.pl>
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <be7e5573-4247-89bd-00f0-7d84120ce582@oracle.com>
 <CAJCQCtSeLcpyWG1SKqqfgw2MFn7ugZu1Cby6BGd=cfSbEgUmRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtSeLcpyWG1SKqqfgw2MFn7ugZu1Cby6BGd=cfSbEgUmRA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 18, 2017 at 03:28:14PM -0700, Chris Murphy wrote:
> On Mon, Dec 18, 2017 at 1:49 AM, Anand Jain <anand.jain@oracle.com> wrote:
> >  Agreed. IMO degraded-raid1-single-chunk is an accidental feature
> >  caused by [1], which we should revert back, since..
> >    - balance (to raid1 chunk) may fail if FS is near full
> >    - recovery (to raid1 chunk) will take more writes as compared
> >      to recovery under degraded raid1 chunks
> 
> The advantage of writing single chunks when degraded, is in the case
> where a missing device returns (is readded, intact). Catching up that
> device with the first drive, is a manual but simple invocation of
> 'btrfs balance start -dconvert=raid1,soft -mconvert=raid1,soft'   The
> alternative is a full balance or full scrub. It's pretty tedious for
> big arrays.
> 
> mdadm uses bitmap=internal for any array larger than 100GB for this
> reason, avoiding full resync.
> 
> 'btrfs sub find' will list all *added* files since an arbitrarily
> specified generation; but not deletions.

This is fine as scrub cares about extents not files.  The newer generation
of metadata doesn't have a reference to the deleted extent anymore.

Selective scrub hasn't been implemented, but it should be pretty
straightforward -- unless nocow is involved.  Correct me if I'm wrong, but I
believe there's no way to tell which copy of a nocow extent is the good one.


Meow!
-- 
// If you believe in so-called "intellectual property", please immediately
// cease using counterfeit alphabets.  Instead, contact the nearest temple
// of Amon, whose priests will provide you with scribal services for all
// your writing needs, for Reasonable And Non-Discriminatory prices.

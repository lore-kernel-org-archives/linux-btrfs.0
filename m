Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:54830 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751863AbdLSM7W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 07:59:22 -0500
Received: from ty.sabi.co.uk ([95.172.230.208]:59252)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89_1)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1eRHUO-00037F-Kz
        for linux-btrfs@vger.kernel.org; Tue, 19 Dec 2017 12:59:20 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1eRHUE-0007aq-7k
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 12:59:10 +0000
Message-ID: <23097.3357.442045.199@tree.ty.sabi.co.uk>
Date: Tue, 19 Dec 2017 12:59:09 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Unexpected raid1 behaviour
In-Reply-To: <CAJCQCtSeLcpyWG1SKqqfgw2MFn7ugZu1Cby6BGd=cfSbEgUmRA@mail.gmail.com>
References: <5A357909.8010206@yandex.ru>
        <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
        <23094.37316.66397.431081@tree.ty.sabi.co.uk>
        <be7e5573-4247-89bd-00f0-7d84120ce582@oracle.com>
        <CAJCQCtSeLcpyWG1SKqqfgw2MFn7ugZu1Cby6BGd=cfSbEgUmRA@mail.gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... ]

> The advantage of writing single chunks when degraded, is in
> the case where a missing device returns (is readded,
> intact).  Catching up that device with the first drive, is a
> manual but simple invocation of 'btrfs balance start
> -dconvert=raid1,soft -mconvert=raid1,soft' The alternative is
> a full balance or full scrub. It's pretty tedious for big
> arrays.

That is merely an after-the-fact rationalization for a design
that is at the same time entirely logical and quite broken: that
the intended replication factor is the same as the current
number of members of the volume, so if a volume has (currently)
only one member, than only "single" chunks gets created.

A design that would work better for operations would be to have
"profiles" to be a concept entirely independent of number of
members, or perhaps more precisely to have the "desired" profile
of a chunk be distinct from the "actual" profile (dependent on
the actual number of members of a volume) of that chunk, so that
if a volume has only one member chunks could be created that
have "desired" profile 'raid1' but "actual" profile 'single', or
perhaps more sensibly 'raid1-with-missing-mirror', with checks
that "actual" profile be usable else the volume is not
mountable.

Note: ideally every chunk would have both a static desired
profile and a desired stripe width, and a computed actual
profile and a actual stripe width. Or perhaps the desired
profile and width would be properties of the volume (for each of
the three types of data).

For example in MD RAID it is perfectly legitimate to create a
RAID6 set with "desired" width of 6 and "actual" width of 4 (in
which case it can be activated as degraded) or a RAID5 set with
"desired" width of 5 and actual width of 3 (in which case it
cannot be activated at all until at least another member is
added).

The difference with MD RAID is that in MD RAID there is (except
in one case , during conversion) an exact match between
"desired" profile stripe width and number of members, while at
least in principle a Btrfs volume can have any number of chunks
of any profile of any desired stripe size (except that current
implementation is not so flexible in most profiles).

That would require scanning all chunks to determine whether a
volume is mountable at all or mountable only as degraded, while
MD RAID can just count the members. Apparently recent versions
of the Btrfs 'raid1' profile do just that.

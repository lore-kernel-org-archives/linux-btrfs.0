Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:56918 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751531AbdHPR0a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 13:26:30 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:41644)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1di25N-0005NQ-Db
        for linux-btrfs@vger.kernel.org; Wed, 16 Aug 2017 18:26:29 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1di25F-0006IY-AV
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Aug 2017 18:26:21 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22932.32828.946538.856677@tree.ty.sabi.co.uk>
Date: Wed, 16 Aug 2017 18:26:20 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
In-Reply-To: <4ab82797-a2fb-4c5e-2778-e711d192e0d0@gmail.com>
References: <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
        <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
        <1502496618.6092.6.camel@scientia.net>
        <20170812074248.GA3352@infradead.org>
        <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
        <1502713484.3608.1.camel@scientia.net>
        <b0e0e9e4-5b7f-ac84-b05c-8724762b16ea@gmail.com>
        <49ebcfb9-b0c8-0feb-3570-a5b19c3e3b33@cobb.uk.net>
        <53633949-b04b-ec5c-f300-c0b702d22374@gmail.com>
        <1502740488.5384.5.camel@scientia.net>
        <20170816131230.GA28619@clm-mbp.thefacebook.com>
        <1502890308.5446.5.camel@scientia.net>
        <152c3e70-72e2-0d26-e145-979f602257b7@gmail.com>
        <1502892678.5446.7.camel@scientia.net>
        <4ab82797-a2fb-4c5e-2778-e711d192e0d0@gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... ]

>>> Snapshots work fine with nodatacow, each block gets CoW'ed
>>> once when it's first written to, and then goes back to being
>>> NOCOW.
>>> The only caveat is that you probably want to defrag either
>>> once everything has been rewritten, or right after the
>>> snapshot.

>> I thought defrag would unshare the reflinks?
 
> Which is exactly why you might want to do it. It will get rid
> of the overhead of the single CoW operation, and it will make
> sure there is minimal fragmentation.
> IOW, when mixing NOCOW and snapshots, you either have to use
> extra space, or you deal with performance issues. Aside from
> that though, it works just fine and has no special issues as
> compared to snapshots without NOCOW.

The above illustrates my guess as to why RHEL 7.4 dropped Btrfs
support, which is:

  * RHEL is sold to managers who want to minimize the cost of
    upgrades and sysadm skills.
  * Every time a customer creates a ticket, RH profits fall.
  * RH had adopted 'ext3' because it was an in-place upgrade
    from 'ext2' and "just worked", 'ext4' because it was an
    in-place upgrade from 'ext3' and was supposed to "just
    work", and then was looking at Btrfs as an in-place upgrade
    from 'ext4', and presumably also a replacement for MD RAID,
    that would "just work".
  * 'ext4' (and XFS before that) already created a few years ago
    trouble because of the 'O_PONIES' controversy.
  * Not only Btrfs still has "challenges" as to multi-device
    functionality, and in-place upgrades from 'ext4' have
    "challenges" too, it has many "special cases" that need
    skill and discretion to handle, because it tries to cover so
    many different cases, and the first thing many a RH customer
    would do is to create a ticket to ask what to do, or how to
    fix a choice already made.

Try to imagine the impact on the RH ticketing system of a switch
from 'ext4' to Btrfs, with explanations like the above, about
NOCOW, defrag, snapshots, balance, reflinks, and the exact order
in which they have to be performed for best results.

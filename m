Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:56542 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751638AbdHPQoa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 12:44:30 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:41632)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1di1Qj-000456-4W
        for linux-btrfs@vger.kernel.org; Wed, 16 Aug 2017 17:44:29 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1di1Qf-0006Cr-6G
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Aug 2017 17:44:25 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22932.30312.797284.229182@tree.ty.sabi.co.uk>
Date: Wed, 16 Aug 2017 17:44:24 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
In-Reply-To: <20170816131230.GA28619@clm-mbp.thefacebook.com>
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
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> We use the crcs to catch storage gone wrong, [ ... ]

And that's an opportunistically feasible idea given that current
CPUs can do that in real-time.

> [ ... ] It's possible to protect against all three without COW,
> but all solutions have their own tradeoffs and this is the setup
> we chose. It's easy to trust and easy to debug and at scale that
> really helps.

Indeed all filesystem designs have pathological workloads, and
system administrators and applications developers who are "more
prepared" know which one is best for which workload, or try to
figure it out.

> Some databases also crc, and all drives have correction bits of
> of some kind. There's nothing wrong with crcs happening at lots
> of layers.

Well, there is: in theory checksumming should be end-to-end, that
is entirely application level, so applications that don't need it
don't pay the price, but having it done at other layers can help
the very many applications that don't do it and should do it, and
it is cheap, and can help when troubleshooting exactly there the
problem is. It is an opportunistic thing to do.

> [ ... ] My real goal is to make COW fast enough that we can
> leave it on for the database applications too.  Obviously I
> haven't quite finished that one yet ;) [ ... ]

And this worries me because it portends the usual "marketing" goal
of making Btrfs all things to all workloads, the "OpenStack of
filesystems", with little consideration for complexity,
maintainability, or even sometimes reality.

The reality is that all known storage media have hugely
anisotropic performance envelopes, both as to functionality, cost,
speed, reliability, and there is no way to have an automagic
filesystem that "just works" in all cases, despite the constant
demands for one by "less prepared" storage administrators and
application developers. The reality is also that if one such
filesystem could automagically adapt to cover optimally the
performance envelopes of every possible device and workload, it
would be so complex as to be unmaintainable in practice.

So Btrfs, in its base "Rodeh" functionality, with COW, checksums,
subvolumes, shapshots, *on a single device*, works pretty well and
reliably and it is already very useful, for most workloads. Some
people also like some of its exotic complexities like in-place
compression and defragmentation, but they come at a high cost.

For workloads that inflict lots of small random in-place updates
on storage, like tablespaces for DBMSes etc, perhaps simpler less
featureful storage abstraction layers are more appropriate, from
OCFS2 to simple DM/LVM2 LVs, and Btrfs NOCOW approximates them
well.

BTW as to the specifics of DBMSes and filesystems, there is a
classic paper making eminently reasonable, practical, suggestions
that have been ignored for only 35 years and some:

  %A M. R. Stonebraker
  %T Operating system support for database management
  %J CACM
  %V 24
  %D JUL 1981
  %P 412-418

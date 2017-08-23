Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:46568 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753883AbdHWMLy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 08:11:54 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:39898)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1dkUVl-00086f-9z
        for linux-btrfs@vger.kernel.org; Wed, 23 Aug 2017 13:11:53 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dkUVR-0005pi-Li
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 13:11:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22941.28917.315668.107348@tree.ty.sabi.co.uk>
Date: Wed, 23 Aug 2017 13:11:33 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: number of subvolumes
In-Reply-To: <20170823071821.GA28319@rus.uni-stuttgart.de>
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
        <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com>
        <20170822142451.GI14804@rus.uni-stuttgart.de>
        <20170822214531.44538589@natsu>
        <20170822165725.GL14804@rus.uni-stuttgart.de>
        <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
        <20170822180155.GM14804@rus.uni-stuttgart.de>
        <22940.31139.194399.982315@tree.ty.sabi.co.uk>
        <20170822204811.GO14804@rus.uni-stuttgart.de>
        <20170823071821.GA28319@rus.uni-stuttgart.de>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> This is a vanilla SLES12 installation: [ ... ] Why does SUSE
> ignore this "not too many subvolumes" warning?

As in many cases with Btrfs "it's complicated" because of the
interaction of advanced features among themselves and the chosen
implementation and properties of storage; anisotropy rules.

IIRC the main problem actually is not with "too many subvolumes",
but with too many "reflinks"/"backrefs"; subvolumes, in particular
snapshots, are just the main way to create them:

  https://www.spinics.net/lists/linux-btrfs/msg42808.html

A couple dozen subvolumes without reflinks as in the '/' scheme
used by SUSE are going to be almost always fine.

Then there is different a issue: I remember seeing a post by a SUSE
guy saying that the 10/10/10/10 (hourly/daily/monthly/yearly)
snapshots in the default settings for 'snapper' was a bad idea
because it would create way too many snapshots, but that he was
told to set those defaults that high. I can imagine a cowardly but
plausible reason why "management" would want those defaults.

Some semi-useful links:

* Home page for 'snapper'
  https://snapper.io/
* Announcement of 'snapper'
  https://lizards.opensuse.org/2011/04/01/introducing-snapper/
* Useful maintenance scripts
  https://github.com/kdave/btrfsmaintenance

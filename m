Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:41575 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751802AbcKGUyS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Nov 2016 15:54:18 -0500
Date: Mon, 7 Nov 2016 21:54:09 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Mark Fasheh <mark@fasheh.com>
Cc: dsterba@suse.cz, James Pharaoh <james@wellbehavedsoftware.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Announcing btrfs-dedupe
Message-ID: <20161107205409.GA20325@angband.pl>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <20161107140200.GM12522@suse.cz>
 <CAGe7X7n=xkveD4TS2cyfXx5-hydOCHTh=tjDK54h8HWpnK5NqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGe7X7n=xkveD4TS2cyfXx5-hydOCHTh=tjDK54h8HWpnK5NqQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 07, 2016 at 09:48:41AM -0800, Mark Fasheh wrote:
> also on XFS with the dedupe ioctl (I believe this should be out with
> Linux-4.9).

It's already there in 4.9-rc1, although you need a special version of
xfsprogs (possibly already released, I didn't check).  It's an experimental
feature that needs to be enabled with "-m reflink=1".

Despite that experimental status, I'd strongly recommend James to test his
tool on xfs as well, as it's the second major implementation of this API[1].


Mark has already included XFS in documentation of duperemove, all that looks
amiss is btrfs-extent-same having an obsolete name.  But then, I never did
any non-superficial tests on XFS, beyond "seems to work".


Meow!

[1]. For some reasons zfs-on-linux guys didn't implement this yet, despite
it being an obvious thing on ZFS.
-- 
A MAP07 (Dead Simple) raspberry tincture recipe: 0.5l 95% alcohol, 1kg
raspberries, 0.4kg sugar; put into a big jar for 1 month.  Filter out and
throw away the fruits (can dump them into a cake, etc), let the drink age
at least 3-6 months.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.201]:52940 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab3HEMC6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Aug 2013 08:02:58 -0400
Received: from mailout-us.gmx.com ([172.19.198.45]) by mrigmx.server.lan
 (mrigmxus002) with ESMTP (Nemesis) id 0MSJg7-1Ud0Mz1Fc3-00TXgt for
 <linux-btrfs@vger.kernel.org>; Mon, 05 Aug 2013 14:02:58 +0200
Cc: linux-btrfs@vger.kernel.org, "David Sterba" <dsterba@suse.cz>,
        sbehrens@giantdisaster.de
Content-Type: text/plain; charset="utf-8"
Date: Mon, 05 Aug 2013 08:02:58 -0400
From: "Mike Audia" <mikey_a@gmx.com>
Message-ID: <20130805120258.96400@gmx.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] btrfs: add mount option to set commit interval
To: "Hugo Mills" <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20130803115708.GA22967@carfax.org.uk>

>  Add the "official" kernel repo as a remote to the same git repo
> (with git remote add), fetch that repo, create a new branch to work
> in, based on the btrfs-next branch, then merge in the other branch (or
> vice-versa).
> 
>  Note that btrfs-next is usually based on the latest released kernel
> anyway, so that's likely to be largely superfluous.

Thank you for the reply.  I am afraid what you've outlined is beyond my abilities.  I guess the patch is built against something newer than 3.10.5 which was just released yesterday since I get the similar rejection when patching into it:

patching file fs/btrfs/ctree.h
Hunk #1 succeeded at 1338 (offset -12 lines).
Hunk #2 succeeded at 1929 (offset -40 lines).
patching file fs/btrfs/disk-io.c
Hunk #1 succeeded at 1713 (offset -24 lines).
Hunk #2 FAILED at 1749.
Hunk #3 succeeded at 2172 with fuzz 1 (offset -17 lines).
1 out of 3 hunks FAILED -- saving rejects to file fs/btrfs/disk-io.c.rej
patching file fs/btrfs/super.c
Hunk #1 succeeded at 319 (offset -2 lines).
Hunk #2 succeeded at 360 (offset -2 lines).
Hunk #3 succeeded at 626 (offset -2 lines).
Hunk #4 succeeded at 968 (offset 1 line).

Is is safe for me to manually fix that particular hunk?


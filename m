Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41581 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbaEEBrG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 21:47:06 -0400
Date: Sun, 4 May 2014 17:56:44 -0700
From: Marc MERLIN <marc@merlins.org>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Using mount -o bind vs mount -o subvol=vol
Message-ID: <20140505005644.GB10159@merlins.org>
References: <20140504004732.GE9061@merlins.org>
 <5365E74B.6020805@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5365E74B.6020805@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 04, 2014 at 09:07:55AM +0200, Brendan Hide wrote:
> On 2014/05/04 02:47 AM, Marc MERLIN wrote:
> >Is there any functional difference between
> >
> >mount -o subvol=usr /dev/sda1 /usr
> >and
> >mount /dev/sda1 /mnt/btrfs_pool
> >mount -o bind /mnt/btrfs_pool/usr /usr
> >
> >?
> >
> >Thanks,
> >Marc
> There are two "issues" with this.
> 1) There will be a *very* small performance penalty (negligible, really)

Oh, really, it's slower to mount the device directly? Not that I really
care, but that's unexpected.
 
> 2) Old snapshots and other supposedly-hidden subvolumes will be
> accessible under /mnt/btrfs_pool. This is a minor security concern
> (which of course may not concern you, depending on your use-case).
> There are a few similar minor security concerns - the
> recently-highlighted issue with old snapshots is the potential that
> old vulnerable binaries within a snapshot are still accessible
> and/or executable.

That's a fair point. I can of course make that mountpoint 0700, but it's
a valid concern in some cases (not for me though).

So thanks for confirming my understanding, it sounds like both are valid
and if you're already mounting the main pool like I am, that's the
easiest way.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

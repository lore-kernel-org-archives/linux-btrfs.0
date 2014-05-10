Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:56122 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510AbaEJLnL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 07:43:11 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 72533CC80E
	for <linux-btrfs@vger.kernel.org>; Sat, 10 May 2014 21:43:11 +1000 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: URGENT: my laptop's boot ssd btrfs crashed, what do you need off it?
Date: Sat, 10 May 2014 21:42:52 +1000
Message-ID: <82353937.K79yKjzhLK@quad>
In-Reply-To: <loom.20140510T112209-573@post.gmane.org>
References: <20140507233959.GB11401@merlins.org> <loom.20140510T112209-573@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Sat, 10 May 2014 09:26:22 AM Tom Kuther wrote:

> The same thing happened to me just right now. Also on my SSD, also at
> "fs/btrfs/inode.c:4927 btrfs_invalidate_inode", also on 3.14.

Was your kernel tainted in any way at that point?

Not saying it's to blame, but it'd be interesting to correlate with Marc's 
report.

cheers,
Chris
- -- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEVAwUBU24QvI1yjaOTJg85AQK09ggAlpnRyRvsI+Nah37vjUPohjdoPWl0pgux
271bhXeWnKxekvOrS9A3DFDKiQg8TkI8BIVcp+mIprEPnQRqm3VaH6fkzGeccskl
f3C18Y56MbJwyH6qw3nltVRoexrceeb9ojVZDcAEhRs2IHI+xPzaCW9PqLYP+qc+
VkSy6sVpJBahUlVJchy2f2nhNXnPV3Rj+DTBaDoy6mKS7L8kIP2Sb0e5a6HcK2i4
gS06yeZTk7vCDP19UpvByNknS2tWDn8t4HZSJFTdwMDjpfRRssUELGhh4uL+N6u+
QtEOgfuimlnXcETOvFc/aaq8Ls8f0nTTRwVWu5+hw+NmKOdkrwKUtQ==
=dM5D
-----END PGP SIGNATURE-----


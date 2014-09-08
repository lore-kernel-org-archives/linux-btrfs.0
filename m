Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60711 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbaIHKAH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Sep 2014 06:00:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XQvju-0001pO-FK
	for linux-btrfs@vger.kernel.org; Mon, 08 Sep 2014 12:00:02 +0200
Received: from pd953ec5f.dip0.t-ipconnect.de ([217.83.236.95])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Sep 2014 12:00:02 +0200
Received: from holger.hoffstaette by pd953ec5f.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Sep 2014 12:00:02 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Linux 3.14.18 : kernel BUG at fs/btrfs/file.c:890!
Date: Mon, 8 Sep 2014 09:59:46 +0000 (UTC)
Message-ID: <pan.2014.09.08.09.59.46@googlemail.com>
References: <1410107980.2832.41.camel@localhost>
	<pan.2014.09.07.17.48.53@googlemail.com>
	<1410169197.2383.3.camel@daevel.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 08 Sep 2014 11:39:57 +0200, Olivier Bonvalet wrote:

> Ok, so the cause is probably solved, this is a very good news, thanks.

I don't *know* that this is your specific problem, it just looks like it
might be judging by the description in the patch.

> And yes, I can easily use 3.17-rc3 kernel.

Good.

> So the problem is with current data : I don't know an easy way to
> export/restore subvolumes & snapshots thought network, and I don't have
> physical access to this rent servers.

That's tricky, especially the snapshots. I don't remember seeing how
large the partition in question is, but is there really no place where
you can store a simple tar.gz dump, nuke & recreate the partition and
restore the tarball? If so I'm afraid you are what's known as
"up shit creek without a paddle"..

> Any hope that btrfsck be updated to fix that ?

By default btrfsck doesn't do anything. What happens when you run it
without --repair, just to see what it finds?

-h


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:43834 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751266AbdIJOVs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 10:21:48 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:43118)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1dr37K-0005nZ-Bw
        for linux-btrfs@vger.kernel.org; Sun, 10 Sep 2017 15:21:46 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dr37F-0006Qy-EQ
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Sep 2017 15:21:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22965.19060.919910.241107@tree.ty.sabi.co.uk>
Date: Sun, 10 Sep 2017 15:21:40 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: generic name for volume and subvolume root?
In-Reply-To: <20170909083551.GC22060@rus.uni-stuttgart.de>
References: <20170909083551.GC22060@rus.uni-stuttgart.de>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> As I am writing some documentation abount creating snapshots:
> Is there a generic name for both volume and subvolume root?

Yes, it is from the UNIX side 'root directory' and from the
Btrfs side 'subvolume'. Like some other things Btrfs, its
terminology is often inconsistent, but "volume" *usually* means
"the set of devices [and contained root directories] with the
same Btrfs 'fsid'".

I think that the top-level subvolume should not be called the
"volume": while there is no reason why a UNIX-like filesystem
should be limited to a single block-device, one of the
fundamental properties of UNIX-like filesystems is that
hard-links are only possible (if at all possible) within a
filesystem, and that 'statfs' returns a different "device id"
per filesystem. Therefore a Btrfs volume is not properly a
filesystem, but potentially a filesystem forest, as it may
contain multiple filesystems each with its own root directory.

> Is there a simple name for directories I can snapshot?

You can only snapshot *root directories*, of which in Btrfs
there are two types: subvolumes (an unfortunate name perhaps) or
snapshots.

In UNIX-like OSes every filesystem has a "root directory" and
some filesystem types like Btrfs, NILFS2, and potentially JFS
can have more than one, and some can even mount more than one
simultaneously.

The root directory mounted as '/' is called the "system root
directory". When unmounted all filesystem root directories have
no names, just an inode number. Conceivably the root inode of a
UNIX-like filesystem could be an inode of any type, but I have
never seen a recent UNIX-like OS able to mount anything other
than a directory-type root inode (Plan 9 is not a UNIX-like OS
:->).

As someone else observed, the word "root" is overloaded in
UNIX-like OS discourse, like the word "filesystem", and that's
unfortunate but can always be resolved verbosely by using the
appropriate qualifier like "root directory", "system root
directory", "'root' user", "uid 0 capabilities", etc.

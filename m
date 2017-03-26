Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:33065 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751463AbdCZUY3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Mar 2017 16:24:29 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:58136)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1csEiB-0019JZ-6X
        for linux-btrfs@vger.kernel.org; Sun, 26 Mar 2017 21:24:27 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1csEi6-0007rl-68
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Mar 2017 21:24:22 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <22744.9077.823349.698871@tree.ty.sabi.co.uk>
Date: Sun, 26 Mar 2017 21:24:21 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: backing up a file server with many subvolumes
In-Reply-To: <58D72EC4.9020101@gmail.com>
References: <58D72EC4.9020101@gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> [ ... ] In each filesystem subdirectory are incremental
> snapshot subvolumes for that filesystem.  [ ... ] The scheme
> is something like this:

> <top>/backup/<machine>/<filesystem>/<many snapshot subvolumes>

BTW hopefully this does not amounts to too many subvolumes in
the '.../backup/' volume, because that can create complications,
where "too many" IIRC is more than a few dozen (even if a low
number of hundreds is still doable).

> I'd like to try to back up (duplicate) the file server
> filesystem containing these snapshot subvolumes for each
> remote machine. The problem is that I don't think I can use
> send/receive to do this. "Btrfs send" requires "read-only"
> snapshots, and snapshots are not recursive as yet.

Why is that a problem? What is a recursive snapshot?

> I think there are too many subvolumes which change too often
> to make doing this without recursion practical.

It is not clear to me how the «incremental snapshot subvolumes
for that filesystem» are made, whether with RSYNC or 'send' and
'receive' itself. It is also not clear to me why those snapshots
«change too often», why would they change at all? Once a backup
is made in whichever way to an «incremental snapshot», why would
that «incremental snapshot» ever change but for being deleted?

There are some tools that rely on the specific abilities of
'send' with options '-p' and '-c' to save a lot of network
bandwidth and target storage space, perhaps you might be
interested in searching for them.

Anyhow I'll repeat here part of an answer to a similar message:
issues like yours usually are based on incomplete understanding
of 'send' and 'receive', and on IRC user "darkling" explained it
fairly well:

> When you use -c, you're telling the FS that it can expect to
> find a sent copy of that subvol on the receiving side, and
> that anything shared with it can be sent by reference. OK, so
> with -c on its own, you're telling the FS that "all the data
> in this subvol already exists on the remote".

> So, when you send your subvol, *all* of the subvol's metadata
> is sent, and where that metadata refers to an extent that's
> shared with the -c subvol, the extent data isn't sent, because
> it's known to be on the other end already, and can be shared
> directly from there.

> OK. So, with -p, there's a "base" subvol. The send subvol and
> the -p reference subvol are both snapshots of that base (at
> different times). The -p reference subvol, as with -c, is
> assumed to be on the remote FS. However, because it's known to
> be an earlier version of the same data, you can be more
> efficient in the sending by saying "start from the earlier
> version, and modify it in this way to get the new version"

> So, with -p, not all of the metadata is sent, because you know
> you've already got most of it on the remote in the form of the
> earlier version.

> So -p is "take this thing and apply these differences to it"
> and -c is "build this thing from scratch, but you can share
> some of the data with these sources"

Also here some additional details:

  http://logs.tvrrug.org.uk/logs/%23btrfs/2016-06-29.html#2016-06-29T22:39:59

The requirement for read-only is because in that way it is
pretty sure that the same stuff is on both origin and target
volume.

It may help to compare with RSYNC: it has to scan both the full
origin and target trees, because it cannot be told that there is
a parent tree that is the same on origin and target; but with
option '--link-dest' it can do something similar to 'send -c'.

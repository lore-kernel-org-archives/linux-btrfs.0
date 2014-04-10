Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34081 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161075AbaDJUAh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 16:00:37 -0400
Received: by mail-wg0-f41.google.com with SMTP id n12so4402635wgh.0
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Apr 2014 13:00:36 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 10 Apr 2014 13:00:35 -0700
Message-ID: <CAH3EO-o-S7WveO7V++zB1+Zd3kfrxk4YyMZ6P+GrcNWfALgrfA@mail.gmail.com>
Subject: Filesystem unable to recover from ENOSPC
From: Chip Turner <cturner@pattern.net>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a filesystem that I can't seem to resolve ENOSPC issues.  No
write operation can succeed; I've tried the wiki's suggestions
(balancing, which fails because of ENOSPC, mounting with nodatacow,
clear_cache, nospace_cache, enospc_debug, truncating files, deleting
files, briefly microwaving the drive, etc).

btrfs show:
Label: none  uuid: 04283a32-b388-480b-9949-686675fad7df
Total devices 1 FS bytes used 135.58GiB
devid    1 size 238.22GiB used 238.22GiB path /dev/sdb2

btrfs fi df:
Data, single: total=234.21GiB, used=131.82GiB
System, single: total=4.00MiB, used=48.00KiB
Metadata, single: total=4.01GiB, used=3.76GiB

So, the filesystem is pretty much unusable, and I can find no way to
resuscitate it.  I ended up in this state by creating a snapshot of
the root of the fs into a read/write subvolume, which I wanted to
become my new root, then began deleting entries in the filesystem
itself outside of the new snapshot.  So nothing particularly weird or
crazy.  The only oddness is the file count -- I have a *lot* of
hardlinked files (this is an rsnapshot volume, so it has a large
number of files and many of them are hard linked).

It seems like the normal solution is btrfs balance, but that fails.
defragment also fails.  Kernel is 3.13.

Is there anything else I can or should do, or just wipe it and
recreate with perhaps better initial defaults?  If this kind of thing
is unavoidable, how might I have anticipated it and prevented it?
Fortunately this was a migration effort and so my original data is
safe inside of ext4 (ew).

-- 
Chip Turner - cturner@pattern.net

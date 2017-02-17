Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:41511 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932075AbdBQIo1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 03:44:27 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cee9F-0002Jt-7J
        for linux-btrfs@vger.kernel.org; Fri, 17 Feb 2017 09:44:13 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Way to force allocation of more metadata?
Date: Fri, 17 Feb 2017 08:44:06 +0000 (UTC)
Message-ID: <pan$8bf35$b9a68b69$a0d9b9b6$4fc860bd@cox.net>
References: <CAJtFHUTK-0m08usaak+_AVLntZnFZUswi5tq=vkiSVpacKW47A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

E V posted on Thu, 16 Feb 2017 15:13:40 -0500 as excerpted:

> I can delete a multi GB file and get several GB of unallocated space,
> however if I try and copy big files to it again the same exact thing
> happens. However, if I play with balance and deleting files and such and
> manage to get it to allocate another metadata chunk while there is
> unallocated space then the filesystem will happily fill up all of the
> data chunks. Failing an automatic allocation out of global reserve, or
> saving metadata as soon as unallocated space is available it would be
> nice if I could just delete a file and then tell btrfs to allocate more
> metadata immediately. Makes sense? No idea how easy this would be to do,
> but seems like it should be a simple thing btrfs file could do.

You should be able to trigger metadata allocation by writing enough tiny 
files, say 1 KiB each.  Small files (typically upto slightly under 2 KiB) 
are inlined into the metadata, thus using it up.  Writing enough of them 
in for instance a shellscript loop to trigger a new metadata chunk 
allocation shouldn't be too difficult, but keep in mind when doing the 
math that global reserve is allocated from metadata as well, tho it's 
single even when metadata is dup or (as here) raid1.

Also, if you're looking at the space output as you write them, keep in 
mind the btrfs 30-second by default commit timing, and call btrfs fi sync 
(or just sync but that's system-wide) on the filesystem every N files or 
so, before checking the usage, so it's accurate without waiting 30 
seconds for the commit-clock to timeout.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


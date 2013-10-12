Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:15334 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753125Ab3JLVUT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Oct 2013 17:20:19 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Linux Arch: kernel BUG at fs/btrfs/inode.c:873!
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAOMFOmWOwdkwpuiEQbWYRoUDXEKGy_JqM0BtN2AhSF7JHDq69Q@mail.gmail.com>
Date: Sat, 12 Oct 2013 15:20:17 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <ACFF5C41-EB0A-41F0-BE84-570989897B8E@colorremedies.com>
References: <CAOMFOmWzXL5G22Z7srkvXe+p+F9U7atOoiV5jRHc9i0k4kUfnA@mail.gmail.com> <CAOMFOmX95ebV=myVO1yDf5yPs7DfmvHDKDFwNNfT0CajDQ=W4Q@mail.gmail.com> <20131008071232.GA1402@localhost.localdomain> <CAOMFOmWOwdkwpuiEQbWYRoUDXEKGy_JqM0BtN2AhSF7JHDq69Q@mail.gmail.com>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 11, 2013, at 8:22 PM, Anatol Pomozov <anatol.pomozov@gmail.com> wrote:

> Hi,
> 
> Kernel 3.12-rc built from HEAD has the same issue as 3.10 and 3.11
> 
> Ok, I was able to "fix" my problem by booting from an old kernel
> (3.8.7) and it allowed me to mount the fs.

Interesting.

> Then I removed
> /var/log/journal directory. After that I was able to boot with 3.11.
> So I believe 3.9/3.10 has a regression in how it handles COW files. As
> I described above, some time ago I defraged journald files and set +C
> attribute to /var/log/journal (both to the folders and existing
> files).

In any case you'd have saved yourself some trouble by checking the archives first. The journald issue was reported Sep 23 in this thread:
http://comments.gmane.org/gmane.comp.file-systems.btrfs/28678

And a fix has been sent to stable, although I'm not sure the exact 3.10.x, 3.11.x versions it will end up in.

> 
> So 3.11 boots fine and the only boot warning I see is
> 
> Oct 11 19:06:55 brest kernel: BTRFS error (device sdd3): block group
> 1141416919040 has wrong amount of free space
> Oct 11 19:06:55 brest kernel: BTRFS error (device sdd3): failed to
> load free space cache for block group 1141416919040
> 
> 
> I tried 'btrfsck -repair' but it crashes so I cannot even check or
> repair my btrfs mount.

I'm uncertain this problem is related to the journald issue. I'm also uncertain of the fix. But if you don't get a reply from a developer in the time frame you prefer, I suggest you use btrfs-image -c9 -t4 referred to here:
https://btrfs.wiki.kernel.org/index.php/Btrfs-image

this will write the file system state minus data, in case a developer wants to see it at some point. In the meantime you can then blow away the file system and restore the data to get on with using it.


Chris Murphy
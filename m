Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:51563 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaHNSWe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 14:22:34 -0400
Received: by mail-oi0-f44.google.com with SMTP id x69so1006092oia.31
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Aug 2014 11:22:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53ECD046.709@gmail.com>
References: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com>
	<20140812011401.568c16e6@natsu>
	<AC90CAC7-A8F5-4C74-8295-4360A6A8FE45@colorremedies.com>
	<CADw2B2NnWFY=rOvArTDtnw2jkRe-HqNCcqeB0r80et60euEy3g@mail.gmail.com>
	<9EB33BE3-FAC0-4AE8-BB95-ABE68C578D47@colorremedies.com>
	<CADw2B2MGyDAvAxrZOML0kX_shdFD6QSyMV9XWxKfJAoZpLXsSQ@mail.gmail.com>
	<53ECD046.709@gmail.com>
Date: Thu, 14 Aug 2014 11:15:39 -0700
Message-ID: <CADw2B2NXZiLhEQocU+0PkWGiBsmESmYj=z47uY7G3CEsoEw8QQ@mail.gmail.com>
Subject: Re: Large files, nodatacow and fragmentation
From: "G. Richard Bellamy" <rbellamy@pteradigm.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 14, 2014 at 8:05 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> The fact that it is Windows using NTFS is probably part of the problem.
>  Here's some things you can do to decrease it's background disk
> utilization (these also improve performance on real hardware):
> 1. Disable system restore points.  These aren't really necessary if you
> are running in a VM and can take snapshots from the host OS.

Great point - doing that.

> 2. Disable the indexing service.  This does a lot of background disk IO,
> and most people don't need the high speed search functionality.

Being a developer, while I usually don't need this functionality, when
I /do/ need it, I need it /right now/.

> 3. Turn off Windows Features that you don't need.  This won't help disk
> utilization much, but can greatly improve overall system performance.

Normal for me, so it's already done. Well, except for #1 above. ;)

> 4. Disable the paging file.  Windows does a lot of unnecessary
> background paging, which can cause lots of unneeded disk IO.  Be careful
> doing this however, as it may cause problems for memory hungry applications.

The VM is getting 16G, so I see no reason to keep a large paging file,
so good call her as well. However, I have had some disk-related BSODs
which produced some MEMORY.DMP files I was planning to investigate if
all external troubleshooting paths were exhausted, I wouldn't have
been able to capture those if I had a minimal page file. Also, I would
need to once again increase the page file if I wanted to create a
NMI-based crash dump.

> 5. See if you can disable boot time services you don't need.  Bluetooth,
> SmartCard, and Adaptive Screen Brightness are all things you probably
> don't need in a VM environment.

Done as a matter of course.

>
> Of these, 1, 2, and 4 will probably help the most.  The other thing is
> that NTFS is a journaling file system, and putting a journaled file
> system image on a COW backing store will always cause some degree of
> thrashing, because the same few hundred MB of the disk get rewritten
> over and over again, and the only way to work around that on BTRFS is to
> make the file NOCOW, AND preallocate the entire file in one operation
> (use the fallocate command from util-linux to do this).

I've been working through this for long enough, I've done both QEMU
preallocate and fallocate. The current image is large enough, that I
just set the nocow attr on the target directory and copied the
preallocated qcow2 image from a usb drive... thus it wasn't
fallocate'd. I'm again hitting my ignorance threshold, so am unclear
whether fallocate will behave the same as a copy from usb/ext4 to my
btrfs subvolume.

-rb

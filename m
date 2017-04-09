Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:45778 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751814AbdDIInZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 9 Apr 2017 04:43:25 -0400
Date: Sun, 9 Apr 2017 13:43:15 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Paul Jones <paul@pauljones.id.au>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About free space fragmentation, metadata write amplification
 and (no)ssd
Message-ID: <20170409134315.30246cea@natsu>
In-Reply-To: <SY3PR01MB0971BB9CC9DE8501D2132CD19E0E0@SY3PR01MB0971.ausprd01.prod.outlook.com>
References: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
 <SY3PR01MB0971BB9CC9DE8501D2132CD19E0E0@SY3PR01MB0971.ausprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 9 Apr 2017 06:38:54 +0000
Paul Jones <paul@pauljones.id.au> wrote:

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Hans van Kranenburg
> Sent: Sunday, 9 April 2017 6:19 AM
> To: linux-btrfs <linux-btrfs@vger.kernel.org>
> Subject: About free space fragmentation, metadata write amplification and (no)ssd
> 
> > So... today a real life story / btrfs use case example from the trenches at work...
> 
> Snip!!
> 
> Great read. I do the same thing for backups on a much smaller scale and it works brilliantly.  Two 4T drives in btrfs raid1.
> I will mention that I recently setup caching using LLVM (1 x 300G ssd for each 4T drive), and it's extraordinary how much of a difference it makes. Especially when running deduplication. If it's feasible perhaps you could try it with a nvme drive.

You mean LVM, not LLVM :)

I was actually going to suggest that as well, in my case I use a 32GB SSD
cache for my entire 14TB filesystem with 15 GB metadata (*2 in DUP). In fact
you should check the metadata size on yours, most likely you can get by with
an order of magnitude smaller cache for exactly the same benefit (and have the
rest of 2x300GB for other interesting uses).

And yeah it's amazing, especially when deleting old snapshots or doing
backups. In my case I backup the entire root FS from about 30 hosts, and keep
that in periodic snapshots for a month. Previously I would also stagger rsync
runs so that no more than 4 or 5 hosts get backed up at the same time (and
still there would be tons of trashing in seeks and iowait), now it's no
problem whatsoever.

The only issue that I have with this setup is you need to "cleanly close" the
cached LVM device on shutdown/reboot, and apparently there is no init script
in Debian that would do that (experimenting with adding some hacks, but no
success yet). So on every boot the entire cache is marked dirty and data is
being copied from cache to the actual storage, which takes some time, since
this appears to be done in a random IO pattern.

-- 
With respect,
Roman

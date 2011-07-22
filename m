From: Jan Schubert <Jan.Schubert@GMX.li>
Subject: Re: Broken btrfs?
Date: Fri, 22 Jul 2011 15:18:40 +0200
Message-ID: <4E2978B0.9050501@GMX.li>
References: <20110716214404.50480@gmx.net> <loom.20110717T160020-81@post.gmane.org> <4E23EED3.8000301@jan-o-sch.net> <4E28965F.1010508@GMX.li> <4E292598.2090308@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E292598.2090308@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/22/2011 09:24 AM, Jan Schmidt wrote:
> Scrub should be printing inode numbers to your system log while
> detecting those errors. If you want to know the exact files corrupted,
> you can grab my patch set with subject "Btrfs scrub: print path to
> corrupted files and trigger nodatasum fixup" from the list and give it
> a try.

Cool Jan, this is exactly what I asked for in my original post.

Your patch set is against kernel sources (not btrfs-progs), right? I
took the opportunity to upgrade to official 3.0 where your patch applied
and compiled without any issues. I also did recompile
btrfs-progs-unstable and run a scrub.

This scrub completed without any errors:
# btrfs scrub status .
scrub status for 03201fc0-7695-4468-9a10-f61ad79f23ca
        scrub started at Fri Jul 22 14:24:21 2011, running for 706 seconds
        total bytes scrubbed: 158.01GB with 0 errors

Is'nt this strange? This message is generated after rebooting the box
(due to a crash, see below), I remember to have seen some more
information before the crash but also 0 errors.

While doing the scrub I still did see csum errors in my dmesg but no
files associated:

Jul 22 14:17:50 toral kernel: btrfs no csum found for inode 199934 start
729088
Jul 22 14:17:50 toral kernel: btrfs csum failed ino 199934 off 729088
csum 3390946210 private 0
Jul 22 14:17:51 toral kernel: btrfs no csum found for inode 199934 start
24096768
Jul 22 14:17:51 toral kernel: btrfs csum failed ino 199934 off 24096768
csum 439962552 private 0
Jul 22 14:17:51 toral kernel: btrfs no csum found for inode 199934 start
24801280
Jul 22 14:17:51 toral kernel: btrfs no csum found for inode 199934 start
24805376
Jul 22 14:17:51 toral kernel: btrfs csum failed ino 199934 off 24801280
csum 158010657 private 0
Jul 22 14:17:51 toral kernel: btrfs csum failed ino 199934 off 24805376
csum 127231121 private 0

And sorry to say, it also crashed my box throwing a kernel expception
and a reference to somtehing like scrub_print_warning_inode (or similar)
which I could not find after rebooting my box. Seems my kernel.log and
all others logs are empty for the last 30min, Sry.

What is the most current btrfs-progs git branch to use for further
investigation?

Thx,
Jan

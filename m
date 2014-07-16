Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49089 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974AbaGPPzp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 11:55:45 -0400
Date: Wed, 16 Jul 2014 08:55:32 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        =?iso-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>
Cc: "Andrew E. Mileski" <andrewm@isoar.ca>, linux-btrfs@vger.kernel.org
Message-ID: <20140716155532.GA21186@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CALJXSJr=PayTcA9z0dsuBu0KRoOKMNRRJfqE4mWAgP8cxopdfg@mail.gmail.com>
 <53C3313B.1080500@cn.fujitsu.com>
Subject: Re: btrfs is  related to OOM death problems on my 8GB server with
 both 3.15.1 and 3.14?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 14, 2014 at 09:24:11AM +0800, Qu Wenruo wrote:
> >But generally, is there a tool to locate which kernel function allocated
> >all that RAM that seems to get allocated and forgotten?
> This can be done by kernel memleak detection.
> Location:
> -> Kernel hacking
>     -> Memory Debugging
>         -> Kernel memory leak detector
> 
> Then you can check /sys/kernel/debug/memleak to see which function
> call caused the problem.

I wanted to report back on this.
Unfortunately my laptop with 3.15.5 does not stay up more than 30mn,
sometimes fewer when kmemleak is on. When I turn it off from the boot
command line, the laptop seems to behave ok.

On Tue, Jul 15, 2014 at 08:45:47PM -0400, Jérôme Poulin wrote:
> Hi,
> 
> For this same problem I once got into single user after 2 weeks of
> utilisation and killed all, umounted all FS except root which is ext4,
> rmmod'ed all modules and see by yourself:
> http://i39.tinypic.com/2rrrjtl.jpg
> 
> For those who want it textually:
> 15 days uptime
> 10 user mode processes (systemd, top and bash)
> 2 GB memory usage, 4 GB total memory, 17 MB cache, 32 KB buffers.

Very interesting, thanks for confirming.
So even by removing the btrfs module, the memory was not reclaimed,
correct?

For what it's worth, my server seems ok now that I turned off quotas on
it.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

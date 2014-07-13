Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47525 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaGMPhn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Jul 2014 11:37:43 -0400
Date: Sun, 13 Jul 2014 08:37:34 -0700
From: Marc MERLIN <marc@merlins.org>
To: "Andrew E. Mileski" <andrewm@isoar.ca>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140713153734.GO10641@merlins.org>
References: <20140704011938.GO11539@merlins.org>
 <53B801DD.5040704@isoar.ca>
 <20140705144318.GT26932@merlins.org>
 <20140706145815.GD15009@merlins.org>
 <20140713142918.GH10641@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140713142918.GH10641@merlins.org>
Subject: Re: btrfs is  related to OOM death problems on my 8GB server with
 both 3.15.1 and 3.14?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 13, 2014 at 07:29:18AM -0700, Marc MERLIN wrote:
> Is /proc/slabinfo supposed to show anything useful?
> 
> This is the filesystem in question:
> gargamel:~# btrfs fi df /mnt/btrfs_pool2/
> Data, single: total=3.34TiB, used=3.32TiB
> System, DUP: total=8.00MiB, used=400.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=77.50GiB, used=59.87GiB
> Metadata, single: total=8.00MiB, used=0.00

Mmmh, now that I think of it, I do have quota enabled on that
filesystem.
Due to the many many files, this may be what's causing the problem.
I thought quotas were supposed to work with 3.15, but maybe there is
still a leak?

I just turned quotas off and I'm going to let my server run for a while to
see if the leak stops.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

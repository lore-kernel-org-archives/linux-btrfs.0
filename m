Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55357 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaBXGRP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 01:17:15 -0500
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1WHoqo-00074L-Mv
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Feb 2014 22:17:14 -0800
Date: Sun, 23 Feb 2014 22:17:14 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: 3.13.5 kernel hangs some processes with btrfs
Message-ID: <20140224061714.GC15937@merlins.org>
References: <20140224061426.GB15937@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140224061426.GB15937@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 23, 2014 at 10:14:26PM -0800, Marc MERLIN wrote:
> Does someone know how I can debug further why this is hanging?
> 
> It seems that accessing a certain directory on one of my btrfs filesystems
> causes this.
> 
> The rest of my system seems ok, as long as I'm not touching this filesystem.
> 
> Is this a bug, or a performance problem?

Mmmh, this bug might be part of the problem:
gargamel:/mnt# btrfs scrub start btrfs_pool2
ERROR: scrub is already running.
To cancel use 'btrfs scrub cancel btrfs_pool2'.
To see the status use 'btrfs scrub status [-d] btrfs_pool2'.
gargamel:/mnt# btrfs scrub cancel btrfs_pool2
ERROR: scrub cancel failed on btrfs_pool2: not running
gargamel:/mnt# btrfs scrub status btrfs_pool2
scrub status for cb9df6d3-a528-4afc-9a45-4fed5ec358d6
        scrub started at Sun Feb 23 18:29:39 2014, running for 5 seconds
        total bytes scrubbed: 0.00 with 0 errors
gargamel:/mnt# btrfs scrub cancel btrfs_pool2
ERROR: scrub cancel failed on btrfs_pool2: not running
gargamel:/mnt# btrfs scrub status btrfs_pool2
scrub status for cb9df6d3-a528-4afc-9a45-4fed5ec358d6
        scrub started at Sun Feb 23 18:29:39 2014, running for 5 seconds
        total bytes scrubbed: 0.00 with 0 errors
gargamel:/mnt# 

Note that it says running for 5 seconds, but it started 4H ago.

Any idea what's going on here?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

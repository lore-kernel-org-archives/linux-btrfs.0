Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52185 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab2KUQuQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Nov 2012 11:50:16 -0500
Date: Wed, 21 Nov 2012 08:50:14 -0800
From: Marc MERLIN <marc@merlins.org>
To: "frantz.hacquard" <frantz.hacquard@ensi-bourges.fr>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: unable to mount a btrfs partition
Message-ID: <20121121165014.GB32385@merlins.org>
References: <fa93207c7d636e263d8c2d6ebc2a3bed@ensi-bourges.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fa93207c7d636e263d8c2d6ebc2a3bed@ensi-bourges.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 21, 2012 at 04:17:57PM +0100, frantz.hacquard wrote:
> Hello,
> 
> i don't know if it's the right place to post my problem.
> 
> yesterday my btrfs partition (/dev/sda4) worked very well but now i 
> can't mount my btrfs partition anymore.
> it says : wrong fs type, bad option, bad superblock on /dev/sda4, 
> missing codepage ...
> 
> i know btrfs is still in developement, but i would try to recover a 
> file on this partition.
> i tried many options of mount (-t btrfs -o recovery -o degraded...) but 
> it's always the same issue.

kernel version? 
If you haven't tried 3.6.x, try that yet.

I'm not saying it'll fix your problem, but half the bugs I filed were
already fixed in the latest kernel.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

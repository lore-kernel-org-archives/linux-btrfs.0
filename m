Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:45160 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaFPBrk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jun 2014 21:47:40 -0400
Date: Sun, 15 Jun 2014 18:47:39 -0700
From: Marc MERLIN <marc@merlins.org>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Transaction commit: none (default)
Message-ID: <20140616014739.GB19071@merlins.org>
References: <20140614160554.GP6584@merlins.org> <539E49DB.80305@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <539E49DB.80305@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 16, 2014 at 09:35:23AM +0800, Wang Shilong wrote:
> On 06/15/2014 12:05 AM, Marc MERLIN wrote:
> >Taking snapshots is now output this in addition of the snapshot
> >operation.
> >
> >Transaction commit: none (default)
> >
> >1) Is that expected/normal? It looks kind of spamming/useless to me?
> >2) If it's useful, what's the use I'm not getting?
> Addressed a issue that subvolumes reappear after deletetion
> if poweroff happen.
> 
> http://www.spinics.net/lists/linux-btrfs/msg29547.html

I see, thank you for the pointer.
In the case of my script, it's console spam that I wish I could make go
away, but grep -v will do that for me :)

If it annoys other people, maybe having a -q (quiet) that removes this
message would be useful?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

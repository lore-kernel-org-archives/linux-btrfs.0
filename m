Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2.belwue.de ([129.143.2.15]:46281 "EHLO smtp2.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751015AbcK1AjZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 Nov 2016 19:39:25 -0500
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp2.belwue.de with SMTP id uAS0cTA6015516
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2016 01:38:30 +0100 (MET)
        env-from (framstag@rus.uni-stuttgart.de)
Date: Mon, 28 Nov 2016 01:38:29 +0100
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: mount option nodatacow for VMs on SSD?
Message-ID: <20161128003829.GD15348@rus.uni-stuttgart.de>
References: <20161125082840.GA32711@rus.uni-stuttgart.de>
 <20161126112710.6aca8bac@jupiter.sol.kaishome.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161126112710.6aca8bac@jupiter.sol.kaishome.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat 2016-11-26 (11:27), Kai Krakow wrote:

> > I have vmware and virtualbox VMs on btrfs SSD.

> As a side note: I don't think you can use "nodatacow" just for one
> subvolume while the other subvolumes of the same btrfs are mounted
> different. The wiki is just wrong here.
> 
> The list of possible mount options in the wiki explicitly lists
> "nodatacow" as not working per subvolume - just globally for the whole
> fs.

Thanks for pointing this out!
I have misunderstood this, first.

Ok, then next question :-)

What is better (for a single user workstation): using mount option
"autodefrag" or call "btrfs filesystem defragment -r" (-t ?) via nightly
cronjob?

So far, I use neither.


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20161126112710.6aca8bac@jupiter.sol.kaishome.de>

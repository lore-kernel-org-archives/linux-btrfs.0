Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:34014 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941227AbcIZUle (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 16:41:34 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.84_2)
        (envelope-from <kilobyte@angband.pl>)
        id 1bociQ-0005sH-14
        for linux-btrfs@vger.kernel.org; Mon, 26 Sep 2016 22:41:30 +0200
Date: Mon, 26 Sep 2016 22:41:29 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: Does data checksumming remain for files with No_COW file
 attribute?
Message-ID: <20160926204129.GA19378@angband.pl>
References: <767591474719974@web21o.yandex.ru>
 <20160924123749.GR7138@carfax.org.uk>
 <1498471474759532@web22g.yandex.ru>
 <20160924235014.GA2247@angband.pl>
 <pan$9d4de$8d8969eb$2fd5352c$14a0ea2c@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$9d4de$8d8969eb$2fd5352c$14a0ea2c@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 25, 2016 at 05:44:30AM +0000, Duncan wrote:
> Adam Borowski posted on Sun, 25 Sep 2016 01:50:14 +0200 as excerpted:
> > Actually, it disables pretty much all btrfs features except for... CoW.
> > 
> > You lose:
> > * checksums
> > * compression
> > * safety against power loss (torn writes, etc)
> > * transactions (not that anyone uses them...)
> > * etc
> 
> > But, CoW is still there.
> 
> That's because snapshots depend on COW.  If you don't snapshot the file 
> (or otherwise create additional reflinks to it, using cp --reflink=always, 
> for instance), it'll be NOCOW.  But because snapshots (and other forms of 
> multiple reflink) depend on COW, taking a snapshot (or otherwise multi-
> reflinking) and then writing to one copy forces what has been referred to 
> on this list as COW1, a single COW to break the multi-reflink.
> 
> However, COW1 doesn't change the NOCOW attribute, and further writes to 
> the same block of the NOCOW file will overwrite the now-current block, 
> instead of COWING it... until the next snapshot (or another multi-reflink 
> operation) locks it too in place, of course, after which another COW1 
> will be required.

There is no CoW unless you have more than one ref to the extent, as there is
no copying involved (other than when you write less than a whole block[1],
but that's the case for any filesystem).  Depending on FS_NOCOW_FL, you
either overwrite in place or write elsewhere then switch refs, but at no
point there is more than one live version.  You could call the latter "move
on write", perhaps.  On the other hand, with >1 reference, there's always
CoW.

[1]. The exact definition of "block" here varies.
-- 
An imaginary friend squared is a real enemy.

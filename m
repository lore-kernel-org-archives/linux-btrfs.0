Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:58318 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbcIXXuW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Sep 2016 19:50:22 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.84_2)
        (envelope-from <kilobyte@angband.pl>)
        id 1bnwhy-0000uN-Lf
        for linux-btrfs@vger.kernel.org; Sun, 25 Sep 2016 01:50:14 +0200
Date: Sun, 25 Sep 2016 01:50:14 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: Does data checksumming remain for files with No_COW file
 attribute?
Message-ID: <20160924235014.GA2247@angband.pl>
References: <767591474719974@web21o.yandex.ru>
 <20160924123749.GR7138@carfax.org.uk>
 <1498471474759532@web22g.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1498471474759532@web22g.yandex.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 25, 2016 at 02:25:32AM +0300, Alexander Tomokhov wrote:
> Ok, so data checksumming does not remain for newly created empty files
> with No_COW attribute.  I think it's an important trait of Btrfs behavior
> and should be added to wiki.  So that users are informed that disabling
> CoW on a per-file basis also loses checksum correctness of such file.

Actually, it disables pretty much all btrfs features except for... CoW.

You lose:
* checksums
* compression
* safety against power loss (torn writes, etc)
* transactions (not that anyone uses them...)
* etc
But, CoW is still there.  Try it: make a subvolume, create a FS_NO_COW file
(preferably one big enough), snapshot the subvolume, filefrag -v both
copies.  Write to one of them, changing only a part of file.  Wait for
writeout, filefrag -v them again.

-- 
An imaginary friend squared is a real enemy.

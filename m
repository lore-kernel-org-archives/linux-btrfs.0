Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:38963 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935367AbdIZUMp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 16:12:45 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1dwwDj-0005Bj-L9
        for linux-btrfs@vger.kernel.org; Tue, 26 Sep 2017 22:12:43 +0200
Date: Tue, 26 Sep 2017 22:12:43 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: Give up on bcache?
Message-ID: <20170926201243.x75zx7v6uecrme4u@angband.pl>
References: <oqe0fo$keo$1@blaine.gmane.org>
 <20170926233319.6324764d@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170926233319.6324764d@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 26, 2017 at 11:33:19PM +0500, Roman Mamedov wrote:
> On Tue, 26 Sep 2017 16:50:00 +0000 (UTC)
> Ferry Toth <ftoth@telfort.nl> wrote:
> 
> > https://www.phoronix.com/scan.php?page=article&item=linux414-bcache-
> > raid&num=2
> > 
> > I think it might be idle hopes to think bcache can be used as a ssd cache 
> > for btrfs to significantly improve performance..
> 
> My personal real-world experience shows that SSD caching -- with lvmcache --
> does indeed significantly improve performance of a large Btrfs filesystem with
> slowish base storage.
> 
> And that article, sadly, only demonstrates once again the general mediocre
> quality of Phoronix content: it is an astonishing oversight to not check out
> lvmcache in the same setup, to at least try to draw some useful conclusion, is
> it Bcache that is strangely deficient, or SSD caching as a general concept
> does not work well in the hardware setup utilized.

Also, it looks as if Phoronix' tests don't stress metadata at all.  Btrfs is
all about metadata, speeding it up greatly helps most workloads.

A pipe-dream wishlist would be:
* store and access master copy of metadata on SSD only
* pin all data blocks referenced by generations not yet mirrored
* slowly copy over metadata to HDD

-- 
⢀⣴⠾⠻⢶⣦⠀ We domesticated dogs 36000 years ago; together we chased
⣾⠁⢰⠒⠀⣿⡁ animals, hung out and licked or scratched our private parts.
⢿⡄⠘⠷⠚⠋⠀ Cats domesticated us 9500 years ago, and immediately we got
⠈⠳⣄⠀⠀⠀⠀ agriculture, towns then cities.     -- whitroth on /.

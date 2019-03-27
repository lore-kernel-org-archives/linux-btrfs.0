Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E63BEC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 17:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C09982075C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 17:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbfC0RiV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 13:38:21 -0400
Received: from tartarus.angband.pl ([54.37.238.230]:52504 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbfC0RiV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 13:38:21 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.92)
        (envelope-from <kilobyte@angband.pl>)
        id 1h9CV8-00027A-MI; Wed, 27 Mar 2019 18:38:10 +0100
Date:   Wed, 27 Mar 2019 18:38:10 +0100
From:   Adam Borowski <kilobyte@angband.pl>
To:     Matthew Wilcox <willy@infradead.org>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/15] btrfs: create a mount option for dax
Message-ID: <20190327173810.GA6656@angband.pl>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-2-rgoldwyn@suse.de>
 <20190326191001.GP10344@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190326191001.GP10344@bombadil.infradead.org>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 12:10:01PM -0700, Matthew Wilcox wrote:
> On Tue, Mar 26, 2019 at 02:02:47PM -0500, Goldwyn Rodrigues wrote:
> > The dax option is restricted to non multi-device mounts.
> > dax interacts with the device directly instead of using bio, so
> > all bio-hooks which we use for multi-device cannot be performed
> > here. While regular read/writes could be manipulated with
> > RAID0/1, mmap() is still an issue.
> > 
> > Auto-setting free space tree, because dealing with free space
> > inode (specifically readpages) is a nightmare.
> > Auto-setting nodatasum because we don't get callback for writing
> > checksums after mmap()s.
> 
> Congratulations on getting the bear to dance.  But why?
> 
> To me, the point of btrfs is all the cool stuff it does with built-in
> checksumming and snapshots and RAID and so on.  DAX doesn't let you do
> any of that, so why would somebody want to use btrfs to manage DAX?

If I read this correctly (I merely glanced at it), this patchset _does_
provide the full snapshot functionality.  This is something other
filesystems don't allow: ext4 has no CoW at all, and IIRC on XFS reflinks
and DAX are mutually exclusive.

Obviously, the usual btrfs way of CoWing every write would remove all
(write) upsides of DAX, thus NOCOW (ie, CoW once) is the way to go: a page
fault should happen no more than once per page per snapshot.


On the other hand, checksumming seems useless to me.  Data corruption can
happen either in transit or at rest.  For at rest, disks already have their
own checksums -- and [NV]DIMMs have ECC.  On the other hand, the majority of
the time when someone seeks help on the btrfs mailing list, it turns out to
be a matter of bad RAM, bad motherboard or bad cabling.  This doesn't apply
to pmem.  The usual path is:

   CPU
    |<--->memory
    |
  SATA controller
    |
    (SATA cable)
    |
  disk

The data goes to memory (very unlikely to to remain in the cache before
getting checksummed), then has to travel all the way down.  On the other
hand, the path on pmem is:

  CPU
   |---->memory

So the data written by userspace goes to memory... and that's it.


As for multi-device, at least single block groups would be very nice (to
have a filesystem than spans regions) and easyish to implement, while RAID0
might spoil hugepage fun but may still be straightforward.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀
⣾⠁⢠⠒⠀⣿⡁ Did ya know that typing "test -j8" instead of "ctest -j8"
⢿⡄⠘⠷⠚⠋⠀ will make your testsuite pass much faster, and fix bugs?
⠈⠳⣄⠀⠀⠀⠀

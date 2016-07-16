Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48941 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbcGPKSb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jul 2016 06:18:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bOMfy-0004Hl-J0
	for linux-btrfs@vger.kernel.org; Sat, 16 Jul 2016 12:18:26 +0200
Received: from ip1f11faed.dynamic.kabel-deutschland.de ([31.17.250.237])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Jul 2016 12:18:26 +0200
Received: from hurikhan77 by ip1f11faed.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Jul 2016 12:18:26 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Btrfs uuid snapshots: orphaned parent_uuid after deleting
 intermediate subvol
Date: Sat, 16 Jul 2016 12:18:18 +0200
Message-ID: <20160716121818.34457a8e@jupiter.sol.kaishome.de>
References: <alpine.LRH.2.11.1607151611410.16154@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Fri, 15 Jul 2016 16:12:51 -0700 (PDT)
schrieb Eric Wheeler <btrfs@lists.ewheeler.net>:

> Hello all,
> 
> If I create three subvolumes like so:
> 
> # btrfs subvolume create a
> # btrfs subvolume snapshot a b
> # btrfs subvolume snapshot b c
> 
> I get a parent-child relationship which can be determined like so:
> 
> # btrfs subvolume list -uq /home/ |grep [abc]$
> parent_uuid - uuid 0e5f473a-d9e5-144a-8f49-1899af7320ad path a
> parent_uuid 0e5f473a-d9e5-144a-8f49-1899af7320ad uuid
> cb4768eb-98e3-5e4c-935d-14f1b97b0de2 path b parent_uuid
> cb4768eb-98e3-5e4c-935d-14f1b97b0de2 uuid
> 5ee8de35-2bab-d642-b5c2-f619e46f65c2 path c
> 
> Now if I delete 'b', the parent_uuid of 'c' doesn't change to point
> at 'a':
> 
> # btrfs subvolume delete b
> # btrfs subvolume list -uq /home/ |grep [abc]$
> parent_uuid - uuid 0e5f473a-d9e5-144a-8f49-1899af7320ad path a
> parent_uuid cb4768eb-98e3-5e4c-935d-14f1b97b0de2 uuid
> 5ee8de35-2bab-d642-b5c2-f619e46f65c2 path c

It cannot do that because b may have diverged from a.

> Notice that 'c' still points at b's UUID, but 'b' is missing and the 
> parent_uuid for 'c' wasn't set to '-' as if it were a root node (like
> 'a').
> 
> Is this an inconsistency?  Child parent_uuid's it be updated on
> delete?

I think this is by design. This "missing" UUID is now no longer a file
system tree, it's just referencing blocks different between a and c at
the time of deleting b.

> It would be nice to know that 'c' is actually a descendent of 'a',
> even after having deleted 'b'.  Is a way to look that up somehow?

Actually it would also be interesting what happens with blocks in
deleted b after the blocks in c are unshared? Are they garbage
collected or do we have some orphan subvolume lying around which you
cannot get rid of?


-- 
Regards,
Kai

Replies to list-only preferred.


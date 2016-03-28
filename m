Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:47264 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbcC1OhR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 10:37:17 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1akYI6-0002TQ-T2
	for linux-btrfs@vger.kernel.org; Mon, 28 Mar 2016 16:37:14 +0200
Date: Mon, 28 Mar 2016 16:37:14 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: "bad metadata" not fixed by btrfs repair
Message-ID: <20160328143714.GZ10135@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a btrfs which btrfs check --repair doesn't fix:

# btrfs check --repair /dev/mapper/fanbtr
bad metadata [4425377054720, 4425377071104) crossing stripe boundary
bad metadata [4425380134912, 4425380151296) crossing stripe boundary
bad metadata [4427532795904, 4427532812288) crossing stripe boundary
bad metadata [4568321753088, 4568321769472) crossing stripe boundary
bad metadata [4568489656320, 4568489672704) crossing stripe boundary
bad metadata [4571474493440, 4571474509824) crossing stripe boundary
bad metadata [4571946811392, 4571946827776) crossing stripe boundary
bad metadata [4572782919680, 4572782936064) crossing stripe boundary
bad metadata [4573086351360, 4573086367744) crossing stripe boundary
bad metadata [4574221041664, 4574221058048) crossing stripe boundary
bad metadata [4574373412864, 4574373429248) crossing stripe boundary
bad metadata [4574958649344, 4574958665728) crossing stripe boundary
bad metadata [4575996018688, 4575996035072) crossing stripe boundary
bad metadata [4580376772608, 4580376788992) crossing stripe boundary
repaired damaged extent references
Fixed 0 roots.
checking free space cache
checking fs roots
checking csums
checking root refs
enabling repair mode
Checking filesystem on /dev/mapper/fanbtr
UUID: 90f8d728-6bae-4fca-8cda-b368ba2c008e
cache and super generation don't match, space cache will be invalidated
found 97171628230 bytes used err is 0
total csum bytes: 91734220
total tree bytes: 3021848576
total fs tree bytes: 2762784768
total extent tree bytes: 148570112
btree space waste bytes: 545440822
file data blocks allocated: 308328280064
 referenced 177314340864
# btrfs check --repair /dev/mapper/fanbtr
checking extents
bad metadata [4425377054720, 4425377071104) crossing stripe boundary
bad metadata [4425380134912, 4425380151296) crossing stripe boundary
bad metadata [4427532795904, 4427532812288) crossing stripe boundary
bad metadata [4568321753088, 4568321769472) crossing stripe boundary
bad metadata [4568489656320, 4568489672704) crossing stripe boundary
bad metadata [4571474493440, 4571474509824) crossing stripe boundary
bad metadata [4571946811392, 4571946827776) crossing stripe boundary
bad metadata [4572782919680, 4572782936064) crossing stripe boundary
bad metadata [4573086351360, 4573086367744) crossing stripe boundary
bad metadata [4574221041664, 4574221058048) crossing stripe boundary
bad metadata [4574373412864, 4574373429248) crossing stripe boundary
bad metadata [4574958649344, 4574958665728) crossing stripe boundary
bad metadata [4575996018688, 4575996035072) crossing stripe boundary
bad metadata [4580376772608, 4580376788992) crossing stripe boundary
repaired damaged extent references
Fixed 0 roots.
checking free space cache
checking fs roots
checking csums
checking root refs
enabling repair mode
Checking filesystem on /dev/mapper/fanbtr
UUID: 90f8d728-6bae-4fca-8cda-b368ba2c008e
cache and super generation don't match, space cache will be invalidated
found 97171628230 bytes used err is 0
total csum bytes: 91734220
total tree bytes: 3021848576
total fs tree bytes: 2762784768
total extent tree bytes: 148570112
btree space waste bytes: 545440822
file data blocks allocated: 308328280064
 referenced 177314340864

How do I fix this?

Does the kernel play a role in btrfs check --repair, or is this all a
userspace matter?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421

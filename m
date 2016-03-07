Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10266 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751798AbcCGFmf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2016 00:42:35 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id B1EAA41890FE
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Mar 2016 13:42:19 +0800 (CST)
To: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Btrfsck memory usage reduce idea
Message-ID: <56DD14B6.4070908@cn.fujitsu.com>
Date: Mon, 7 Mar 2016 13:42:14 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

As many have already known, "btrfs check" is a memory eater.

The problem is, btrfsck checks extent tree in a very comprehensive method.
1) Create extent_ref for each extent item with backref
2) Iterate all other trees to add extent ref
3) If one extent_ref with all ref/backref matches, it's deleted.

The method is good, can found any extent mismatch problem when checking 
extent tree. (Although it has already iterated the whole fs)
For a large enough filesystem, it may have tegas of extents, and memory 
is easy eaten up.


We hope to fix it in the following method:
1) Only check extent backref when iterating extent tree
    Unlike current implement, we check one extent item and its backref
    only.

    If one backref can't be reached, then it's an error and output (or
    try to fix).
    After iterating all backref of an extent item, all related memory is
    freed and we won't bother recording anything for later use.

    That's to say, we only care backref mismatch case when checking
    extent tree.
    Case like missing EXTENT_ITEM for some extent is not checked here.

2) Check extent ref while iterating other trees
    We only check forward-ref while iterating one tree.

    In this step, we only check forward-ref, so we can find the remaining
    problem like missing EXTENT_ITEM for given extent.

Any further advice/suggestion? Or is there anyone already doing such work?

Thanks,
Qu




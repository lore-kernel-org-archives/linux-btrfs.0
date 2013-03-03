Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:50967 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab3CCNkw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2013 08:40:52 -0500
Received: by mail-we0-f177.google.com with SMTP id d7so3748397wer.22
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Mar 2013 05:40:50 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 3 Mar 2013 15:40:50 +0200
Message-ID: <CAOcd+r2p9AonnEwGZCS4CPUJ8O2EuQkSAA15twERY47FtrqLEw@mail.gmail.com>
Subject: same EXTENT_ITEM appears twice in the extent tree
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings all,
I have an extent tree that looks like follows:

	item 22 key (27059916800 EXTENT_ITEM 16384) itemoff 2656 itemsize 24
		extent refs 1 gen 164 flags 1
	item 23 key (27059916800 EXTENT_ITEM 98304) itemoff 2603 itemsize 53
		extent refs 1 gen 165 flags 1
		extent data backref root 257 objectid 257 offset 17446191104 count 1
	item 24 key (27059916800 SHARED_DATA_REF 47169536) itemoff 2599 itemsize 4
		shared data backref count 1

As can be seen, same EXTENT_ITEM appears twice. This was undetected,
until __btrfs_free_extent was called, after cleaner deleted one of the
snapshots. Then it lead to assert:
		if (found_extent) {
			BUG_ON(is_data && refs_to_drop !=
			       extent_data_ref_count(root, path, iref));
			if (iref) {
				BUG_ON(path->slots[0] != extent_slot);
			} else {
				BUG_ON(path->slots[0] != extent_slot + 1);  /* CRASH */
				path->slots[0] = extent_slot;
				num_to_del = 2;
			}

As for the usage of this bad extent, there are multiple snapshots
sharing the 98304-length extent, but only one that uses the 16384
extent:
file tree key (257 ROOT_ITEM 0)
	item 19 key (257 EXTENT_DATA 17446191104) itemoff 2935 itemsize 53
		extent data disk byte 27059916800 nr 98304
		extent data offset 0 nr 98304 ram 98304
		extent compression 0
...
file tree key (350 ROOT_ITEM 164)
	item 21 key (257 EXTENT_DATA 17446191104) itemoff 2829 itemsize 53
		extent data disk byte 27059916800 nr 16384
		extent data offset 0 nr 16384 ram 16384
		extent compression 0

...
file tree key (352 ROOT_ITEM 167)
	item 19 key (257 EXTENT_DATA 17446191104) itemoff 2935 itemsize 53
		extent data disk byte 27059916800 nr 98304
		extent data offset 0 nr 98304 ram 98304
		extent compression 0

Kernel is "for-linus", top commit:

commit 1eafa6c73791e4f312324ddad9cbcaf6a1b6052b
Author: Miao Xie <miaox@cn.fujitsu.com>
Date:   Tue Jan 22 10:49:00 2013 +0000

    Btrfs: fix repeated delalloc work allocation

I believe I might have more extents like this, because btrfs-debug-tree warns:
warning, bad space info total_bytes 26851934208 used 26852773888
warning, bad space info total_bytes 27925676032 used 27926892544

Mount options: nodatasum,nodatacow,noatime,nospace_cache. Metadata
profile is DUP, data profile is single.

Can anybody advise on how this could have happened? I can provide the
whole debug-tree, btrfs-image or any additional info.

Thanks,
Alex.

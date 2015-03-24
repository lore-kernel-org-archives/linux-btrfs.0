Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11614 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751240AbbCXHVI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 03:21:08 -0400
Message-ID: <55111060.7000302@cn.fujitsu.com>
Date: Tue, 24 Mar 2015 15:21:04 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
CC: Liu Bo <bo.li.liu@oracle.com>
Subject: Is rbtree really needed to restore ref_root in btrfs_delayed_ref_head?
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all and maintainers.

I'm investigating several qgroup bugs, and find out current delayed ref 
implement has several possible problem which may lead to qgroup bugs.

Although my previous RFC patchset 
(http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg42458.html) 
is trying to resolve some qgroup problems, some deep problem in 
delayed-ref seems blocking further fix.

[Problem]
Seq in ref_node doesn't really make sense
For example, in Liu Bo's fstests btrfs/017, all DROP_DELAYED_REF 
ref_node will have the same sequence number.

But qgroup routine, especially with my RFC 
patchset(http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg42458.html), 
needs the exact insert order to do accurate excl/rfer calculation.

My first idea was to reintroduce the minor sequence number in ref_node, 
but soon I realized that we could have a better idea with [FIX].

[FIX]
Why not dual index ref_node with list only?
Current implement using rb-tree of ref_root is only 
update_existing_ref(), which is in fact merging ref_nodes with same 
(bytenr, parent) tuple.

But in fact, we have merge_refs() and doesn't need to do such thing at 
insert time.

IMHO use list to index ref_node should be a quite qgroup friendly 
implement, where qgroup codes can get the perfect insert sequence it needs.


Delayed-ref is somewhat fundamental piece of btrfs, so I send the mail 
before writing the patch.
It would be quite nice if anyone can point if there is anything wrong 
before I wasting several days to write a meaningless patch.

Thanks,
Qu

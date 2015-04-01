Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62737 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751055AbbDAHJX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 03:09:23 -0400
Message-ID: <551B999B.2030602@cn.fujitsu.com>
Date: Wed, 1 Apr 2015 15:09:15 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
CC: Liu Bo <bo.li.liu@oracle.com>
Subject: Re: Is rbtree really needed to restore ref_root in btrfs_delayed_ref_head?
References: <55111060.7000302@cn.fujitsu.com>
In-Reply-To: <55111060.7000302@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If no one disagree, I'll try to implement it using list.

In fact, after an easy patch and some tests, it doesn't bring much 
performance regression, and delayed_ref_nodes are still mergeable.

Thanks,
Qu

-------- Original Message  --------
Subject: Is rbtree really needed to restore ref_root in 
btrfs_delayed_ref_head?
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba 
<dsterba@suse.cz>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Date: 2015年03月24日 15:21

> Hi all and maintainers.
>
> I'm investigating several qgroup bugs, and find out current delayed ref
> implement has several possible problem which may lead to qgroup bugs.
>
> Although my previous RFC patchset
> (http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg42458.html)
> is trying to resolve some qgroup problems, some deep problem in
> delayed-ref seems blocking further fix.
>
> [Problem]
> Seq in ref_node doesn't really make sense
> For example, in Liu Bo's fstests btrfs/017, all DROP_DELAYED_REF
> ref_node will have the same sequence number.
>
> But qgroup routine, especially with my RFC
> patchset(http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg42458.html),
> needs the exact insert order to do accurate excl/rfer calculation.
>
> My first idea was to reintroduce the minor sequence number in ref_node,
> but soon I realized that we could have a better idea with [FIX].
>
> [FIX]
> Why not dual index ref_node with list only?
> Current implement using rb-tree of ref_root is only
> update_existing_ref(), which is in fact merging ref_nodes with same
> (bytenr, parent) tuple.
>
> But in fact, we have merge_refs() and doesn't need to do such thing at
> insert time.
>
> IMHO use list to index ref_node should be a quite qgroup friendly
> implement, where qgroup codes can get the perfect insert sequence it needs.
>
>
> Delayed-ref is somewhat fundamental piece of btrfs, so I send the mail
> before writing the patch.
> It would be quite nice if anyone can point if there is anything wrong
> before I wasting several days to write a meaningless patch.
>
> Thanks,
> Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

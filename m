Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43636 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1761011AbcINROZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 13:14:25 -0400
Subject: Re: [PATCH] Btrfs: kill BUG_ON in do_relocation
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1473870467-18721-1-git-send-email-bo.li.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <9426999a-06a8-d169-753a-0c4df5c7c4f8@fb.com>
Date: Wed, 14 Sep 2016 13:13:34 -0400
MIME-Version: 1.0
In-Reply-To: <1473870467-18721-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/14/2016 12:27 PM, Liu Bo wrote:
> While updating btree, we try to push items between sibling
> nodes/leaves in order to keep height as low as possible.
> But we don't memset the original places with zero when
> pushing items so that we could end up leaving stale content
> in nodes/leaves.  One may read the above stale content by
> increasing btree blocks' @nritems.
>

Ok this sounds really bad.  Is this as bad as I think it sounds?  We should 
probably fix this like right now right?

> One case I've come across is that in fs tree, a leaf has two
> parent nodes, hence running balance ends up with processing
> this leaf with two parent nodes, but it can only reach the
> valid parent node through btrfs_search_slot, so it'd be like,
>
> do_relocation
>     for P in all parent nodes of block A:
>         if !P->eb:
>             btrfs_search_slot(key);   --> get path from P to A.
>         if lowest:
>             BUG_ON(A->bytenr != bytenr of A recorded in P);
>         btrfs_cow_block(P, A);   --> change A's bytenr in P.
>
> After btrfs_cow_block, P has the new bytenr of A, but with the
> same @key, we get the same path again, and get panic by BUG_ON.
>

Ok so this happens because of the problem you described above right?  Because 
this shouldn't actually happen.  We should go down the next parent and still get 
to the original block where A->bytenr == node->bytenr.  So I'm all for killing 
this BUG_ON(), but the problem description is wrong.  We need to keep this 
scenario from happening in the first place.  And then we kill this BUG_ON() 
because it can happen if there is FS corruption or something.  Thanks,

Josef

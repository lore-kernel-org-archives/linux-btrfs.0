Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:65131 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965051AbdIZFgm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 01:36:42 -0400
Subject: Re: question: behavior of original check
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <4a380ce4-b57f-a524-85ae-170602d3d33b@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <fcd2b89e-1a75-dcfd-4664-cb09981cdc72@gmx.com>
Date: Tue, 26 Sep 2017 13:36:32 +0800
MIME-Version: 1.0
In-Reply-To: <4a380ce4-b57f-a524-85ae-170602d3d33b@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月26日 11:01, Su Yue wrote:
> Hi
> 
> During writing patches about check, I found something confusing
> about btrfs-progs original check.
> 
> Setup:
> Version: Btrfs progs v4.13.1
> 
> $ make TEST=006\* test-fsck
> [TEST]   fsck-tests.sh
> [TEST/fsck]   006-bad-root-items
> 
> $ cat tests/fsck-tests-results.txt | tail -n  25
> ############### .../btrfs-progs/btrfs check test.img
> checking extents
> ref mismatch on [15474688 905216] extent item 1, found 4
> Backref 15474688 parent 30883840 owner 0 offset 0 num_refs 0 not found 
> in extent tree
> Incorrect local backref count on 15474688 parent 30883840 owner 0 offset 
> 0 found 1 wanted 0 back 0x561cdc0b2770
> Backref 15474688 parent 31326208 owner 0 offset 0 num_refs 0 not found 
> in extent tree
> Incorrect local backref count on 15474688 parent 31326208 owner 0 offset 
> 0 found 1 wanted 0 back 0x561cdc0b5390
> Backref 15474688 parent 31817728 owner 0 offset 0 num_refs 0 not found 
> in extent tree
> Incorrect local backref count on 15474688 parent 31817728 owner 0 offset 
> 0 found 1 wanted 0 back 0x561cdc0b5330
> backpointer mismatch on [15474688 905216]
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> Checking filesystem on test.img
> UUID: 3857c23d-4219-4600-a636-ac7707dc4ff3
> cache and super generation don't match, space cache will be invalidated
> found 6291456 bytes used, *no error* found
> total csum bytes: 660
> total tree bytes: 786432
> total fs tree bytes: 688128
> total extent tree bytes: 16384
> btree space waste bytes: 459860
> file data blocks allocated: 35536896
>   referenced 25890816
> 
> 
> It seems that errors in extent-tree are not important so btrfs-progs 
> just returns 0.

It's a bug that ignored the error found in extent tree.
It's exposed quite a long time ago IIRC.

> 
> Is this behavior normal(on purpose)?

Definitely not.

> I have written a patch to fix it but then test-fsck/006 will fail due to
> nonzero value progs returned.

The problem is that btrfs check doesn't repair the bug.

You would better also fix the repair code.

Thanks,
Qu

> 
> Thanks,
> Su
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55515 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751881AbdJSI6s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 04:58:48 -0400
Subject: Re: check: "warning line 4144"
To: Tom Hale <tom@hale.ee>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <82b863c8-ef92-736c-2a9d-51102db07919@hale.ee>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c9a41b3b-16d8-e504-bfd1-79295cc465a7@gmx.com>
Date: Thu, 19 Oct 2017 16:58:39 +0800
MIME-Version: 1.0
In-Reply-To: <82b863c8-ef92-736c-2a9d-51102db07919@hale.ee>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年10月19日 16:53, Tom Hale wrote:
> In running btrfs check, I got the following message:
> 
>     warning line 4144
> 
> Could this be a little more descriptive?
> 
> * Does it mean I should rebuild my FS from scratch?
> * Is there anything I can do to remove this warning?
> 
> Complete output below:
> 
> ==========================================================
> $ sudo btrfs check --repair -p /dev/mapper/fix-backup

--repair is dangerous, use it unless you're sure the problem can be
fixed by it.

What's the output of "btrfs check" and "btrfs check --mode=lowmem" after
doing the repair?

Thanks,
Qu

> enabling repair mode
> Checking filesystem on /dev/mapper/fix-backup
> UUID: 0f5b7713-929d-41e7-b214-32500b5c77fc
> ref mismatch on [195215851520 16384] extent item 0, found 1
> Backref 195215851520 parent 1463 root 1463 not found in extent tree
> backpointer mismatch on [195215851520 16384]
> owner ref check failed [195215851520 16384]
> repair deleting extent record: key 195215851520 169 1
> adding new tree backref on start 195215851520 len 16384 parent 0 root 1463
> Repaired extent references for 195215851520
> 
> Fixed 0 roots.
> cache and super generation don't match, space cache will be invalidated
> warning line 4144 [o]
> 
> checking csums
> checking root refs
> found 294913892352 bytes used, no error found
> total csum bytes: 282955440
> total tree bytes: 5166727168
> total fs tree bytes: 4489232384
> total extent tree bytes: 353075200
> btree space waste bytes: 886405127
> file data blocks allocated: 7930446508032
>  referenced 1126675288064
> ==========================================================
> 

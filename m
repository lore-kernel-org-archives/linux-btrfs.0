Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39178 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750930AbdE3SER (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 May 2017 14:04:17 -0400
Date: Tue, 30 May 2017 11:02:17 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Ivan Sizov <sivan606@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/6] add sanity check for extent inline ref type
Message-ID: <20170530180217.GA21784@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170526002631.8546-1-bo.li.liu@oracle.com>
 <CAMG9ccwjBmP9HKkodwARxQK7AkC68HACMzuT43wX6+gmWVUjbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMG9ccwjBmP9HKkodwARxQK7AkC68HACMzuT43wX6+gmWVUjbg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 30, 2017 at 05:05:09PM +0300, Ivan Sizov wrote:
> 2017-05-26 3:26 GMT+03:00 Liu Bo <bo.li.liu@oracle.com>:
> >Patch 6 adds scrub support to detect the corruption, so users can be
> noticed when they do scrub on a regular basis.
> >I'm not sure in the real world what may result in this corruption
> 
> I've caught this type of corruption in the wild. The big rsync backup
> always ends with a kernel crash due to BUG() statement in
> ctime.h:1779. After applying this patchset and running scrub I've got
> following messages:
> 
> [sivan@fruestuck ~]$ dmesg | grep "invalid extent inline"
> [ 8812.428673] eb 4631634034688(tree block) invalid extent inline ref type 0
> [ 8812.429148] BTRFS error (device sdb1): scrub: extent
> 2994741510144(0x2b944810000) has an invalid extent inline ref type,
> ignored.
> [ 8812.430086] eb 4631634034688(tree block) invalid extent inline ref type 0
> [ 8812.430569] BTRFS error (device sdb1): scrub: extent
> 2994741559296(0x2b94481c000) has an invalid extent inline ref type,
> ignored.
> 
> How to find the cause of the corruption? Should I try to fix it, or it
> is not dangerous for the filesystem? If I should, how to do that?

Did it also print a btree's leaf's content?  If yes, it could show us
which inline ref has the issue.

It's not easy to tell if it's dangerous because I have no idea what
type of extent "2994741559296(0x2b94481c000)" refers to.

The command 'btrfs check' in the latest btrfs-progs can fix my test
case, which is the simplest one (only touched the inline ref and
everything else remained the same).

Given that at least two users reported about this, I start thinking
about there's something wrong inside our btrfs code.

-liubo

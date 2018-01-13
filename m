Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37026 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751372AbeAMUlY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Jan 2018 15:41:24 -0500
Date: Sat, 13 Jan 2018 21:41:15 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Subject: Re: invalid files names, btrfs check can't repair it
Message-ID: <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
 <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-13 08:56:24 [+0800], Qu Wenruo wrote:
> 'Btrfs check' output please.

~# btrfs check --repair -p /dev/sdb4
enabling repair mode
Checking filesystem on /dev/sdb4
UUID: b3bfb56e-d445-4335-93f0-c1fb2d1f6df1
Fixed 0 roots.
checking extents [o]
No device size related problem found
cache and super generation don't match, space cache will be invalidated
checkingunresolved ref dir 57648595 index 435 namelen 40 name 2f3f379b2a3d7499471edb74869efe-1948311.d filetype 1 errors 80, filetype mismatch
        unresolved ref dir 57648595 index 1137 namelen 39 name 454bf066ddfbf42e0f3b77ea71c82f-878732.o filetype 1 errors 100, name too long

checking csums
checking root refs
found 63691468800 bytes used, no error found
total csum bytes: 61339388
total tree bytes: 860536832
total fs tree bytes: 688816128
total extent tree bytes: 84545536
btree space waste bytes: 224424238
file data blocks allocated: 62890745856
 referenced 62829219840
~# 

> And in fact, btrfs check --repair has the ability to move/re-link such
> file and keeps its content, as long as there is any info found in
> DIR_INDEX/DIR_ITEM/INODE_REF.
> 
> If repair can't handle it, the output could help us to craft such case
> and enhance btrfs-progs to repair it.

Is the output enough or do you want me to do more?

> Thanks,
> Qu

Sebastian

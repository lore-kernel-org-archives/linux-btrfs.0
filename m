Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62852 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754065AbdIEBWN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 21:22:13 -0400
Subject: Re: btrfs check --repair now runs in minutes instead of hours?
 aborting
To: Marc MERLIN <marc@merlins.org>, quwenruo@cn.fujitsu.com,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>, Chris Mason <clm@fb.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
References: <20170905010531.rfvun5isjwrb5ur5@merlins.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <75b0ebd3-41ea-7f45-bec4-f7d9ec6efee1@gmx.com>
Date: Tue, 5 Sep 2017 09:21:55 +0800
MIME-Version: 1.0
In-Reply-To: <20170905010531.rfvun5isjwrb5ur5@merlins.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月05日 09:05, Marc MERLIN wrote:
> Ok, I don't want to sound like I'm complaining :) but I updated
> btrfs-progs to top of tree in git, installed it, and ran it on an 8TiB
> filesystem that used to take 12H or so to check.

How much space allocated for that 8T fs?
If metadata is not that large, 10min is valid.

Here fi df output could help.

And, without --repair, how much time it takes to run?

> 
> It finished in maybe 10mn, just 10mn! :)
> gargamel:/var/local/src/btrfs-progs# btrfs check --repair /dev/mapper/dshelf1
> enabling repair mode
> Checking filesystem on /dev/mapper/dshelf1
> UUID: 36f5079e-ca6c-4855-8639-ccb82695c18d
> checking extents
> Fixed 0 roots.
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> checking csums
> checking root refs
> found 11674263347200 bytes used, no error found
> total csum bytes: 11384482936
> total tree bytes: 13704495104
> total fs tree bytes: 724729856
> total extent tree bytes: 482639872
> btree space waste bytes: 1167025205
> file data blocks allocated: 12041456693248
>   referenced 12063146434560
> 
> This is great news, but can I trust that the program worked properly and
> indeed that my filesystem is fully clean?

Normally we rely on btrfs-progs selftest to make sure fsck works.
But maybe we could cross check original mode and lowmem mode.

> Or at this point if I'm not running --mode=lowmem, the regular mode is
> really doesn't check much and only lowmem can do a proper check? (even
> though it can't fix problems once it finds them)

No, original mode is still the core (although code is not that elegant), 
please consider lowmem mode as a corner case for guys with small memory 
(without swap) but want to check super large fs.

So if it turns out to be a bug, we must fix it.

Thanks,
Qu
> 
> Thanks
> Marc
> 

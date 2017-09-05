Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57830 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753698AbdIEC4C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Sep 2017 22:56:02 -0400
Date: Mon, 4 Sep 2017 19:55:56 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: quwenruo@cn.fujitsu.com, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: btrfs check --repair now runs in minutes instead of hours? aborting
Message-ID: <20170905025556.GA6392@merlins.org>
References: <20170905010531.rfvun5isjwrb5ur5@merlins.org> <75b0ebd3-41ea-7f45-bec4-f7d9ec6efee1@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <75b0ebd3-41ea-7f45-bec4-f7d9ec6efee1@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 05, 2017 at 09:21:55AM +0800, Qu Wenruo wrote:
> 
> 
> On 2017年09月05日 09:05, Marc MERLIN wrote:
> >Ok, I don't want to sound like I'm complaining :) but I updated
> >btrfs-progs to top of tree in git, installed it, and ran it on an 8TiB
> >filesystem that used to take 12H or so to check.
> 
> How much space allocated for that 8T fs?
> If metadata is not that large, 10min is valid.
> 
> Here fi df output could help.

gargamel:~# btrfs fi df /mnt/btrfs_pool1
Data, single: total=10.60TiB, used=10.54TiB
System, DUP: total=32.00MiB, used=1.19MiB
Metadata, DUP: total=58.00GiB, used=12.69GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

> And, without --repair, how much time it takes to run?

Well, funny that you ask, it's now been running for hours, still waiting...
 
Just before, I ran lowmem, and it was pretty quick too (didn't time it,
but less than 1h):
gargamel:/var/local/src/btrfs-progs# btrfs check --mode=lowmem
/dev/mapper/dshelf1
Checking filesystem on /dev/mapper/dshelf1
UUID: 36f5079e-ca6c-4855-8639-ccb82695c18d
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 11674263330816 bytes used, no error found
total csum bytes: 11384482936
total tree bytes: 13738737664
total fs tree bytes: 758988800
total extent tree bytes: 482623488
btree space waste bytes: 1171475737
file data blocks allocated: 12888981110784
 referenced 12930453286912

Now, this is good news for my filesystem being probably clean (previous
versions of lowmem before my git update found issues that were unclear, but
apparently errors in the code, and this version finds nothing)

But I'm not sure why --repair would be fast, and not --repair would be slow?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

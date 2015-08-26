Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60498 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752035AbbHZK3w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 06:29:52 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Yurii Kolesnykov'" <yurikoles@gmail.com>,
        "'Chris Murphy'" <lists@colorremedies.com>,
        "'Btrfs BTRFS'" <linux-btrfs@vger.kernel.org>
CC: "'Qu Wenruo'" <quwenruo@cn.fujitsu.com>
References: <CAJCQCtSGRU6x2g3Asy42q76YtO8p=8DTaOwEchaWjzB23BX8xA@mail.gmail.com> <04eb01d0c4f9$80e42300$82ac6900$@cn.fujitsu.com> <55DD8A7A.9030804@gmail.com>
In-Reply-To: <55DD8A7A.9030804@gmail.com>
Subject: RE: [BUG] kernel BUG at fs/btrfs/scrub.c:1956!, when scrubbing freshly converted ext4
Date: Wed, 26 Aug 2015 18:28:22 +0800
Message-ID: <031e01d0dfe9$ef47f9b0$cdd7ed10$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Yurii Kolesnykov

> -----Original Message-----
> From: Yurii Kolesnykov [mailto:yurikoles@gmail.com]
> Sent: Wednesday, August 26, 2015 5:44 PM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>; 'Chris Murphy'
> <lists@colorremedies.com>; 'Btrfs BTRFS' <linux-btrfs@vger.kernel.org>
> Cc: 'Qu Wenruo' <quwenruo@cn.fujitsu.com>
> Subject: Re: [BUG] kernel BUG at fs/btrfs/scrub.c:1956!, when scrubbing
> freshly converted ext4
> 
> Hi, Zhao Lei
> 
> >
> > I reproduced above bug too, with following command:
> >   mkfs.ext4 /dev/vdh
> >   btrfs-convert /dev/vdh
> >   mount /dev/vdh /mnt/tmp1
> >   btrfs scrub start -B /dev/vdh
> >   (panic)
> >
> > The reason is:
> > 1: In some case, metadata(leaf) created by btrfs-convert was split into 2
> strips.
> > 2: Then scrub bypassed part of leaf data, and left data caused panic in
> >   scrub_checksum_tree_block().
> >
> > For above 1:
> > we can get following information after some simple operation.
> > a. mkfs.ext4 /dev/vdh
> >   btrfs-convert /dev/vdh
> > b. btrfs-debug-tree /dev/vdh
> >   we can see following item in extent tree:
> >   item 25 key (27054080 METADATA_ITEM 0) itemoff 15083 itemsize 33
> >   Its logical address is [27054080, 27070464)
> >   and acrossed 2 strips:
> >   [27000832, 27066368)
> >   [27066368, 27131904)
> > Qu Wenruo <quwenruo@cn.fujitsu.com> is fixing above problem.
> >	
> > For above 2:
> > scrub is trying to do a "bypass" in this case, but the result is "panic".
> > I'll fix it.
> >
> > Thanks
> > Zhaolei
> 
> Could you please share an update on this bug status?

Above 1 is fixed in patch titled:
[PATCH] btrfs: Fix scrub panic when leaf accross stripes
in btrfs maillist.

This patch is in integration-4.3 branch, and will be merged
into linux 4.3.

For above 2, it is fixed by Qu Wenruo <quwenruo@cn.fujitsu.com>,
patch set is btrfs maillist named:
 [PATCH 0/4] Metadata crossing stripe boundary fixes
 ...

These patch are already in new version of btrfs-progs now.

> Also, please use bugzilla.

I failed to close the bug in Bugzilla, maybe no permission, or
oher problem for newbee as I.

Maybe 'Chris Murphy' <lists@colorremedies.com> can close it.

Thanks
Zhaolei



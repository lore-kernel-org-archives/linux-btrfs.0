Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49063 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751154AbbGWDme convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jul 2015 23:42:34 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Chris Murphy'" <lists@colorremedies.com>,
        "'Btrfs BTRFS'" <linux-btrfs@vger.kernel.org>
CC: "'Qu Wenruo'" <quwenruo@cn.fujitsu.com>
References: <CAJCQCtSGRU6x2g3Asy42q76YtO8p=8DTaOwEchaWjzB23BX8xA@mail.gmail.com>
In-Reply-To: <CAJCQCtSGRU6x2g3Asy42q76YtO8p=8DTaOwEchaWjzB23BX8xA@mail.gmail.com>
Subject: RE: [BUG] kernel BUG at fs/btrfs/scrub.c:1956!, when scrubbing freshly converted ext4
Date: Thu, 23 Jul 2015 11:41:47 +0800
Message-ID: <04eb01d0c4f9$80e42300$82ac6900$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris Murphy

Thanks for report this bug.

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org
> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Chris Murphy
> Sent: Thursday, July 09, 2015 11:16 AM
> To: Btrfs BTRFS
> Subject: [BUG] kernel BUG at fs/btrfs/scrub.c:1956!, when scrubbing freshly
> converted ext4
> 
> OK yet another btrfs-convert bug. This one is easier to reproduce than the
> others, does not damage the file system (still mounts OK) but the oops is a hard
> panic. ssh and even the virt-manager console dies instantly, but virsh console
> captured a lot of call traces and are attached to the bug report.
> 
> Happens with 4.1 and 4.2rc1 kernels. The convert was done with btrfs-progs
> 4.1.
> 
> The reproduce steps are easy:
> 
> 1. ext4 with a bunch of files (Fedora 22 installation) plus a ~1.5GB ISO 2.
> btrfs-convert using defaults goes OK no error, btrfs check has no complaints 3.
> mount 4. btrfs scrub hard panic
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=101231
> 

I reproduced above bug too, with following command:
  mkfs.ext4 /dev/vdh
  btrfs-convert /dev/vdh
  mount /dev/vdh /mnt/tmp1
  btrfs scrub start -B /dev/vdh
  (panic)

The reason is:
1: In some case, metadata(leaf) created by btrfs-convert was split into 2 strips.
2: Then scrub bypassed part of leaf data, and left data caused panic in
  scrub_checksum_tree_block().

For above 1:
we can get following information after some simple operation.
a. mkfs.ext4 /dev/vdh
  btrfs-convert /dev/vdh
b. btrfs-debug-tree /dev/vdh
  we can see following item in extent tree:
  item 25 key (27054080 METADATA_ITEM 0) itemoff 15083 itemsize 33
  Its logical address is [27054080, 27070464)
  and acrossed 2 strips:
  [27000832, 27066368)
  [27066368, 27131904)
Qu Wenruo <quwenruo@cn.fujitsu.com> is fixing above problem.

For above 2:
scrub is trying to do a "bypass" in this case, but the result is "panic".
I'll fix it.

Thanks
Zhaolei

> 
> --
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html


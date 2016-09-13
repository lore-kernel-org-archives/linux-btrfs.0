Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39070 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751311AbcIMAje (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 20:39:34 -0400
Subject: Re: Unable to repair "bad key order": Cyclic bad block flip-flop
To: Heinz Werner Kramski-Grote <kramski@web.de>, <linux-btrfs@vger.kernel.org>
References: <4818221.8fBhXcTYy5@sandl.hnstr58.local>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <6c6c8a43-e443-f6ce-4778-24398d118c9b@cn.fujitsu.com>
Date: Tue, 13 Sep 2016 08:39:27 +0800
MIME-Version: 1.0
In-Reply-To: <4818221.8fBhXcTYy5@sandl.hnstr58.local>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Normally, bad key order can be fixed automatically (btrfs check --repair).

Since btrfs has no idea what key order is correct.

Normally for such case, btrfs uses DUP/RAID1/5/6/10 to recover bad 
metadata block, but since it's caused by bad RAM, backup is all corrupted.

So for common case, it's not fixable by btrfs check.
If you're experienced enough, you could try manually fix them.



And in your case, btrfs kernel tells that the root tree is corrupted and 
btrfsck tells that extent tree is also corrupted.

If only extent tree is corrupted, btrfs repair --init-extent-tree would 
work, but when root tree is involved, it's a little tricky.

You could try using backup roots to avoid corrupted tree root.
And it may also fix your extent tree.
---
# btrfs-show-super -f
...
backup_roots[4]:
	backup 0:
		backup_tree_root:	31932416	gen: 10	level: 0
		backup_chunk_root:	20971520	gen: 7	level: 0
		backup_extent_root:	31899648	gen: 10	level: 1
		backup_fs_root:		31834112	gen: 9	level: 1
		backup_dev_root:	30425088	gen: 7	level: 0
		backup_csum_root:	31965184	gen: 10	level: 0
		backup_total_bytes:	10737418240
		backup_bytes_used:	16568320
		backup_num_devices:	1

...
---

That "backup_tree_root" is what you're looking for.

And use btrfsck with "-r <backup_tree_root_bytenr>" to check if the bad 
order problem disappear.

Thanks,
Qu

At 09/13/2016 05:27 AM, Heinz Werner Kramski-Grote wrote:
> Due to bad RAM (now fixed), my (single disk) root partition got corrupted and
> no longer mounts with "corrupt leaf, bad key order":
>
>     root@archiso ~ # mount /dev/sdh2 /mnt
>     mount: wrong fs type, bad option, bad superblock on /dev/sdh2,
>         missing codepage or helper program, or other error
>
>         In some cases useful info is found in syslog - try
>         dmesg | tail or so.
>
>     root@archiso ~ # dmesg | grep -i btrfs
>     [    8.513028] Btrfs loaded, crc32c=crc32c-generic
>     [    8.513033] BTRFS: selftest: sectorsize: 4096  nodesize: 4096
>     [    8.513035] BTRFS: selftest: sectorsize: 4096  nodesize: 8192
>     [    8.513037] BTRFS: selftest: sectorsize: 4096  nodesize: 16384
>     [    8.513039] BTRFS: selftest: sectorsize: 4096  nodesize: 32768
>     [    8.513041] BTRFS: selftest: sectorsize: 4096  nodesize: 65536
>     [    8.514927] BTRFS: device label btrfs devid 1 transid 36706 /dev/sdh2
>     [    8.515047] BTRFS: device label data01 devid 1 transid 645 /dev/sdg1
>     [  546.218691] BTRFS info (device sdh2): disk space caching is enabled
>     [  546.218697] BTRFS info (device sdh2): has skinny extents
>     [  546.225228] BTRFS critical (device sdh2): corrupt leaf, bad key order:
> block=75182981120,root=1, slot=0
>     [  546.225303] BTRFS error (device sdh2): failed to recover balance: -5
>     [  546.253399] BTRFS: open_ctree failed
>
> Trying to repair the FS gets into a loop of two alternating bad blocks but
> never succeeds:
>
>     root@archiso ~ # btrfs check --repair /dev/sdh2
>     enabling repair mode
>     Checking filesystem on /dev/sdh2
>     UUID: e961bc76-09bb-4616-9263-dab61b8d0ef6
>     checking extents
>     bad key ordering 0 1
>     bad block 75182981120
>     Errors found in extent allocation tree or chunk allocation
>     bad key ordering 0 1
>
>     root@archiso ~ # btrfs check --repair /dev/sdh2
>     enabling repair mode
>     Checking filesystem on /dev/sdh2
>     UUID: e961bc76-09bb-4616-9263-dab61b8d0ef6
>     checking extents
>     bad key ordering 0 1
>     bad block 75183144960
>     Errors found in extent allocation tree or chunk allocation
>     bad key ordering 0 1
>
>     root@archiso ~ # btrfs check --repair /dev/sdh2
>     enabling repair mode
>     Checking filesystem on /dev/sdh2
>     UUID: e961bc76-09bb-4616-9263-dab61b8d0ef6
>     checking extents
>     bad key ordering 0 1
>     bad block 75182981120
>     Errors found in extent allocation tree or chunk allocation
>     bad key ordering 0 1
>
>     root@archiso ~ # btrfs check --repair /dev/sdh2
>     enabling repair mode
>     Checking filesystem on /dev/sdh2
>     UUID: e961bc76-09bb-4616-9263-dab61b8d0ef6
>     checking extents
>     bad key ordering 0 1
>     bad block 75183144960
>     Errors found in extent allocation tree or chunk allocation
>     bad key ordering 0 1
>
>     [etc...]
>
> According to smartctl, the disk itself (a quite new Samsung SSD) is healthy.
>
> This is not a critical machine, but I would prefer to solve this issue over a
> new install. (I'm quite new to btrfs, though)
>
> TIA
>    Heinz
>



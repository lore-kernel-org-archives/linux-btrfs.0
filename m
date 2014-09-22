Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-am1on0139.outbound.protection.outlook.com ([157.56.112.139]:57210
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753128AbaIVUSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 16:18:15 -0400
From: Jaap Pieroen <jaap.pieroen@cns.nl>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Corrupted metadata. 'btrfs check' fails repair due to an assertion
 failure: '!(root->ref_cows && trans->transid != root->last_trans)'
Date: Mon, 22 Sep 2014 19:43:06 +0000
Message-ID: <713DF78A-267D-4430-A6B2-61AB743B0014@cns.nl>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Also filed on bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=85011

My log files are spammed with these messages until the drive is full:
Sep 22 21:27:38 nasbak kernel: [ 1911.486180] BTRFS critical (device sdg): corrupt leaf, bad key order: block=13415158087680,root=1, slot=7
Sep 22 21:27:38 nasbak kernel: [ 1911.487179] BTRFS critical (device sdg): corrupt leaf, bad key order: block=13415158087680,root=1, slot=7
Sep 22 21:27:38 nasbak kernel: [ 1911.488334] BTRFS critical (device sdg): corrupt leaf, bad key order: block=13415158087680,root=1, slot=7
Sep 22 21:27:38 nasbak kernel: [ 1911.489497] BTRFS critical (device sdg): corrupt leaf, bad key order: block=13415158087680,root=1, slot=7
Sep 22 21:27:38 nasbak kernel: [ 1911.490512] BTRFS critical (device sdg): corrupt leaf, bad key order: block=13415158087680,root=1, slot=7
Sep 22 21:27:38 nasbak kernel: [ 1911.491551] BTRFS critical (device sdg): corrupt leaf, bad key order: block=13415158087680,root=1, slot=7
Sep 22 21:27:38 nasbak kernel: [ 1911.492557] BTRFS critical (device sdg): corrupt leaf, bad key order: block=13415158087680,root=1, slot=7

Memory cards have been tested for 72hours with no problems to be found. Visiting the IRC channel learned me that I have corrupted meta data, which should be fixed by 'btrfs check'. Unfortunately 'btrfs check' stops due to an assertion failure:

# btrfs check --repair /dev/sdh
enabling repair mode
Checking filesystem on /dev/sdh
UUID: 20ccaf09-54ea-486e-9495-9dc91b933e9c
checking extents
bad key ordering 7 8
btrfs: ctree.c:267: __btrfs_cow_block: Assertion '!(root->ref_cows && trans->transid != root->last_trans)' failed.

I'm also unable to provide an image due to another assertion failure:

# btrfs-image -c9 -t4 /dev/sdh btrfs-image
btrfs-image: disk-io.c:155: readahead_tree_block: Assertion `!(ret)' failed.

I'm using the latest tools and latest stable kernel:

# uname -a
Linux computername 3.16.2-031602-generic #201409052035 SMP Sat Sep 6 00:36:44 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
# btrfs --version
Btrfs v3.16

Other relevant information:

# cat /etc/fstab
UUID=f6162bfd-f793-4541-828c-be31550e0271 /               ext4    discard,noatime,errors=remount-ro 0       1
UUID=20ccaf09-54ea-486e-9495-9dc91b933e9c /home           btrfs   defaults,subvol=home                                       0       0
# sudo mount /home/
# dmesg
[  414.659393] BTRFS info (device sdh): disk space caching is enabled
[  700.423512] init: smbd main process (1006) killed by TERM signal
[  738.454018] BTRFS info (device sdh): disk space caching is enabled
[  739.318381] BTRFS: bdev /dev/sde errs: wr 0, rd 0, flush 0, corrupt 6, gen 0
[  739.318389] BTRFS: bdev /dev/sdd errs: wr 0, rd 0, flush 0, corrupt 6, gen 0
[  739.318393] BTRFS: bdev /dev/sdb errs: wr 0, rd 0, flush 0, corrupt 16, gen 0
[  739.318397] BTRFS: bdev /dev/sda errs: wr 0, rd 0, flush 0, corrupt 24, gen 0
# btrfs fi show
Label: 'btrfs_storage_2'  uuid: 20ccaf09-54ea-486e-9495-9dc91b933e9c
	Total devices 6 FS bytes used 5.08TiB
	devid    1 size 2.73TiB used 2.73TiB path /dev/sdb
	devid    2 size 2.73TiB used 2.73TiB path /dev/sda
	devid    3 size 1.82TiB used 1.82TiB path /dev/sdd
	devid    4 size 1.82TiB used 1.82TiB path /dev/sde
	devid    6 size 2.73TiB used 2.73TiB path /dev/sdg
	devid    7 size 2.73TiB used 2.73TiB path /dev/sdh
# btrfs fi df /home
Data, RAID10: total=7.27TiB, used=5.07TiB
System, RAID10: total=64.00MiB, used=1.14MiB
Metadata, RAID10: total=8.12GiB, used=6.90GiB
unknown, single: total=512.00MiB, used=0.00

Attached you'll find the output of the command: '# btrfs-debug-tree -b 13415158087680 /dev/sdh'

I'm now locked into a situation where my filesystem is buggy(locking up), slow and logfiles are continuously filled. There is no way out because btrfs doesn't allow me to delete the files in the affected block or fix the metadata corruption. I'd very much appreciate a patch for btrfs check, or perhaps a workaround which allows me to get rid of the block. I'm very willing to help debug the issue further.

Thanks for your time.
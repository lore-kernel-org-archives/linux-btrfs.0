Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52577 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885AbaEPKl2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 06:41:28 -0400
From: "Cornea, Alexandru" <alexandru.cornea@intel.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: "Maxim, Costel" <costel.maxim@intel.com>
Subject: BTRFS crash
Date: Fri, 16 May 2014 10:40:02 +0000
Message-ID: <66113B714EAB624BABB47E2DDD1ED3BF337844F7@IRSMSX106.ger.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all, 
   I ran a modified version of the file system fuzzer (https://github.com/sughodke/fsfuzzer) for one of the projects I am working, and at one point I got a possible crash.
   I got the following trace on a device with a 32bit kernel 3.14. I have searched the Bugzilla for this issue, but I was unable to find it.

   I am unsure of the impact/severity of the issue, and since I do not have experience with BTRFS I was hoping someone from here can take a look at it.

Some information:

# uname -a 
Linux *** 3.14.0-*** SMP PREEMPT Mon May 12 09:06:16 PDT 2014 i686 GNU/Linux
# btrfs --version 
Btrfs v3.12

   Call trace below. If you need additional info, please let me know, and I will be glad to provide it to you, if possible.

Regards, 
   Alexandru Cornea

[  227.576593] Call Trace:
[  227.581217]  [<c20ffbf3>] ? mempool_alloc_slab+0x13/0x20
[  227.585840]  [<c21730cd>] ? bvec_alloc+0x4d/0xe0
[  227.590355]  [<c21732cc>] ? bio_alloc_bioset+0x16c/0x230
[  227.594787]  [<c228a9ac>] ? submit_extent_page.isra.36+0xec/0x1e0
[  227.599242]  [<c22980f2>] btrfs_map_bio+0x82/0x510
[  227.603701]  [<c228ae1b>] ? __do_readpage+0x37b/0x870
[  227.608082]  [<c228c3c0>] ? repair_eb_io_failure+0x110/0x110
[  227.612393]  [<c2260f80>] ? free_root_pointers+0x50/0x50
[  227.616708]  [<c22627f5>] ? btrfs_bio_wq_end_io+0x25/0x60
[  227.620950]  [<c22629ea>] btree_submit_bio_hook+0x5a/0x100
[  227.625119]  [<c2262990>] ? btrfs_wq_submit_bio+0x140/0x140
[  227.629272]  [<c2286970>] submit_one_bio+0x80/0xb0
[  227.633391]  [<c2262990>] ? btrfs_wq_submit_bio+0x140/0x140
[  227.637527]  [<c228efd8>] read_extent_buffer_pages+0x218/0x2e0
[  227.641609]  [<c2262008>] btree_read_extent_buffer_pages.constprop.49+0xc8/0x140
[  227.645683]  [<c2260f80>] ? free_root_pointers+0x50/0x50
[  227.649761]  [<c2262d0c>] read_tree_block+0x3c/0x60
[  227.653732]  [<c2266c0c>] open_ctree+0x11bc/0x1e00
[  227.657599]  [<c2337043>] ? strlcpy+0x33/0x50
[  227.661461]  [<c223e3b8>] btrfs_mount+0x678/0x840
[  227.665240]  [<c23314b6>] ? ida_get_new_above+0x1a6/0x200
[  227.668954]  [<c23314b6>] ? ida_get_new_above+0x1a6/0x200
[  227.672622]  [<c215d1b9>] ? alloc_vfsmnt+0x99/0x160
[  227.676292]  [<c2145b01>] mount_fs+0x31/0x170
[  227.679890]  [<c211950f>] ? __alloc_percpu+0xf/0x20
[  227.683432]  [<c215d1d3>] ? alloc_vfsmnt+0xb3/0x160
[  227.686950]  [<c215d309>] vfs_kern_mount+0x49/0xd0
[  227.690427]  [<c215f480>] do_mount+0x1e0/0x8e0
[  227.693884]  [<c2114699>] ? strndup_user+0x39/0xd0
[  227.697282]  [<c215fe1c>] SyS_mount+0x7c/0xb0
[  227.700612]  [<c27e4860>] syscall_call+0x7/0xb
[  227.703910] Code: e8 07 83 e0 02 29 c3 0f af 5d c8 8b 45 e0 8b 55 e4 85 d2 89 45 a4 c7 45 ac 00 00 00 00 74 5
[  227.711334] EIP: [<c22929c3>] __btrfs_map_block+0x1b3/0x13d0 SS:ESP 0068:c4a49b1c
[  227.714805] ---[ end trace 878405379da34309 ]---

---
Regards,

Alexandru Cornea
QA Security Engineer
SSG OTC Romania
Desk: +40 31 845 1150
iNET: 88451150


---
Regards,

Alexandru Cornea
QA Security Engineer
SSG OTC Romania
Desk: +40 31 845 1150
iNET: 88451150


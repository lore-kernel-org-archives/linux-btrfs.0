Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C78C00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 08:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8255C2084D
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 08:59:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MMIVrc69"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8255C2084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbeJEP4w (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:56:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59528 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728596AbeJEP4w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 11:56:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w958n44p176038;
        Fri, 5 Oct 2018 08:58:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=0S1Q3U9PYmvUtwaXU2L0M4qXUer7zehSKnK8Wu33Ylo=;
 b=MMIVrc6918D65IHyWLXBB9JCq1pcohb3SNcUHg6MWnl9NY0t7aGjYmS4OjKBXZakJ4G1
 DsUtSQecWsm7vSJCEb+JP1ExyBnMj76WR9ojo514UzFBZx/9Vgo9B+ZKPetSGnfuhG60
 TWEzGKyQKlage/DUoSzxjjx/iOViwry4bYhI5+DJWuHmjPPNFAzOYy2u4bO3hlUYQDlp
 a5kQkpeSzxLfVO7k1CgNUEvKWMT/mwsYFon7S2e3HQzuoR7WieLN3IcKfJ8zgnt4ogyp
 d083EJIpTdfhZZSnhKv80w2g4tYKIBBQq+CYalVQwscfxuo/4vj4q3FrFLZVZ27RNnsb GQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2mt21rhaj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Oct 2018 08:58:59 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w958ww5R028345
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Oct 2018 08:58:58 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w958wvlL023179;
        Fri, 5 Oct 2018 08:58:58 GMT
Received: from [10.186.50.4] (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Oct 2018 08:58:57 +0000
Subject: Re: [PATCH 00/11] Cleanup dev-replace locking
To:     dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1536331604.git.dsterba@suse.com>
 <20180927110646.GP3255@twin.jikos.cz>
 <91a85e18-161f-5da0-825e-0468867af3f4@oracle.com>
 <20181004101355.GB29418@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <156b6d1d-2cd5-6844-96b6-266702471ccf@oracle.com>
Date:   Fri, 5 Oct 2018 16:58:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181004101355.GB29418@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9036 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810050092
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



>> I do observer btrfs/011 taking longer time to complete (200sec more) and
>> Null pointer dereference even without this patch set,


>> tracing back lead
>> to conclusion, that

Ah. My trace back was for the circular lock dependency warning which I 
reported here: Subject: btrfs/011 possible circular locking dependency 
detected. Which is just a warning. If possible we could fix it. But 
dereference is something we should try harder. Null deference doesn't 
happen consistently here, I couldn't capture the stack trace.

> I'm rarely observing a crash in 011, stacktrace attached,

  Yep rarely. Thanks for the stacktrace.

Per the stack trace..

replace started..

[1]
[  738.344228] BTRFS info (device vdb): dev_replace from /dev/vdb (devid 
1) to /dev/vdc started
[  739.585174] WARNING: CPU: 3 PID: 20788 at fs/btrfs/scrub.c:620 
scrub_setup_ctx.isra.19+0x20c/0x210 [btrfs]

The replace was canceled 'before' (as below) the scrub_setup_ctx() was 
able to init with the replace target missing warning.

-------------------
  .. scrub_setup_ctx(..)
  573 {
::
  619         if (is_dev_replace) {
  620                 WARN_ON(!fs_info->dev_replace.tgtdev);
::
-------------------



[2]
[  740.471443] BTRFS info (device vdb): dev_replace from /dev/vdb (devid 
1) to /dev/vdc canceled

As scrub_setup_ctx() was able to init scrub successfully with a warning 
as above


[3]

[  740.614161] BUG: unable to handle kernel NULL pointer dereference at 
00000000000000b0
[  740.629983] Workqueue: btrfs-scrub btrfs_scrub_helper [btrfs]
[  740.631239] RIP: 0010:scrub_write_page_to_dev_replace+0x86/0x2d0 [btrfs]
[  740.650709]  scrub_write_block_to_dev_replace+0x3b/0x60 [btrfs]

We try to do bio to the target which is gone.


I can reproduce with [4] (sorry for the very rudimentary diff)
(without this patch-set.).

[4]
----------------------
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index dec01970d8c5..767cc380d08e 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -20,6 +20,9 @@
  #include "rcu-string.h"
  #include "dev-replace.h"
  #include "sysfs.h"
+#include <linux/delay.h>
+
+bool replace_cancel_done = false;

  static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
                                        int scrub_ret);
@@ -488,6 +491,11 @@ int btrfs_dev_replace_start(struct btrfs_fs_info 
*fs_info,
         ret = btrfs_commit_transaction(trans);
         WARN_ON(ret);

+       while(replace_cancel_done == false) {
+               msleep(1000);
+       }
+       replace_cancel_done = false;
+
         /* the disk copy procedure reuses the scrub code */
         ret = btrfs_scrub_dev(fs_info, src_device->devid, 0,
                               btrfs_device_get_total_bytes(src_device),
@@ -829,6 +837,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info 
*fs_info)
         if (tgt_device)
                 btrfs_destroy_dev_replace_tgtdev(tgt_device);

+       replace_cancel_done = true;
  leave:
         mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
         return result;
----------------------

Run:
mkfs.btrfs -qf /dev/sdb && mount /dev/sdb /btrfs
btrfs replace start -B 1 /dev/sdc /btrfs
from another terminal
btrfs replace cancel /btrfs

And we see the panic [5] which is same as yours.

The reason is the replace write lock does not encapsulate the scrub 
init, but if you do it now how to support cancel.

Fix is WIP. Thanks, Anand


[5]
-----------------------------------------------
[22304.655493] BTRFS info (device sdb): dev_replace from /dev/sdb (devid 
1) to /dev/sdc started
[22343.645654] BTRFS info (device sdb): dev_replace from /dev/sdb (devid 
1) to /dev/sdc canceled
[22344.226987] WARNING: CPU: 0 PID: 7128 at fs/btrfs/scrub.c:620 
scrub_setup_ctx.isra.19+0x220/0x230 [btrfs]
[22344.226999] Modules linked in: btrfs xor zstd_decompress 
zstd_compress xxhash raid6_pq iptable_nat nf_nat_ipv4 nf_nat [last 
unloaded: xor]
[22344.227026] CPU: 0 PID: 7128 Comm: btrfs Not tainted 4.19.0-rc6+ #9
[22344.227029] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS 
VirtualBox 12/01/2006
[22344.227045] RIP: 0010:scrub_setup_ctx.isra.19+0x220/0x230 [btrfs]
[22344.227048] Code: 00 00 49 8b 86 30 1e 00 00 5b 5d 49 89 84 24 50 03 
00 00 41 c6 84 24 58 03 00 00 00 4c 89 e0 41 5c 41 5d 41 5e c3 0f 0b eb 
8f <0f> 0b eb c8 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41
[22344.227051] RSP: 0018:ffffadc3c0633c48 EFLAGS: 00010246
[22344.227054] RAX: ffff99e978bab800 RBX: 000000000000003f RCX: 
0000000000000001
[22344.227057] RDX: 0000000000000000 RSI: 000000000015b000 RDI: 
0000000000000000
[22344.227059] RBP: ffff99e978bab9f8 R08: 0000000000000066 R09: 
ffff99e97013dc00
[22344.227061] R10: 0000000000000001 R11: 00000000fcf2000b R12: 
ffff99e978bab800
[22344.227064] R13: 0000000000000001 R14: ffff99e9734d0000 R15: 
0000000000000000
[22344.227067] FS:  00007f5f281a98c0(0000) GS:ffff99e97da00000(0000) 
knlGS:0000000000000000
[22344.227069] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[22344.227073] CR2: 000055ca99e26f30 CR3: 0000000078a38000 CR4: 
00000000000406f0
[22344.227075] Call Trace:
[22344.227092]  btrfs_scrub_dev+0x19b/0x5b0 [btrfs]
[22344.227110]  btrfs_dev_replace_start+0x564/0x6a0 [btrfs]
[22344.227126]  btrfs_dev_replace_by_ioctl+0x3a/0x60 [btrfs]
[22344.227140]  btrfs_ioctl+0x201b/0x2ce0 [btrfs]
[22344.227151]  ? find_held_lock+0x2d/0x90
[22344.227161]  do_vfs_ioctl+0xa9/0x6c0
[22344.227165]  ? lockdep_hardirqs_on+0xed/0x1a0
[22344.227171]  ksys_ioctl+0x60/0x90
[22344.227176]  __x64_sys_ioctl+0x16/0x20
[22344.227179]  do_syscall_64+0x50/0x180
[22344.227187]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[22344.227190] RIP: 0033:0x7f5f26fa7567
[22344.227194] Code: 44 00 00 48 8b 05 29 09 2d 00 64 c7 00 26 00 00 00 
48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d f9 08 2d 00 f7 d8 64 89 01 48
[22344.227196] RSP: 002b:00007fff72353c08 EFLAGS: 00000202 ORIG_RAX: 
0000000000000010
[22344.227200] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 
00007f5f26fa7567
[22344.227202] RDX: 00007fff72354a80 RSI: 00000000ca289435 RDI: 
0000000000000003
[22344.227204] RBP: 0000000000000001 R08: 0000000000000000 R09: 
00007fff72353b60
[22344.227206] R10: 0000000000000008 R11: 0000000000000202 R12: 
0000000000000001
[22344.227208] R13: 0000000000000000 R14: 0000000000000003 R15: 
00000000024f4050
[22344.227222] irq event stamp: 43742
[22344.227227] hardirqs last  enabled at (43741): [<ffffffffa0a9518c>] 
__slab_alloc+0x52/0x61
[22344.227231] hardirqs last disabled at (43742): [<ffffffffa0801ad7>] 
trace_hardirqs_off_thunk+0x1a/0x1c
[22344.227234] softirqs last  enabled at (43244): [<ffffffffa180031c>] 
__do_softirq+0x31c/0x3a6
[22344.227238] softirqs last disabled at (43233): [<ffffffffa08e11d2>] 
irq_exit+0xb2/0xc0
[22344.227240] ---[ end trace 98bfe3316ee3a52a ]---
[22344.232735] BUG: unable to handle kernel NULL pointer dereference at 
00000000000000a0
[22344.233165] PGD 0 P4D 0
[22344.233409] Oops: 0000 [#1] SMP PTI
[22344.233641] CPU: 1 PID: 1091 Comm: kworker/u4:5 Tainted: G        W 
       4.19.0-rc6+ #9
[22344.234036] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS 
VirtualBox 12/01/2006
[22344.234429] Workqueue: btrfs-scrub btrfs_scrub_helper [btrfs]
[22344.234757] RIP: 0010:scrub_write_page_to_dev_replace+0xb4/0x260 [btrfs]
[22344.235149] Code: 43 28 48 8b 85 50 03 00 00 48 89 43 10 48 8b 43 18 
48 85 c0 0f 84 20 01 00 00 48 89 58 50 48 c7 40 48 30 ee 1c c0 48 8b 53 
10 <48> 8b 92 a0 00 00 00 48 8b 92 e0 00 00 00 48 39 50 08 74 18 66 81
[22344.236053] RSP: 0018:ffffadc3c0c27d20 EFLAGS: 00010246
[22344.236355] RAX: ffff99e97a65cd00 RBX: ffff99e97c197400 RCX: 
0000000000000000
[22344.236707] RDX: 0000000000000000 RSI: ffff99e97a65cd00 RDI: 
ffff99e97a65cd00
[22344.237085] RBP: ffff99e978bab800 R08: 0000000000027970 R09: 
ffff99e97c197400
[22344.237424] R10: ffffffffa16001ff R11: 0000000000000000 R12: 
ffff99e978e12680
[22344.237780] R13: ffff99e978babac8 R14: 0000000000000000 R15: 
ffff99e978513838
[22344.238135] FS:  0000000000000000(0000) GS:ffff99e97db00000(0000) 
knlGS:0000000000000000
[22344.238629] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[22344.239043] CR2: 00000000000000a0 CR3: 0000000078ca4000 CR4: 
00000000000406e0
[22344.239516] Call Trace:
[22344.239886]  scrub_write_block_to_dev_replace+0x3f/0x60 [btrfs]
[22344.240305]  scrub_bio_end_io_worker+0x1af/0x490 [btrfs]
[22344.240777]  normal_work_helper+0xf0/0x4c0 [btrfs]
[22344.241201]  process_one_work+0x1f4/0x520
[22344.241792]  ? process_one_work+0x16e/0x520
[22344.242106]  worker_thread+0x46/0x3d0
[22344.242270]  kthread+0xf8/0x130
[22344.242530]  ? process_one_work+0x520/0x520
[22344.242824]  ? kthread_delayed_work_timer_fn+0x80/0x80
[22344.243138]  ret_from_fork+0x3a/0x50
[22344.243418] Modules linked in: btrfs xor zstd_decompress 
zstd_compress xxhash raid6_pq iptable_nat nf_nat_ipv4 nf_nat [last 
unloaded: xor]
[22344.244014] CR2: 00000000000000a0
[22344.244266] ---[ end trace 98bfe3316ee3a52b ]---

Return-Path: <SRS0=JEJz=MP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5724CC00449
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Oct 2018 15:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15B182089F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Oct 2018 15:23:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="3CDW2eVa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15B182089F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbeJCWMY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Oct 2018 18:12:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60910 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbeJCWMY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2018 18:12:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w93FGLmZ134241
        for <linux-btrfs@vger.kernel.org>; Wed, 3 Oct 2018 15:23:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=XsmXGIJpd2kMMdW2+3v6fihUxDZg4OkdLIcNeonGZHI=;
 b=3CDW2eVaWInZPXkLgEK0GoAuOEDlO3SjBgWUsBDhDs52KDLKhmmrZn+fH9Ng32l1+AmV
 P/l8SKaoHqAuNKIAEkMuSbzrMcPmiGrXNPFFiUVq7Qmt/b1yENVXsnc85vsd4c8WxqLo
 5eRBIumEZDUBPw6AOKndslUKEyL2xwd2rDjYz5eOeEa7EhWnG4w+raCeHed0VnUV30Sq
 y44hCZ+y556YuKFktsiV2CKaAH+/4FCnef2M7jJFmwoOcC2oP5m3/3brAwgr2HH//gO0
 z+JCEX2s9skNNv0f+PN10A1AEkBXDskSKDPPRpTFumHE0jhTJYzTiyBLWg69UVFe+bqV YA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2mt0ttvrm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2018 15:23:31 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w93FNVkX022660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 3 Oct 2018 15:23:31 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w93FNVXg024785
        for <linux-btrfs@vger.kernel.org>; Wed, 3 Oct 2018 15:23:31 GMT
Received: from [192.168.0.120] (/202.156.138.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Oct 2018 15:23:31 +0000
From:   Anand Jain <anand.jain@oracle.com>
Subject: btrfs/011 possible circular locking dependency detected
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <ea106e12-4658-5a22-bf10-a4cc7f6f7d26@oracle.com>
Date:   Wed, 3 Oct 2018 23:23:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9035 signatures=668707
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810030146
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


btrfs/011 generates possible circular locking dependency warning [1] on 
the latest 4.19-rc3, tracing back leads to

1c542f38ab8d mm: Introduce kvcalloc()

[1]
-----------------------------------------------------------
[  233.710021] ======================================================
[  233.710303] WARNING: possible circular locking dependency detected
[  233.710574] 4.17.0+ #4 Not tainted
[  233.710757] ------------------------------------------------------
[  233.711006] kswapd0/749 is trying to acquire lock:
[  233.711244] 00000000e4661f1f (&delayed_node->mutex){+.+.}, at: 
__btrfs_release_delayed_node+0x3a/0x210 [btrfs]
[  233.711628]
but task is already holding lock:
[  233.711869] 0000000046873fcd (fs_reclaim){+.+.}, at: 
__fs_reclaim_acquire+0x5/0x40
[  233.712906]
which lock already depends on the new lock.

[  233.713055]
the existing dependency chain (in reverse order) is:
[  233.713886]
-> #3 (fs_reclaim){+.+.}:
[  233.714080]        kmem_cache_alloc+0x29/0x240
[  233.714414]        btrfs_alloc_inode+0x24/0x260 [btrfs]
[  233.715212]        alloc_inode+0x1b/0x90
[  233.716085]        new_inode_pseudo+0xc/0x60
[  233.716503]        new_inode+0x12/0x30
[  233.719126]        iget5_locked+0x44/0x80
[  233.719605]        btrfs_iget+0x60/0x6e0 [btrfs]
[  233.720109]        __lookup_free_space_inode+0x102/0x160 [btrfs]
[  233.720543]        lookup_free_space_inode+0x63/0xe0 [btrfs]
[  233.720885]        load_free_space_cache+0x68/0x190 [btrfs]
[  233.721167]        cache_block_group+0x1d1/0x460 [btrfs]
[  233.721490]        find_free_extent+0x10bd/0x1460 [btrfs]
[  233.721824]        btrfs_reserve_extent+0xf6/0x190 [btrfs]
[  233.722150]        btrfs_alloc_tree_block+0x13e/0x520 [btrfs]
[  233.722483]        __btrfs_cow_block+0x128/0x5e0 [btrfs]
[  233.722807]        btrfs_cow_block+0xe9/0x260 [btrfs]
[  233.723074]        commit_cowonly_roots+0x55/0x2b0 [btrfs]
[  233.723413]        btrfs_commit_transaction+0x3b4/0xa20 [btrfs]
[  233.723760]        close_ctree+0x2b1/0x310 [btrfs]
[  233.724059]        generic_shutdown_super+0x67/0x110
[  233.724361]        kill_anon_super+0xe/0x20
[  233.724663]        btrfs_kill_super+0x13/0x100 [btrfs]
[  233.724973]        deactivate_locked_super+0x3a/0x70
[  233.725289]        cleanup_mnt+0x3b/0x70
[  233.725568]        task_work_run+0x89/0xa0
[  233.725850]        exit_to_usermode_loop+0x64/0x9c
[  233.726151]        do_syscall_64+0x12d/0x180
[  233.726438]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  233.726756]
-> #2 (&caching_ctl->mutex){+.+.}:
[  233.727169]        cache_block_group+0x1c6/0x460 [btrfs]
[  233.727455]        find_free_extent+0x10bd/0x1460 [btrfs]
[  233.727757]        btrfs_reserve_extent+0xf6/0x190 [btrfs]
[  233.728370]        btrfs_alloc_tree_block+0x13e/0x520 [btrfs]
[  233.728850]        __btrfs_cow_block+0x128/0x5e0 [btrfs]
[  233.729364]        btrfs_cow_block+0xe9/0x260 [btrfs]
[  233.729774]        btrfs_search_slot+0x1ff/0x9d0 [btrfs]
[  233.732271]        btrfs_insert_empty_items+0x5e/0xb0 [btrfs]
[  233.732736]        btrfs_uuid_tree_add+0x1b6/0x2e0 [btrfs]
[  233.733089]        btrfs_uuid_scan_kthread+0x198/0x330 [btrfs]
[  233.733418]        kthread+0xf8/0x130
[  233.733698]        ret_from_fork+0x3a/0x50
[  233.733971]
-> #1 (&space_info->groups_sem){++++}:
[  233.734429]        find_free_extent+0xdac/0x1460 [btrfs]
[  233.734756]        btrfs_reserve_extent+0xf6/0x190 [btrfs]
[  233.735129]        btrfs_alloc_tree_block+0x13e/0x520 [btrfs]
[  233.735465]        split_leaf+0x234/0x6f0 [btrfs]
[  233.735807]        btrfs_search_slot+0x95d/0x9d0 [btrfs]
[  233.736111]        btrfs_insert_empty_items+0x5e/0xb0 [btrfs]
[  233.736440]        btrfs_insert_delayed_items+0x98/0x450 [btrfs]
[  233.736755]        btrfs_async_run_delayed_root+0xed/0x200 [btrfs]
[  233.737121]        normal_work_helper+0x1bd/0x5e0 [btrfs]
[  233.737492]        process_one_work+0x1f4/0x5b0
[  233.737788]        worker_thread+0x46/0x3d0
[  233.738041]        kthread+0xf8/0x130
[  233.738333]        ret_from_fork+0x3a/0x50
[  233.738629]
-> #0 (&delayed_node->mutex){+.+.}:
[  233.738991]        __mutex_lock+0x6e/0x880
[  233.739281]        __btrfs_release_delayed_node+0x3a/0x210 [btrfs]
[  233.739592]        btrfs_evict_inode+0x232/0x5d0 [btrfs]
[  233.739893]        evict+0xc4/0x190
[  233.740144]        dispose_list+0x35/0x50
[  233.740395]        prune_icache_sb+0x52/0x70
[  233.740695]        super_cache_scan+0x13c/0x190
[  233.740985]        shrink_slab.part.72.constprop.93+0x19b/0x530
[  233.741372]        shrink_node+0x98/0x2e0
[  233.741619]        balance_pgdat+0x167/0x320
[  233.741896]        kswapd+0x189/0x560
[  233.742149]        kthread+0xf8/0x130
[  233.742422]        ret_from_fork+0x3a/0x50
[  233.742670]
other info that might help us debug this:

[  233.743146] Chain exists of:
   &delayed_node->mutex --> &caching_ctl->mutex --> fs_reclaim

[  233.743777]  Possible unsafe locking scenario:

[  233.744837]        CPU0                    CPU1
[  233.745357]        ----                    ----
[  233.745656]   lock(fs_reclaim);
[  233.745883]                                lock(&caching_ctl->mutex);
[  233.746831]                                lock(fs_reclaim);
[  233.747472]   lock(&delayed_node->mutex);
[  233.747780]
  *** DEADLOCK ***

[  233.748382] 3 locks held by kswapd0/749:
[  233.748737]  #0: 0000000046873fcd (fs_reclaim){+.+.}, at: 
__fs_reclaim_acquire+0x5/0x40
[  233.750004]  #1: 00000000cdfa74b4 (shrinker_rwsem){++++}, at: 
shrink_slab.part.72.constprop.93+0x3b/0x530
[  233.750496]  #2: 00000000567f3106 (&type->s_umount_key#47){++++}, at: 
trylock_super+0x16/0x50
[  233.750939]
stack backtrace:
[  233.751270] CPU: 0 PID: 749 Comm: kswapd0 Not tainted 4.17.0+ #4
[  233.751560] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS 
VirtualBox 12/01/2006
[  233.751973] Call Trace:
[  233.752233]  dump_stack+0x5e/0x8b
[  233.752520]  print_circular_bug.isra.38+0x1f1/0x1fe
[  233.752831]  __lock_acquire+0x148c/0x1760
[  233.753108]  ? ret_from_fork+0x3a/0x50
[  233.753394]  lock_acquire+0xb0/0x1d0
[  233.753696]  ? __btrfs_release_delayed_node+0x3a/0x210 [btrfs]
[  233.754073]  ? __btrfs_release_delayed_node+0x3a/0x210 [btrfs]
[  233.754407]  __mutex_lock+0x6e/0x880
[  233.754738]  ? __btrfs_release_delayed_node+0x3a/0x210 [btrfs]
[  233.755944]  ? __lock_acquire+0xf37/0x1760
[  233.756282]  ? __btrfs_release_delayed_node+0x3a/0x210 [btrfs]
[  233.756608]  ? find_held_lock+0x31/0xa0
[  233.758274]  ? btrfs_evict_inode+0x1fc/0x5d0 [btrfs]
[  233.759134]  __btrfs_release_delayed_node+0x3a/0x210 [btrfs]
[  233.759471]  btrfs_evict_inode+0x232/0x5d0 [btrfs]
[  233.759803]  ? evict+0xae/0x190
[  233.760076]  evict+0xc4/0x190
[  233.760334]  dispose_list+0x35/0x50
[  233.760716]  prune_icache_sb+0x52/0x70
[  233.761071]  super_cache_scan+0x13c/0x190
[  233.761335]  shrink_slab.part.72.constprop.93+0x19b/0x530
[  233.761642]  shrink_node+0x98/0x2e0
[  233.761909]  balance_pgdat+0x167/0x320
[  233.762167]  kswapd+0x189/0x560
[  233.762397]  ? wait_woken+0x80/0x80
[  233.762700]  kthread+0xf8/0x130
[  233.762938]  ? balance_pgdat+0x320/0x320
[  233.763225]  ? kthread_delayed_work_timer_fn+0x80/0x80
[  233.763566]  ret_from_fork+0x3a/0x50

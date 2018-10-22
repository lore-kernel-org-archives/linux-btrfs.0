Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D96F6C67863
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 10:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94AD020658
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 10:07:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lixom-net.20150623.gappssmtp.com header.i=@lixom-net.20150623.gappssmtp.com header.b="vx11KiBd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94AD020658
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lixom.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbeJVSZ3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 14:25:29 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38443 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbeJVSZ3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 14:25:29 -0400
Received: by mail-lf1-f67.google.com with SMTP id x24-v6so14132089lfe.5
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2018 03:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lixom-net.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=J0Nt60z36qkmJKMW5DkNsNnMWtu5J23yBIOBws9SUK0=;
        b=vx11KiBdGTN5RdOL6VQQp2Yc1uol3gxKT/iCIl6JKNup3cqN859dd+xptnQ244TUiu
         Z1U7GzbK0Kpcj5XsMNMlYvl8F8jxyngrFwcESOLV5jBbXAjCNNbkz+kC7QikYGKjNtal
         MND06BmgE0LAr2dImWWKuaj09tYYJV+QE6UwHDDupNLmWHLgc9aQ3yTLkTsYJUWkBaje
         eHRl0iIOPYDjMKj3QS5AxjsFzyrdGa+Gtb8MvxVYPpBUHhHwOBsRt6nsuOPDa37cOSES
         sguc3fiu+P781W4iJ04Pu59SgnBsV/il8hziXfmmDt3iqDmutQttohGi9QjtsNRt67AD
         Re8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=J0Nt60z36qkmJKMW5DkNsNnMWtu5J23yBIOBws9SUK0=;
        b=W3Zl33W3jCLEFfZjmkD8PqJTFxI+NTKDznrlRYl6ep0qA2QuGM/yuUrQf9F7CbKT2w
         yffQTvM1jZdovsWdEDQ8ChffP/AoJtkvOMNLDiFClUjAzDcSeKF9OO9JeYiWUN18NvHt
         8Xn6kO//ctjyUmFEgB3hIUlU1XqP5WFAK1r1vCcob0WZJsXusy1OSzUJTInLP3DP1wuL
         lr/l4l6v0Nh3N9mh3Uor7BhZSHQJtTYEkWqKw3+AkjbGbhSaHyJ7tkelY1a2mCKxvd91
         z1U5ClEzQh7do6KNbcHXTSUwrmjmqMx1d7G2VO7u+qxDBZAr6BeR1dQ1npbl5xGf+Ijf
         BAMg==
X-Gm-Message-State: ABuFfogleVvqukpfGXUc2MKRvc2kz8GbxfhRXPRgxC1ULRmyaDgJTesG
        EVqhoqcItBDGlM39IFIx/Z47Kw==
X-Google-Smtp-Source: ACcGV60n9Jk74TXQIK/5PMdF5l1D5cXSQ5R0loREoSUpzQ0ZAgJjpeMRKIXPT1I5kPUbh2AsRasyxg==
X-Received: by 2002:a19:f20:: with SMTP id e32mr9271713lfi.51.1540202855187;
        Mon, 22 Oct 2018 03:07:35 -0700 (PDT)
Received: from localhost ([85.30.9.151])
        by smtp.gmail.com with ESMTPSA id m3-v6sm2421016lfc.55.2018.10.22.03.07.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Oct 2018 03:07:33 -0700 (PDT)
Date:   Mon, 22 Oct 2018 03:07:26 -0700
From:   Olof Johansson <olof@lixom.net>
To:     dsterba@suse.de
Cc:     olof@lixom.net, linux-btrfs@vger.kernel.org, clm@fb.com,
        linux-kernel@vger.kernel.org
Subject: Circular lock dep in btrfs triggered by shrinker
Message-ID: <20181022100726.5hwvc5xswg3k3a2f@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

I hit the below circular locking dependency. Seems like the assumption made in
712e36c5f2a7fa56 ("btrfs: use GFP_KERNEL in btrfs_alloc_inode") either isn't
true, or has since changed?


======================================================
WARNING: possible circular locking dependency detected
4.19.0 #25 Not tainted
------------------------------------------------------
kswapd0/414 is trying to acquire lock:
000000008b8f1971 (&delayed_node->mutex){+.+.}, at: __btrfs_release_delayed_node+0x35/0x1e0
but task is already holding lock:
00000000032f657e (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x0/0x30
which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:
-> #3 (fs_reclaim){+.+.}:
       kmem_cache_alloc+0x24/0x270
       btrfs_alloc_inode+0x1f/0x260
       alloc_inode+0x13/0x80
       iget5_locked+0x3f/0x80
       btrfs_iget+0x52/0x680
       __lookup_free_space_inode+0xd9/0x110
       lookup_free_space_inode+0x5e/0xd0
       load_free_space_cache+0x63/0x190
       cache_block_group+0x1b7/0x3e0
       find_free_extent+0x747/0x12d0
       btrfs_reserve_extent+0x96/0x170
       btrfs_alloc_tree_block+0xf6/0x540
       __btrfs_cow_block+0x110/0x4e0
       btrfs_cow_block+0xd3/0x1f0
       btrfs_search_slot+0x20d/0x9c0
       btrfs_insert_empty_items+0x62/0xb0
       btrfs_new_inode+0x1d3/0x6f0
       btrfs_create+0xc9/0x1c0
       lookup_open+0x69b/0x770
       path_openat+0x39b/0xbb0
       do_filp_open+0x85/0xf0
       do_sys_open+0x11f/0x1f0
       do_syscall_64+0x6b/0x230
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #2 (&caching_ctl->mutex){+.+.}:
       cache_block_group+0x1ac/0x3e0
       find_free_extent+0x747/0x12d0
       btrfs_reserve_extent+0x96/0x170
       btrfs_alloc_tree_block+0xf6/0x540
       __btrfs_cow_block+0x110/0x4e0
       btrfs_cow_block+0xd3/0x1f0
       btrfs_search_slot+0x20d/0x9c0
       btrfs_insert_empty_items+0x62/0xb0
       btrfs_new_inode+0x1d3/0x6f0
       btrfs_create+0xc9/0x1c0
       lookup_open+0x69b/0x770
       path_openat+0x39b/0xbb0
       do_filp_open+0x85/0xf0
       do_sys_open+0x11f/0x1f0
       do_syscall_64+0x6b/0x230
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #1 (&space_info->groups_sem){++++}:
       find_free_extent+0xc95/0x12d0
       btrfs_reserve_extent+0x96/0x170
       btrfs_alloc_tree_block+0xf6/0x540
       __btrfs_cow_block+0x110/0x4e0
       btrfs_cow_block+0xd3/0x1f0
       btrfs_search_slot+0x20d/0x9c0
       btrfs_lookup_inode+0x25/0x90
       __btrfs_update_delayed_inode+0x5c/0x1f0
       btrfs_commit_inode_delayed_inode+0x111/0x120
       btrfs_evict_inode+0x3d3/0x540
       evict+0xbc/0x180
       d_delete+0xb4/0xc0
       vfs_rmdir+0x10d/0x130
       do_rmdir+0x1f9/0x210
       do_syscall_64+0x6b/0x230
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

               -> #0 (&delayed_node->mutex){+.+.}:
       __mutex_lock+0x7c/0x940
       __btrfs_release_delayed_node+0x35/0x1e0
       btrfs_evict_inode+0x223/0x540
       evict+0xbc/0x180
       dispose_list+0x38/0x60
       prune_icache_sb+0x3d/0x50
       super_cache_scan+0x136/0x180
       do_shrink_slab+0x13a/0x3e0
       shrink_slab+0x20d/0x2a0
       shrink_node+0xdb/0x450
       kswapd+0x3d2/0x8b0
       kthread+0xfb/0x130
       ret_from_fork+0x24/0x30

               other info that might help us debug this:

Chain exists of:
                 &delayed_node->mutex --> &caching_ctl->mutex --> fs_reclaim

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&caching_ctl->mutex);
                               lock(fs_reclaim);
  lock(&delayed_node->mutex);

                *** DEADLOCK ***

3 locks held by kswapd0/414:
 #0: 00000000032f657e (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x0/0x30
 #1: 0000000041eb3025 (shrinker_rwsem){++++}, at: shrink_slab+0x125/0x2a0
 #2: 00000000c96e13d0 (&type->s_umount_key#23){++++}, at: trylock_super+0x11/0x50

               stack backtrace:
CPU: 38 PID: 414 Comm: kswapd0 Not tainted 4.19.0 #25
Hardware name: System manufacturer System Product Name/PRIME X399-A, BIOS 0807 08/03/2018
Call Trace:
 dump_stack+0x5f/0x8b
 print_circular_bug.isra.35+0x198/0x1f0
 __lock_acquire+0x12d5/0x16e0
 ? __lock_acquire+0x4a6/0x16e0
 ? lock_acquire+0xb4/0x1b0
 lock_acquire+0xb4/0x1b0
 ? __btrfs_release_delayed_node+0x35/0x1e0
 ? __btrfs_release_delayed_node+0x35/0x1e0
 __mutex_lock+0x7c/0x940
 ? __btrfs_release_delayed_node+0x35/0x1e0
 ? __btrfs_release_delayed_node+0x35/0x1e0
 ? lock_acquire+0xb4/0x1b0
 ? __btrfs_release_delayed_node+0x35/0x1e0
 __btrfs_release_delayed_node+0x35/0x1e0
 btrfs_evict_inode+0x223/0x540
 evict+0xbc/0x180
 dispose_list+0x38/0x60
 prune_icache_sb+0x3d/0x50
 super_cache_scan+0x136/0x180
 do_shrink_slab+0x13a/0x3e0
 shrink_slab+0x20d/0x2a0
 shrink_node+0xdb/0x450
 kswapd+0x3d2/0x8b0
 kthread+0xfb/0x130
 ? mem_cgroup_shrink_node+0x240/0x240
 ? kthread_create_worker_on_cpu+0x40/0x40
 ret_from_fork+0x24/0x30

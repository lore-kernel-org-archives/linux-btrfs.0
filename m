Return-Path: <SRS0=Q7pU=SY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48A3C10F11
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Apr 2019 20:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 815C820896
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Apr 2019 20:38:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dz3tNEuY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbfDVUiK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Apr 2019 16:38:10 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:34439 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727294AbfDVUiJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Apr 2019 16:38:09 -0400
Received: by mail-wr1-f54.google.com with SMTP id c6so11486553wrm.1
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2019 13:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=bOSisCokS1YvSFDMM9lXFu9NU0AYh5fkxk5AjrnH0R8=;
        b=dz3tNEuYTCA8GUYeQx3Nz7wpttOxJPeQFMFA9LeZDHVT/GSSkHFr2BpBm6DkjABn64
         rpVjOty/K+yASbcEFf2qt/spNzvZGcg3GJ4Y7RDr87eYOHp46OWLkoF5DfmfsGjNXrok
         5zAd825olLmBEq2OHidFry/V7lPMjlYFSE41cR+wUYGBWenNTUF1sSDGFje7ogzmOkvj
         S113RQw8t6Fhgim0OiQBz0ukFXNxLhI9L2LBNjI5ygK28+mlKyOVMXalV40alldy9Njs
         qs0Ayr1JPzLzoG2uSRb9jzSIiBzkd5dR1EoJXjxYbzWVy9rTf2+Ijje3ugrzS9CbbGc8
         4Dnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=bOSisCokS1YvSFDMM9lXFu9NU0AYh5fkxk5AjrnH0R8=;
        b=c1SBDaK9xm7liu/Oy+zS5pux6E1iI85QWxj0D459VCj01a2ZUKzOqVL1kO+haQyBL+
         86wdGsaChgzky8pBwd2wBjMzaEp3T5FCq5Kas1ZdoqJXuDQLjs1O96TPZTUAWslRYCK1
         yfJnQWfG0Ke2SLnb5uD8eGfMzFlmtpkLGq6/tZJrr7VY00nRH21fKdmtj/j9har0/1XT
         dwBZa+IQUIr16HuJz2o67cLPcenpevVs0GMCzTVcJMnUT+y8jxLEvT6MTNWCI/+bb7s5
         23jzZ29DDPnkoPIiPPPjCvkRAPeR3ZJq34CgN6Xgf03ikJpHp+GSnyZGpWXfsCrPQcU0
         zM/Q==
X-Gm-Message-State: APjAAAXRGOb9Ridnu5jC23tt+ua+fCqC1zSpHkHIbOG8qQYNFhKnfvS9
        f1OJx4RVHZN6DPT7Px/2/5YF4jEvpMdeAizUrtDh0YpL
X-Google-Smtp-Source: APXvYqwh5NOqCrIuHkuq657+ihk4a58cQfLcOyd2ijsfAR707Yj/pPrJtfPXSTwhWb2PPXAnRUzjzSqENSM/i1es2Js=
X-Received: by 2002:adf:b611:: with SMTP id f17mr484746wre.162.1555965487677;
 Mon, 22 Apr 2019 13:38:07 -0700 (PDT)
MIME-Version: 1.0
From:   Nathan Dehnel <ncdehnel@gmail.com>
Date:   Mon, 22 Apr 2019 15:37:55 -0500
Message-ID: <CAEEhgEsQD1WgqZBZ2YEsEZKKH6X6PSxZGKbMgSVrzkEjVVDFrg@mail.gmail.com>
Subject: reading/writing btrfs volume regularly freezes system
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I have a raid10 volume that frequently locks up when I try to write to
it or delete things. Any command that touches it will hang (and can't
be killed) and I have to start a new ssh session to get into the
computer again. Nothing fixes it besides a reboot, and the volume will
fail to unmount while the computer is shutting down.

[  302.360912] sysrq: SysRq : Show Blocked State
[  302.360951]   task                        PC stack   pid father
[  302.360987] btrfs-transacti D    0  2187      2 0x80000000
[  302.360993] Call Trace:
[  302.361007]  ? __schedule+0x59d/0x5f1
[  302.361012]  schedule+0x6a/0x85
[  302.361019]  btrfs_commit_transaction+0x219/0x7ac
[  302.361027]  ? wait_woken+0x6d/0x6d
[  302.361031]  transaction_kthread+0xc9/0x135
[  302.361036]  ? btrfs_cleanup_transaction+0x4c7/0x4c7
[  302.361041]  kthread+0x115/0x11d
[  302.361046]  ? kthread_park+0x76/0x76
[  302.361050]  ret_from_fork+0x35/0x40
[  302.361064] nfsd            D    0  2292      2 0x80000000
[  302.361067] Call Trace:
[  302.361072]  ? __schedule+0x59d/0x5f1
[  302.361077]  schedule+0x6a/0x85
[  302.361120]  wait_current_trans+0x9b/0xd8
[  302.361126]  ? wait_woken+0x6d/0x6d
[  302.361131]  start_transaction+0x1ae/0x38e
[  302.361135]  btrfs_create+0x59/0x1d0
[  302.361142]  vfs_create+0xbf/0xef
[  302.361160]  do_nfsd_create+0x2be/0x41d [nfsd]
[  302.361214]  nfsd4_open+0x223/0x578 [nfsd]
[  302.361229]  nfsd4_proc_compound+0x44a/0x562 [nfsd]
[  302.361240]  nfsd_dispatch+0xb9/0x16e [nfsd]
[  302.361258]  svc_process+0x524/0x6e2 [sunrpc]
[  302.361270]  ? nfsd_destroy+0x5f/0x5f [nfsd]
[  302.361278]  nfsd+0xf9/0x150 [nfsd]
[  302.361284]  kthread+0x115/0x11d
[  302.361289]  ? kthread_park+0x76/0x76
[  302.361292]  ret_from_fork+0x35/0x40
[  302.361297] nfsd            D    0  2293      2 0x80000000
[  302.361300] Call Trace:
[  302.361305]  ? __schedule+0x59d/0x5f1
[  302.361309]  schedule+0x6a/0x85
[  302.361314]  rwsem_down_write_failed+0x1af/0x210
[  302.361325]  ? nfsd_permission+0xa3/0xe8 [nfsd]
[  302.361330]  call_rwsem_down_write_failed+0x13/0x20
[  302.361335]  down_write+0x20/0x2e
[  302.361345]  nfsd_unlink+0xb1/0x16b [nfsd]
[  302.361359]  nfsd4_remove+0x4e/0x10a [nfsd]
[  302.361371]  nfsd4_proc_compound+0x44a/0x562 [nfsd]
[  302.361381]  nfsd_dispatch+0xb9/0x16e [nfsd]
[  302.361395]  svc_process+0x524/0x6e2 [sunrpc]
[  302.361401]  ? __mutex_unlock_slowpath.isra.6+0x1e8/0x20a
[  302.361410]  ? nfsd_destroy+0x5f/0x5f [nfsd]
[  302.361419]  nfsd+0xf9/0x150 [nfsd]
[  302.361424]  kthread+0x115/0x11d
[  302.361428]  ? kthread_park+0x76/0x76
[  302.361434]  ret_from_fork+0x35/0x40
[  302.361441] rm              D    0  2388   2334 0x00000004
[  302.361444] Call Trace:
[  302.361449]  ? __schedule+0x59d/0x5f1
[  302.361453]  schedule+0x6a/0x85
[  302.361457]  wait_current_trans+0x9b/0xd8
[  302.361462]  ? wait_woken+0x6d/0x6d
[  302.361466]  start_transaction+0x1ae/0x38e
[  302.361471]  btrfs_start_transaction_fallback_global_rsv+0x32/0x127
[  302.361475]  btrfs_unlink+0x30/0xc0
[  302.361478]  vfs_unlink+0xd2/0x147
[  302.361482]  do_unlinkat+0x112/0x223
[  302.361488]  do_syscall_64+0x7e/0x133
[  302.361492]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  302.361496] RIP: 0033:0x7f681509b5d7
[  302.361504] Code: Bad RIP value.
[  302.361506] RSP: 002b:00007fffb1aed668 EFLAGS: 00000202 ORIG_RAX:
0000000000000107
[  302.361510] RAX: ffffffffffffffda RBX: 000055672760c6c0 RCX: 00007f681509b5d7
[  302.361512] RDX: 0000000000000000 RSI: 000055672760b490 RDI: 00000000ffffff9c
[  302.361514] RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000000
[  302.361516] R10: fffffffffffff12b R11: 0000000000000202 R12: 00007fffb1aed848
[  302.361518] R13: 000055672760b400 R14: 0000000000000002 R15: 0000000000000000

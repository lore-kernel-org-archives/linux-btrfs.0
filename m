Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:44549 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaGAFnn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 01:43:43 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id 83ACE3EE0B6
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Jul 2014 14:43:42 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.nic.fujitsu.com [10.0.50.91])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 949DCAC05B4
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Jul 2014 14:43:41 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 4DCAFE08001
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Jul 2014 14:43:41 +0900 (JST)
Received: from G01JPEXCHKW15.g01.fujitsu.local (G01JPEXCHKW15.g01.fujitsu.local [10.0.194.54])
	by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 9578A6923A2
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Jul 2014 14:43:40 +0900 (JST)
Message-ID: <53B24A86.1050802@jp.fujitsu.com>
Date: Tue, 1 Jul 2014 14:43:34 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: build failure with mason/for-linus tree
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

FYI, today I failed to build mason/for-linus tree as follows.

===============================================================================
...
/home/sat/src/linux-2.6/fs/btrfs/transaction.c: In function 'record_root_in_trans':
/home/sat/src/linux-2.6/fs/btrfs/transaction.c:293:3: error: implicit declaration of function 'smp_mb__before_atomic' [-Werror=implicit-function-declaration]
   smp_mb__before_atomic();
   ^
/home/sat/src/linux-2.6/fs/btrfs/transaction.c: In function 'commit_fs_roots':
/home/sat/src/linux-2.6/fs/btrfs/transaction.c:1065:4: error: implicit declaration of function 'smp_mb__after_atomic' [-Werror=implicit-function-declaration]
    smp_mb__after_atomic();
    ^
cc1: some warnings being treated as errors
...
===============================================================================

It can be solved by cherry-picking febdbfe.

===
commit febdbfe8a91ce0d11939d4940b592eb0dba8d663
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Thu Feb 6 18:16:07 2014 +0100

    arch: Prepare for smp_mb__{before,after}_atomic()
    
    Since the smp_mb__{before,after}*() ops are fundamentally dependent on
    how an arch can implement atomics it doesn't make sense to have 3
    variants of them. They must all be the same.
===

Thanks,
Satoru



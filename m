Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D713FC54EBE
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Jan 2023 04:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjAJEif (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 9 Jan 2023 23:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjAJEib (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jan 2023 23:38:31 -0500
Received: from out20-37.mail.aliyun.com (out20-37.mail.aliyun.com [115.124.20.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709853F455;
        Mon,  9 Jan 2023 20:38:28 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.09634232|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.0343581-0.000111956-0.96553;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047206;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.QozhIRn_1673325493;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.QozhIRn_1673325493)
          by smtp.aliyun-inc.com;
          Tue, 10 Jan 2023 12:38:13 +0800
Date:   Tue, 10 Jan 2023 12:38:14 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: please rebase the patch queue-6.1(btrfs: fix an error handling path in btrfs_defrag_leaves)
Message-Id: <20230110123813.7DCC.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.04 [en]
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi, Sasha Levin

please rebase the patch queue-6.1(btrfs: fix an error handling path in btrfs_defrag_leaves)
just like queue-6.0, and then drop its 8 depency patches.

the 2 of 8 depency patches are file rename, so it will make later depency patch become
difficult?
#btrfs-move-btrfs_get_block_group-helper-out-of-disk-.patch
#btrfs-move-flush-related-definitions-to-space-info.h.patch
#btrfs-move-btrfs_print_data_csum_error-into-inode.c.patch
#btrfs-move-fs-wide-helpers-out-of-ctree.h.patch
#btrfs-move-assert-helpers-out-of-ctree.h.patch
#btrfs-move-the-printk-helpers-out-of-ctree.h.patch
#**btrfs-rename-struct-funcs.c-to-accessors.c.patch
#**btrfs-rename-tree-defrag.c-to-defrag.c.patch

and the patch(btrfs: fix an error handling path in btrfs_defrag_leaves) is small,
so a rebase will be a good choice.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2023/01/10



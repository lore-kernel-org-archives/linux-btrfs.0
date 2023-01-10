Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34296C54EBE
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Jan 2023 08:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237132AbjAJItF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 Jan 2023 03:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238058AbjAJInA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2023 03:43:00 -0500
Received: from out20-1.mail.aliyun.com (out20-1.mail.aliyun.com [115.124.20.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81DB4D481;
        Tue, 10 Jan 2023 00:42:38 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.05019253|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.108887-0.000464039-0.890649;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047211;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=3;RT=3;SR=0;TI=SMTPD_---.QpBQLz6_1673340153;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.QpBQLz6_1673340153)
          by smtp.aliyun-inc.com;
          Tue, 10 Jan 2023 16:42:34 +0800
Date:   Tue, 10 Jan 2023 16:42:35 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Subject: Re: please rebase the patch queue-6.1(btrfs: fix an error handling path in btrfs_defrag_leaves)
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <Y70aTKUaBOLah8EQ@kroah.com>
References: <20230110123813.7DCC.409509F4@e16-tech.com> <Y70aTKUaBOLah8EQ@kroah.com>
Message-Id: <20230110164234.14C5.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.04 [en]
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

> On Tue, Jan 10, 2023 at 12:38:14PM +0800, Wang Yugui wrote:
> > Hi, Sasha Levin
> > 
> > please rebase the patch queue-6.1(btrfs: fix an error handling path in btrfs_defrag_leaves)
> > just like queue-6.0, and then drop its 8 depency patches.
> > 
> > the 2 of 8 depency patches are file rename, so it will make later depency patch become
> > difficult?
> > #btrfs-move-btrfs_get_block_group-helper-out-of-disk-.patch
> > #btrfs-move-flush-related-definitions-to-space-info.h.patch
> > #btrfs-move-btrfs_print_data_csum_error-into-inode.c.patch
> > #btrfs-move-fs-wide-helpers-out-of-ctree.h.patch
> > #btrfs-move-assert-helpers-out-of-ctree.h.patch
> > #btrfs-move-the-printk-helpers-out-of-ctree.h.patch
> > #**btrfs-rename-struct-funcs.c-to-accessors.c.patch
> > #**btrfs-rename-tree-defrag.c-to-defrag.c.patch
> > 
> > and the patch(btrfs: fix an error handling path in btrfs_defrag_leaves) is small,
> > so a rebase will be a good choice.
> 
> I do not understand, sorry, we can not rebase anything, that's not how
> our patch queue works.
> 
> So what exactly do you want to see changed?  What patches dropped?  And
> what added?

What I suggest:

1)replace queue-6.1/btrfs-fix-an-error-handling-path-in-btrfs_defrag_lea.patch
        with queue-6.0/btrfs-fix-an-error-handling-path-in-btrfs_defrag_lea.patch

2) drop pathes in queue-6.1/
btrfs-move-btrfs_get_block_group-helper-out-of-disk-.patch
btrfs-move-flush-related-definitions-to-space-info.h.patch
btrfs-move-btrfs_print_data_csum_error-into-inode.c.patch
btrfs-move-fs-wide-helpers-out-of-ctree.h.patch
btrfs-move-assert-helpers-out-of-ctree.h.patch
btrfs-move-the-printk-helpers-out-of-ctree.h.patch
btrfs-rename-struct-funcs.c-to-accessors.c.patch
btrfs-rename-tree-defrag.c-to-defrag.c.patch

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2023/01/10

> thanks,
> 
> greg k-h



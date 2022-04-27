Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0374FC433F5
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Apr 2022 23:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbiD0XIG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 19:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237739AbiD0XH5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Apr 2022 19:07:57 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A73AAB4F;
        Wed, 27 Apr 2022 16:02:14 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D666168AFE; Thu, 28 Apr 2022 01:02:10 +0200 (CEST)
Date:   Thu, 28 Apr 2022 01:02:10 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     syzbot <syzbot+a2c720e0f056114ea7c6@syzkaller.appspotmail.com>
Cc:     clm@fb.com, dsterba@suse.com, hch@lst.de, josef@toxicpanda.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, wqu@suse.com
Subject: Re: [syzbot] general protection fault in btrfs_stop_all_workers
Message-ID: <20220427230210.GA6837@lst.de>
References: <000000000000d9f33705dda65450@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000d9f33705dda65450@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

#syz test git://git.infradead.org/users/hch/misc.git btrfs-workqueue-fix

Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36474C001DF
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 Jul 2023 07:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbjGaHhs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 31 Jul 2023 03:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbjGaHhd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2023 03:37:33 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A731170A;
        Mon, 31 Jul 2023 00:37:13 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 00F3068AA6; Mon, 31 Jul 2023 09:37:07 +0200 (CEST)
Date:   Mon, 31 Jul 2023 09:37:07 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     syzbot <syzbot+ae97a827ae1c3336bbb4@syzkaller.appspotmail.com>
Cc:     clm@fb.com, dsterba@suse.com, hch@lst.de,
        johannes.thumshirn@wdc.com, josef@toxicpanda.com,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [btrfs?] kernel BUG in prepare_to_merge
Message-ID: <20230731073707.GA31980@lst.de>
References: <000000000000a3d67705ff730522@google.com> <000000000000f2ca8f0601bef9ca@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000f2ca8f0601bef9ca@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hmm, this seems to be missing the usual C reproducer?


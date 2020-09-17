Return-Path: <SRS0=YQmm=C2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF807C43461
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Sep 2020 13:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B35A62072E
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Sep 2020 13:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgIQNQ0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 09:16:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:34514 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727015AbgIQNQB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Sep 2020 09:16:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 36D62AC3F;
        Thu, 17 Sep 2020 13:16:06 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D6053DA7C7; Thu, 17 Sep 2020 15:14:19 +0200 (CEST)
Date:   Thu, 17 Sep 2020 15:14:19 +0200
From:   David Sterba <dsterba@suse.cz>
To:     syzbot <syzbot+e864a35d361e1d4e29a5@syzkaller.appspotmail.com>
Cc:     clm@fb.com, dsterba@suse.com, josef@toxicpanda.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: kernel BUG at lib/string.c:LINE! (5)
Message-ID: <20200917131419.GU1791@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        syzbot <syzbot+e864a35d361e1d4e29a5@syzkaller.appspotmail.com>,
        clm@fb.com, dsterba@suse.com, josef@toxicpanda.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000a61d6b05af580e62@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000a61d6b05af580e62@google.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 15, 2020 at 04:00:21AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e4c26faa Merge tag 'usb-5.9-rc5' of git://git.kernel.org/p..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13b17bed900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c61610091f4ca8c4
> dashboard link: https://syzkaller.appspot.com/bug?extid=e864a35d361e1d4e29a5
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=177582be900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13deb2b5900000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e864a35d361e1d4e29a5@syzkaller.appspotmail.com

#syz fix: btrfs: fix overflow when copying corrupt csums for a message

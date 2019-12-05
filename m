Return-Path: <SRS0=8E82=Z3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E824C43603
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Dec 2019 11:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F281F224F8
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Dec 2019 11:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbfLELuk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 06:50:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:47180 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729044AbfLELuk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Dec 2019 06:50:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DDF52AF94;
        Thu,  5 Dec 2019 11:50:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7D8EADA733; Thu,  5 Dec 2019 12:50:33 +0100 (CET)
Date:   Thu, 5 Dec 2019 12:50:33 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Johannes Thumshirn <jth@kernel.org>,
        syzbot <syzbot+5b658d997a83984507a6@syzkaller.appspotmail.com>,
        Chris Mason <clm@fb.com>, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:LINE!
Message-ID: <20191205115033.GJ2734@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Johannes Thumshirn <jth@kernel.org>,
        syzbot <syzbot+5b658d997a83984507a6@syzkaller.appspotmail.com>,
        Chris Mason <clm@fb.com>, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
References: <00000000000096009b056df92dc1@google.com>
 <beffba5d-e3d7-8b06-655b-bd04349177ea@kernel.org>
 <20191205100047.GA11438@Johanness-MacBook-Pro.local>
 <CACT4Y+Z-9g59XTwpfW+3fv1_jhbsskkvt8E8fx5F44BjofZ0ow@mail.gmail.com>
 <20191205113838.GC11438@Johanness-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205113838.GC11438@Johanness-MacBook-Pro.local>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 05, 2019 at 12:38:38PM +0100, Johannes Thumshirn wrote:
> On Thu, Dec 05, 2019 at 11:07:27AM +0100, Dmitry Vyukov wrote:
> > The correct syntax would be (no dash + colon):
> > 
> > #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/jth/linux.git
> > close_fs_devices
> 
> Ah ok, thanks.
> 
> Although syzbot already said it can't test because it has no reproducer.
> Anyways good to know for future reports.

According to

https://syzkaller.appspot.com/bug?id=d50670eeb21302915bde3f25871dfb7ea43db1e4

there is a way how to test it, many reports and the last one about a
week old. Is there a way to instruct syzbot to run the same tests on a
given branch?

(The reproducer is basically setting up environment with limited amount
of memory available for allocation and this hits the BUG_ON.)

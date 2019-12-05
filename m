Return-Path: <SRS0=8E82=Z3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD7E5C43603
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Dec 2019 11:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDA5824651
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Dec 2019 11:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbfLELim (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 06:38:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:41878 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728735AbfLELim (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Dec 2019 06:38:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 91683AFF0;
        Thu,  5 Dec 2019 11:38:40 +0000 (UTC)
Date:   Thu, 5 Dec 2019 12:38:38 +0100
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Johannes Thumshirn <jth@kernel.org>,
        syzbot <syzbot+5b658d997a83984507a6@syzkaller.appspotmail.com>,
        Chris Mason <clm@fb.com>, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:LINE!
Message-ID: <20191205113838.GC11438@Johanness-MacBook-Pro.local>
References: <00000000000096009b056df92dc1@google.com>
 <beffba5d-e3d7-8b06-655b-bd04349177ea@kernel.org>
 <20191205100047.GA11438@Johanness-MacBook-Pro.local>
 <CACT4Y+Z-9g59XTwpfW+3fv1_jhbsskkvt8E8fx5F44BjofZ0ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+Z-9g59XTwpfW+3fv1_jhbsskkvt8E8fx5F44BjofZ0ow@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 05, 2019 at 11:07:27AM +0100, Dmitry Vyukov wrote:
> The correct syntax would be (no dash + colon):
> 
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/jth/linux.git
> close_fs_devices

Ah ok, thanks.

Although syzbot already said it can't test because it has no reproducer.
Anyways good to know for future reports.

Byte,
	Johannes

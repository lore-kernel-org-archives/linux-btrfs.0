Return-Path: <SRS0=KJGA=Y2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9252CA9EC7
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Nov 2019 14:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BBFA20862
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Nov 2019 14:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfKBOgW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 2 Nov 2019 10:36:22 -0400
Received: from rin.romanrm.net ([91.121.75.85]:38204 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbfKBOgV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 2 Nov 2019 10:36:21 -0400
Received: from natsu (natsu.2.romanrm.net [IPv6:fd39:aa:7359:7f90:e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id 0DFF020373;
        Sat,  2 Nov 2019 14:36:19 +0000 (UTC)
Date:   Sat, 2 Nov 2019 19:36:24 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Brian Hansen <dulanic@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: reflink copy now works with nocow?
Message-ID: <20191102193624.3411de0d@natsu>
In-Reply-To: <CAMiuOHXH1ic6Mcz+o1uWLNMCK+iCinhR+nnZ8N1wTHQoEms-7Q@mail.gmail.com>
References: <CAMiuOHXH1ic6Mcz+o1uWLNMCK+iCinhR+nnZ8N1wTHQoEms-7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, 2 Nov 2019 08:49:37 -0500
Brian Hansen <dulanic@gmail.com> wrote:

> Hello,
> 
> First time i've sent to this group but I am trying to figure out the
> cause of this. Normal copy is working fine, but then if I use
> --reflink it says invalid argument. Not sure how to read some of this,
> but here is the strace.
> 
> I'm running kernel v4.15
> 
> Here is the full output of strace. I ran a strace on normal copy and
> most looks similar so I'm not able to figure out much here...
> 
> https://pastebin.com/raw/YmQ8FvCH

At first I was going to say, "oh it's because you are using 'chattr +C', or
mounted the filesystem as nocow, and reflink copying is prevented by those".
In fact this article from 2014 confirms that to be the case:
http://infotinks.com/btrfs-nodatacow-reflink-copies-snapshots/

But then I tested on my machine, and what used to fail, now works:

  # mkdir tmp
  # chattr +C tmp
  # echo abc > tmp/a
  # cp -a --reflink=always tmp/a tmp/b
  # lsattr tmp/
  ----------------C-- tmp/a
  ----------------C-- tmp/b

According to strace, the clone IOCTL succeeds:

...
  openat(AT_FDCWD, "tmp/b", O_WRONLY|O_CREAT|O_EXCL, 0600) = 4
  fstat(4, {st_mode=S_IFREG|0600, st_size=0, ...}) = 0
  ioctl(4, BTRFS_IOC_CLONE or FICLONE, 3) = 0
...

Same on kernels 4.14.151, 4.14.113 and 4.9.189.

So I wonder, is setting nocow via 'chattr +C' getting ignored now, or is there
an improvement that it no longer prevents reflink copying?

-- 
With respect,
Roman

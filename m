Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59074 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732297AbeGKBAg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 21:00:36 -0400
Date: Tue, 10 Jul 2018 17:58:52 -0700
From: Marc MERLIN <marc@merlins.org>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org,
        Su Yue <Damenly_Su@gmx.com>
Message-ID: <20180711005852.prhnmohkzjplw54j@merlins.org>
References: <20180710180915.onnxuak7vb7uywyn@merlins.org>
 <9afce26c-0a3f-3389-ba0f-597b26a8cd7e@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9afce26c-0a3f-3389-ba0f-597b26a8cd7e@cn.fujitsu.com>
Subject: Re: btrfs check lowmem, take 2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 11, 2018 at 08:53:58AM +0800, Su Yue wrote:
> > Problems
> > 1) btrfs check --repair _still_ takes all 32GB of RAM and crashes the
> > server, despite my deleting lots of snapshots.
> > Is it because I have too many files then?
> > 
> Yes. Original check first gather all infomation about extent tree and
> your files in RAM, then process one by one.
> But deleting still counts, it does speed lowmem check up.

Understood.

> > 2) I tried Su's master git branch for btrfs-progs to try and see how
> Oh..No... My master branch is still 4.14. The true mater branch is
> David's here:
> https://github.com/kdave/btrfs-progs
> But the master branch has a known bug which I fixed yesterday, please see
> the mail.

So, if I git sync it now, it should have your fix, and I can run it,
correct?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08

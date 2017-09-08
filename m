Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:38004 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756832AbdIHT5W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Sep 2017 15:57:22 -0400
Received: by mail-qt0-f193.google.com with SMTP id k2so2143566qte.5
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Sep 2017 12:57:21 -0700 (PDT)
Date: Fri, 8 Sep 2017 15:57:19 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 4.13: No space left with plenty of free space
 (/home/kernel/COD/linux/fs/btrfs/extent-tree.c:6989
 __btrfs_free_extent.isra.62+0xc2c/0xdb0)
Message-ID: <20170908195718.pxtff7anbvj2kh2g@destiny>
References: <7459bb074e417c066b525d832d8006ca@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7459bb074e417c066b525d832d8006ca@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 08, 2017 at 01:33:43PM +0900, Tomasz Chmielewski wrote:
> Just got this one in dmesg with btrfs RAID-1 on top of Linux software
> RAID-5.
> 
> Why does it say "No space left" if we have 9 TB free there?
> 

We've exhausted the global reserve.  I have a patch that I'm pretty sure fixes
this problem, would you mind trying

git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git btrfs-readdir

You need to make sure you are on the btrfs-readdir branch, and that you have the
patch entitled

Btrfs: only check delayed ref usage in should_end_transaction

If you still see the problem let me know, I really want to nail this issue down
and haven't been able to reproduce locally.  Thanks,

Josef

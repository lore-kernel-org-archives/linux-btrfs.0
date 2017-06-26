Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41910 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750852AbdFZNld (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 09:41:33 -0400
Date: Mon, 26 Jun 2017 15:40:23 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.com>
Cc: clm@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PULL] Btrfs for 4.13, part 1 (update 1)
Message-ID: <20170626134023.GI2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1498229425.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1498229425.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 23, 2017 at 05:16:46PM +0200, David Sterba wrote:

Two more patches added to the branch

Chris Mason (1):
      btrfs: fix integer overflow in calc_reclaim_items_nr

David Sterba (1):
      btrfs: scrub: fix target device intialization while setting up scrub context

Updated branch and tag:

----------------------------------------------------------------
The following changes since commit 41f1830f5a7af77cf5c86359aba3cbd706687e52:

  Linux 4.12-rc6 (2017-06-19 22:19:37 +0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.13-part1

for you to fetch changes up to 8399f53f0c7450ab050b1b0ffee4e2c1ddd2a3e0:

  btrfs: fix integer overflow in calc_reclaim_items_nr (2017-06-26 15:33:42 +0200)
----------------------------------------------------------------

Previous:

> ----------------------------------------------------------------
> The following changes since commit 41f1830f5a7af77cf5c86359aba3cbd706687e52:
> 
>   Linux 4.12-rc6 (2017-06-19 22:19:37 +0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.13-part1
> 
> for you to fetch changes up to f3f000297be88b1b75fde5027d660a8d8a44de14:
> 
>   btrfs: qgroup: Fix qgroup reserved space underflow by only freeing reserved ranges (2017-06-21 20:56:14 +0200)

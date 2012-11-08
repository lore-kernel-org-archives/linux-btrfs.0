Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28725 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab2KHLzk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Nov 2012 06:55:40 -0500
Date: Thu, 8 Nov 2012 19:55:35 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: fs/btrfs/dev-replace.c:486:17: sparse: incompatible types in
 comparison expression (different address spaces)
Message-ID: <20121108115535.GB7277@localhost>
References: <20121108073541.GA30285@localhost>
 <509B98B9.1020509@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <509B98B9.1020509@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Hi Fengguang,
 
Hi Stefan!

> Assuming that your script performs a periodic git fetch and git reset,
> and then starts compile runs on different architectures, the only
> explanation that I have is that something went wrong with the git
> operation in your script. It looks like some C source files have been
> updated, but the header files are old. Some kind of inconsistency that
> either a git reset --hard should fix, or rm -rf . and git clone to start
> from the beginning.
> 
> Could you check it please?

That's definitely good suggestion! I've added the check before each make
to make sure the tree is in a clean state:

git_check_reset()
{       
        [[ $(git --no-pager diff) ]] && {
                notice "unexpected modified work tree"
                dump_stack
                git --no-pager diff
                git reset --hard
        }
}       

> And could you please point me to some documentation, how this (very
> useful !) service from Intel is working?

Sure (and thanks!). Here is a nice article:

KS2012: Kernel build/boot testing
https://lwn.net/Articles/514278/

Thanks,
Fengguang

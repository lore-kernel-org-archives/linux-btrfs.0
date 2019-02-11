Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 200ABC169C4
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 16:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFDA0218D8
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 16:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbfBKQg7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 11:36:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:59826 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727067AbfBKQg6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 11:36:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5E627AD33;
        Mon, 11 Feb 2019 16:36:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 21514DA84E; Mon, 11 Feb 2019 17:36:14 +0100 (CET)
Date:   Mon, 11 Feb 2019 17:36:13 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Chris Mason <clm@fb.com>, Jeff Mahoney <jeffm@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Silence a static checker locking warning
Message-ID: <20190211163612.GW2900@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dan Carpenter <dan.carpenter@oracle.com>,
        Chris Mason <clm@fb.com>, Jeff Mahoney <jeffm@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, kernel-janitors@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190209090254.GC4865@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190209090254.GC4865@kadam>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Feb 09, 2019 at 12:02:55PM +0300, Dan Carpenter wrote:
> Back in the day, before commit 0b246afa62b0 ("btrfs: root->fs_info
> cleanup, add fs_info convenience variables") then we used to take
> different locks.

Nope, it's the same per-filesystem lock, just the old code got there
in two different ways (ie. two subvolume roots).

> But now it's just one lock and the static checkers
> think we can call down_read(&fs_info->subvol_sem); twice in a row which
> would lead to a deadlock.

Why? It's read side of a semaphore.

> That code is several years old now so presumably both (old_ino ==
> BTRFS_FIRST_FREE_OBJECTID) and (new_ino == BTRFS_FIRST_FREE_OBJECTID)
> conditions can't be true at the same time or the bug would have showed
> up in testing.

Why do you think it's a bug? If you are sure that there's a bug we've
overlooked, please state it in the changelog, the rationale you've
provided is very vague.

And I believe also wrong. The rename-exchange cannot work between two
subvolumes, but we still can cross-rename two subvolumes. In this
example hierarchy:

/
- subvol1 (inode number 256, ie. BTRFS_FIRST_FREE_OBJECTID)
  - file1
- subvol2 (inode number 256, ie. BTRFS_FIRST_FREE_OBJECTID)
  - file2

btrfs_rename_exchange leads to this:

/
- subvol1
  - file2
- subvol2
  - file1

There's no common tool that supports renameat2, so I'm using the one
from fstests/src/renameat2.c to verify that, and it does indeed work as
expected.

> I have re-written the code though to make it cleaner and
> to silence the static checkers.

Maybe there's something new the static checker needs to learn.

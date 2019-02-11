Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE37CC169C4
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 17:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BBA42075D
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 17:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbfBKRIW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:08:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:38016 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727235AbfBKRIW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 12:08:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1FC20B0CC;
        Mon, 11 Feb 2019 17:08:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 63204DA84E; Mon, 11 Feb 2019 18:07:39 +0100 (CET)
Date:   Mon, 11 Feb 2019 18:07:37 +0100
From:   David Sterba <dsterba@suse.cz>
To:     dsterba@suse.cz, Dan Carpenter <dan.carpenter@oracle.com>,
        Chris Mason <clm@fb.com>, Jeff Mahoney <jeffm@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Silence a static checker locking warning
Message-ID: <20190211170737.GX2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dan Carpenter <dan.carpenter@oracle.com>,
        Chris Mason <clm@fb.com>, Jeff Mahoney <jeffm@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, kernel-janitors@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190209090254.GC4865@kadam>
 <20190211163612.GW2900@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190211163612.GW2900@suse.cz>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 11, 2019 at 05:36:13PM +0100, David Sterba wrote:
> On Sat, Feb 09, 2019 at 12:02:55PM +0300, Dan Carpenter wrote:
> > Back in the day, before commit 0b246afa62b0 ("btrfs: root->fs_info
> > cleanup, add fs_info convenience variables") then we used to take
> > different locks.
> 
> Nope, it's the same per-filesystem lock, just the old code got there
> in two different ways (ie. two subvolume roots).
> 
> > But now it's just one lock and the static checkers
> > think we can call down_read(&fs_info->subvol_sem); twice in a row which
> > would lead to a deadlock.
> 
> Why? It's read side of a semaphore.
> 
> > That code is several years old now so presumably both (old_ino ==
> > BTRFS_FIRST_FREE_OBJECTID) and (new_ino == BTRFS_FIRST_FREE_OBJECTID)
> > conditions can't be true at the same time or the bug would have showed
> > up in testing.
> 
> Why do you think it's a bug? If you are sure that there's a bug we've
> overlooked, please state it in the changelog, the rationale you've
> provided is very vague.
> 
> And I believe also wrong. The rename-exchange cannot work between two
> subvolumes, but we still can cross-rename two subvolumes. In this
> example hierarchy:
> 
> /
> - subvol1 (inode number 256, ie. BTRFS_FIRST_FREE_OBJECTID)
>   - file1
> - subvol2 (inode number 256, ie. BTRFS_FIRST_FREE_OBJECTID)
>   - file2
> 
> btrfs_rename_exchange leads to this:
> 
> /
> - subvol1
>   - file2
> - subvol2
>   - file1
> 
> There's no common tool that supports renameat2, so I'm using the one
> from fstests/src/renameat2.c to verify that, and it does indeed work as
> expected.

Lockdep was forgiving and did not deadlock, that I would notice while
running the test. There's a warning in the log about the recursive
locking. So we need to add the lock annotation or merge them to a single
location as you suggest.

And also add a test to fstests, as the subvolume related testcases are
completely missing.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40818 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730254AbeIFUeX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Sep 2018 16:34:23 -0400
Date: Thu, 6 Sep 2018 17:57:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: extent-tree.c: Remove redundant variable from
 btrfs_cross_ref_exist()
Message-ID: <20180906155757.GC24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1535593351.git.misono.tomohiro@jp.fujitsu.com>
 <90c3c33c-0f7d-7121-feb8-4a74e5e78b93@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <90c3c33c-0f7d-7121-feb8-4a74e5e78b93@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2018 at 10:59:16AM +0900, Misono Tomohiro wrote:
> Since commit d7df2c796d7e ("Btrfs attach delayed ref updates to
> delayed ref heads"), check_delaed_ref() won't return -ENOENT.
> 
> In btrfs_cross_ref_exist(), two variable 'ret' and 'ret2' is
> originally used to handle -ENOENT error case.
> 
> Since the code is not needed anymore, let's just remove 'ret2'.

Good cleanup and the patch would be ok as-is. I've noticed that
check_delayed_ref now returns only two values so it might make sense to
turn it to bool and update the name of check_delayed_ref to make it
clear what the return value means in the loop.

The concern here is that adding another error code in check_delayed_ref
in the future will not be caught in btrfs_cross_ref_exist. Adding an
assert filtering only EAGAIN would be sufficient as this might miss the
extra value in case it'd be an uncommon case.

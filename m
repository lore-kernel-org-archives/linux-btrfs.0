Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58908 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750928AbcLEHOU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Dec 2016 02:14:20 -0500
Date: Mon, 5 Dec 2016 15:07:16 +0800
From: Eryu Guan <eguan@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Add testcase for fundamental scrub recovery
Message-ID: <20161205070716.GQ29149@eguan.usersys.redhat.com>
References: <20161122083811.12636-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161122083811.12636-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 22, 2016 at 04:38:08PM +0800, Qu Wenruo wrote:
> Despite the scrub test cases in fstests, there is not even one test case
> which really checked if scrub can recover data.
> 
> In fact, btrfs scrub for RAID56 will even corrupt correct data stripes.
> 
> So let's start from the needed facilities and check scrub starting from RAID1.
> 
> The main reason the patchset is RFC, is the method I take to corrupt/verify
> btrfs data.
> 
> unlike other stable fs, like ext* or xfs, which has good tool to
> manipulate the fs.
> 
> There used to be btrfs-corrupt-block, but it gets fewer and fewer
> update, no man page nor installed by default.

I really think that a tool manipulating btrfs should be developed first,
especially it's greatly demanded now and there's already a prototype
btrfs-corrupt-block available. Then this tool can act as a base &
benefit all future tests that corrupt fs metadata. e.g. Darrick
introduced blocktrash command to xfs_db and used it in many fuzz tests.

IMO, let's build and/or fix the tools first. To me, this is just the
right time to do this.

> 
> Here I take the method I normally do in my scripts: use btrfs-dump-tree
> (btrfs inspect-internal dump-tree) and use bash to corrupt btrfs
> pinpointly.
> It works quite fine for several different mount options which affects
> how data lies on-disk.
> 
> But the problem is also obvious, bash script is super hard to maintain,
> and there is no promise that btrfs-dump-tree output won't change.
> Such change will be destructive.

Agreed, it's very hard to maintain, and, as you pointed out, the output
format changing of btrfs-dump-tree makes the code even harder to read &
maintain. And it's hard to extend to work with other profiles too.

I'd like to hear what other btrfs developers and fstests users think.

Thanks,
Eryu

> 
> But IMHO it's still worthy, or btrfs scrub may break at any time.
> 
> Qu Wenruo (3):
>   fstests: common: rename _require_btrfs to _require_btrfs_subcommand
>   fstests: common/ondisk.btrfs: Introduce function to get btrfs ondisk  
>       info
>   fstests: btrfs: Add new test case to check scrub recovery and report
> 
>  common/ondisk.btrfs | 113 ++++++++++++++++++++++++++
>  common/rc           |   2 +-
>  tests/btrfs/004     |   2 +-
>  tests/btrfs/048     |   2 +-
>  tests/btrfs/059     |   2 +-
>  tests/btrfs/131     |   2 +-
>  tests/btrfs/132     | 229 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/132.out | 111 +++++++++++++++++++++++++
>  tests/btrfs/group   |   2 +
>  9 files changed, 460 insertions(+), 5 deletions(-)
>  create mode 100644 common/ondisk.btrfs
>  create mode 100755 tests/btrfs/132
>  create mode 100644 tests/btrfs/132.out
> 
> -- 
> 2.7.4
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46248 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726845AbeINTfg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 15:35:36 -0400
Date: Fri, 14 Sep 2018 16:20:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] btrfs: tests: polish ifdefs around testing helper
Message-ID: <20180914142051.GH5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1536599879.git.dsterba@suse.com>
 <7a6c4814d8467999d9a9eb12906ff28a3f90b284.1536599879.git.dsterba@suse.com>
 <20180910234329.GD16436@vader>
 <20180911092250.GC24025@twin.jikos.cz>
 <20180911191447.GA26631@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180911191447.GA26631@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2018 at 12:14:47PM -0700, Omar Sandoval wrote:
> > The unlikely can go away, sure.
> > 
> > I would still like to remove the test_bit call when tests are compiled
> > out. There are about 10 calls to btrfs_is_testing in various core
> > functions, followed by further statements. This would have a
> > (negligible) runtime penalty but generates effectively unused code on
> > production builds.
> > 
> > The static inline function returning 0 allows to optimize out the unused
> > code, so smaller code, fewer inctructions, etc.
> 
> Absolutely, I just mean that the CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> version can be cleaner:
> 
> #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
> {
> 	return test_bit(BTRFS_FS_STATE_DUMMY_FS_INFO, &fs_info->fs_state);
> }
> #else
> static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
> {
> 	return 0;
> }
> #endif
> 
> I find `if (1) return 1; else return 0;` really icky.

I see what you mean, will fix it.

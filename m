Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:58869 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab3KTRbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 12:31:00 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 7F0197C0686
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 10:31:00 -0700 (MST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>, Kees Cook <keescook@chromium.org>,
        Jeff Mahoney <jeffm@suse.com>, Josef Bacik <JBacik@fusionio.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20131120040551.GB4201@localhost>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
References: <528c09f9.S0ecVwNN2c+fnUkv%fengguang.wu@intel.com>
 <CAGXu5jLoG00u2svBW6W5h9QsfYw1zZwYhZ1k4HG2UsvcWPHxuQ@mail.gmail.com>
 <20131120040551.GB4201@localhost>
Message-ID: <20131120173044.5312.44850@localhost.localdomain>
Subject: Re: fs/btrfs/extent-tree.c:8430:9: error: format not a string literal and no
 format arguments
Date: Wed, 20 Nov 2013 12:30:44 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Fengguang Wu (2013-11-19 23:05:51)
> On Tue, Nov 19, 2013 at 07:56:35PM -0800, Kees Cook wrote:
> > Hi!
> > 
> > Which tree is 'devel-snb'? I don't see that on the kernel.org trees.
> 
> It's my local merge branch, based on the latest upstream release.
> 
> Let's CC the btrfs developers for this warning. :)
> 
> Thanks,
> Fengguang
> 
> > On Tue, Nov 19, 2013 at 5:01 PM, kbuild test robot
> > <fengguang.wu@intel.com> wrote:
> > > tree:    devel-snb-x86_64-201311200240
> > > head:   1a985a0807ea34f37a4c5287089abd1cd2f65049
> > > commit: a9b93a3684dd6ebfb7cfa173f78a79c09de81207 Merge 'kees/format-security' into devel-snb-x86_64-201311200240
> > > date:   6 hours ago
> > > config: make ARCH=x86_64 allmodconfig
> > >
> > > All error/warnings:
> > >
> > >    fs/btrfs/extent-tree.c:6201:12: sparse: symbol 'get_raid_name' was not declared. Should it be static?
> > >    fs/btrfs/extent-tree.c:2469:28: sparse: context imbalance in 'run_clustered_refs' - unexpected unlock
> > >    fs/btrfs/extent-tree.c:8304:9: sparse: context imbalance in 'btrfs_put_block_group_cache' - wrong count at exit
> > >    fs/btrfs/extent-tree.c: In function '__link_block_group':
> > >>> fs/btrfs/extent-tree.c:8430:9: error: format not a string literal and no format arguments [-Werror=format-security]
> > >             get_raid_name(index));

This comes from the btrfs-next tree, with Jeff's sysfs patches, so I've
added Jeff.

-chris

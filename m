Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:35054 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab2HBMHo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Aug 2012 08:07:44 -0400
Date: Thu, 2 Aug 2012 08:07:41 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Fengguang Wu <fengguang.wu@intel.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [josef-btrfs:master 9/11] fs/btrfs/transaction.c:1118:6:
 warning: 'parent' may be used uninitialized in this function
Message-ID: <20120802120741.GE2263@localhost.localdomain>
References: <20120802023123.GA10533@localhost>
 <501A0221.4060204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <501A0221.4060204@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 01, 2012 at 10:29:21PM -0600, Miao Xie wrote:
> On Thu, 2 Aug 2012 10:31:23 +0800, Fengguang Wu wrote:
> > There are new compile warnings show up in
> > 
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git master
> > head:   8e1163044779e90662e96887cdd692c1594146ad
> > commit: dd817e81e81bbb83b63317b169d0e57a5d7ae0e1 [9/11] Btrfs: fix error path in create_pending_snapshot()
> > config: x86_64-randconfig-h031 (attached as .config)
> > 
> > All error/warnings:
> > 
> > fs/btrfs/transaction.c: In function 'create_pending_snapshot':
> > fs/btrfs/transaction.c:1118:6: warning: 'parent' may be used uninitialized in this function [-Wmaybe-uninitialized]
> > fs/btrfs/transaction.c:1119:19: warning: 'rsv' may be used uninitialized in this function [-Wmaybe-uninitialized]
> > 
> > vim +1118 fs/btrfs/transaction.c
> >   1115		if (ret)
> >   1116			goto abort_trans;
> >   1117	fail:
> >> 1118		dput(parent);
> >   1119		trans->block_rsv = rsv;
> >   1120	no_free_objectid:
> >   1121		kfree(new_root_item);
> 
> The patch I sent before is based on the v3.5.0, not Chris's latest for-linus branch, so...
> 
> I will send new patches to fix it. Thanks for your report.
> 

I've pulled these patches, Dave still has concerns about corruption.  Thanks,

Josef

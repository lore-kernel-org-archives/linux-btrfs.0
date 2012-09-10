Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:41989 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758150Ab2IJQUG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Sep 2012 12:20:06 -0400
Date: Mon, 10 Sep 2012 12:20:02 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>, "dave@jikos.cz" <dave@jikos.cz>
Subject: Re: [PATCH v2 0/6] bug-fixes and cleanup
Message-ID: <20120910162002.GB2270@localhost.localdomain>
References: <1347069690-30223-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1347069690-30223-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 07, 2012 at 08:01:24PM -0600, Liu Bo wrote:
> From: Liu Bo <liub.liubo@gmail.com>
> 
> This is a collection of some posted patches.
> 
> It is also available in
> 	git://github.com/liubogithub/btrfs-work.git for-chris
> 
> v1->v2: patch 1 (Btrfs: fix a bug of per-file nocow) is the only one to
>         update since we missed the regular file check while others
>         remain unchanged.
> 
> Liu Bo (5):
>   Btrfs: fix a bug of per-file nocow
>   Btrfs: update delayed ref's tracepoints to show sequence
>   Btrfs: fix a bug in parsing return value in logical resolve
>   Btrfs: use helper for logical resolve
>   Btrfs: use larger limit for translation of logical to inode
> 
> liubo (1):
>   Btrfs: cleanup for unused ref cache stuff
> 
>  fs/btrfs/backref.c           |   26 +++++++++++++++++---------
>  fs/btrfs/backref.h           |    3 ++-
>  fs/btrfs/ctree.h             |    3 ---
>  fs/btrfs/disk-io.c           |    5 -----
>  fs/btrfs/inode.c             |    3 +--
>  fs/btrfs/ioctl.c             |   28 ++++++++++------------------
>  fs/btrfs/scrub.c             |   14 ++++++++------
>  fs/btrfs/send.c              |    7 ++++---
>  include/trace/events/btrfs.h |   14 ++++++++++----
>  9 files changed, 52 insertions(+), 51 deletions(-)
> 

If you are only fixing one patch in the series please just post the updated one,
I went through and rebased out all the other patches and reapplied them before I
realized what you were doing.  Thanks,

Josef

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55480 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750841AbcLEHKQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Dec 2016 02:10:16 -0500
Date: Mon, 5 Dec 2016 15:10:14 +0800
From: Eryu Guan <eguan@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] fstests: common: rename _require_btrfs to
 _require_btrfs_subcommand
Message-ID: <20161205071014.GR29149@eguan.usersys.redhat.com>
References: <20161122083811.12636-1-quwenruo@cn.fujitsu.com>
 <20161122083811.12636-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161122083811.12636-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 22, 2016 at 04:38:09PM +0800, Qu Wenruo wrote:
> Rename _require_btrfs() to _require_btrfs_subcommand() to avoid
> confusion, as all other _require_btrfs_* has a quite clear suffix, like
> _require_btrfs_mkfs_feature() or _require_btrfs_fs_feature().
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  common/rc       | 2 +-
>  tests/btrfs/004 | 2 +-
>  tests/btrfs/048 | 2 +-
>  tests/btrfs/059 | 2 +-
>  tests/btrfs/131 | 2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index e3b54ec..6d333dd 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3017,7 +3017,7 @@ _require_deletable_scratch_dev_pool()
>  }
>  
>  # We check for btrfs and (optionally) features of the btrfs command
> -_require_btrfs()
> +_require_btrfs_subcommand()

_require_btrfs_command seems good enough. And it should be improved to
handle subcommands like dump-tree (like what _require_xfs_io_command
does), otherwise tests fail if old version of btrfs-progs is installed
where inspect-internal doesn't have dump-tree support.

Thanks,
Eryu

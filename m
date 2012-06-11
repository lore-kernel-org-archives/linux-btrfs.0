Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:36708 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822Ab2FKNXV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jun 2012 09:23:21 -0400
Date: Mon, 11 Jun 2012 15:23:16 +0200
From: David Sterba <dave@jikos.cz>
To: Josef Bacik <josef@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: use rcu to protect device->name
Message-ID: <20120611132316.GH32402@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1338920193-7843-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1338920193-7843-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 05, 2012 at 02:16:32PM -0400, Josef Bacik wrote:
> Al pointed out that we can just toss out the old name on a device and add a
> new one arbitrarily, so anybody who uses device->name in printk could
> possibly use free'd memory.  Instead of adding locking around all of this he
> suggested doing it with RCU, so I've introduced a struct rcu_string that
> does just that and have gone through and protected all accesses to
> device->name that aren't under the uuid_mutex with rcu_read_lock().  This
> protects us and I will use it for dealing with removing the device that we
> used to mount the file system in a later patch.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/check-integrity.c |   11 ++++-
>  fs/btrfs/disk-io.c         |   14 +++++-
>  fs/btrfs/extent_io.c       |    7 +++-
>  fs/btrfs/ioctl.c           |   14 +++++-
>  fs/btrfs/scrub.c           |   39 ++++++++++++++---
>  fs/btrfs/volumes.c         |  102 ++++++++++++++++++++++++++++++++------------
>  fs/btrfs/volumes.h         |    2 +-
>  7 files changed, 147 insertions(+), 42 deletions(-)
> 
> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> index 9cebb1f..9f69855 100644
> --- a/fs/btrfs/check-integrity.c
> +++ b/fs/btrfs/check-integrity.c
> @@ -93,6 +93,7 @@
>  #include "print-tree.h"
>  #include "locking.h"
>  #include "check-integrity.h"
> +#include "rcu-string.h"

Not included in the patch. Besides, it seems to be a more general API
that should not live inside btrfs directory. While searching for the
rcu-string.h I found

http://lkml.indiana.edu/hypermail/linux/kernel/1001.0/00911.html
"Add rcustring ADT for RCU protected strings v2" @ 2010

doing (probably) the same.


david

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932201AbcHON1n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 09:27:43 -0400
Date: Mon, 15 Aug 2016 15:26:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        tglx@linutronix.de, torvalds@linux-foundation.org, tytso@mit.edu,
        viro@zeniv.linux.org.uk, y2038@lists.linaro.org,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 10/26] fs: btrfs: Use ktime_get_real_ts for root ctime
Message-ID: <20160815132649.GI30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1471128518-24075-1-git-send-email-deepa.kernel@gmail.com>
 <1471128518-24075-11-git-send-email-deepa.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1471128518-24075-11-git-send-email-deepa.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 13, 2016 at 03:48:22PM -0700, Deepa Dinamani wrote:
> btrfs_root_item maintains the ctime for root updates.
> This is not part of vfs_inode.
> 
> Since current_time() uses struct inode* as an argument
> as Linus suggested, this cannot be used to update root
> times unless, we modify the signature to use inode.
> 
> Since btrfs uses nanosecond time granularity, it can also
> use ktime_get_real_ts directly to obtain timestamp for
> the root. It is necessary to use the timespec time api
> here because the same btrfs_set_stack_timespec_*() apis
> are used for vfs inode times as well. These can be
> transitioned to using timespec64 when btrfs internally
> changes to use timespec64 as well.
> 
> Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
> Acked-by: David Sterba <dsterba@suse.com>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Chris Mason <clm@fb.com>
> Cc: David Sterba <dsterba@suse.com>

Acked-by: David Sterba <dsterba@suse.com>

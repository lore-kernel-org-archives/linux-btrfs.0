Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36600 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753088AbdDLNmw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Apr 2017 09:42:52 -0400
Date: Wed, 12 Apr 2017 15:42:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        tglx@linutronix.de, viro@zeniv.linux.org.uk,
        gregkh@linuxfoundation.org, andreas.dilger@intel.com, arnd@arndb.de,
        bfields@fieldses.org, clm@fb.com, davem@davemloft.net,
        dsterba@suse.com, dushistov@mail.ru, eparis@redhat.com,
        jaegeuk@kernel.org, jbacik@fb.com, jlayton@poochiereds.net,
        john.stultz@linaro.org, jsimmons@infradead.org, mingo@redhat.com,
        oleg.drokin@intel.com, paul@paul-moore.com, rostedt@goodmis.org,
        yuchao0@huawei.com, ceph-devel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-audit@redhat.com,
        linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-security-module@vger.kernel.org,
        lustre-devel@lists.lustre.org, netdev@vger.kernel.org,
        samba-technical@lists.samba.org, y2038@lists.linaro.org
Subject: Re: [PATCH 07/12] fs: btrfs: Use ktime_get_real_ts for root ctime
Message-ID: <20170412134245.GK4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1491613030-11599-1-git-send-email-deepa.kernel@gmail.com>
 <1491613030-11599-8-git-send-email-deepa.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1491613030-11599-8-git-send-email-deepa.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 07, 2017 at 05:57:05PM -0700, Deepa Dinamani wrote:
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

I'm going to add the patch to my 4.12 queue and will let Andrew know.

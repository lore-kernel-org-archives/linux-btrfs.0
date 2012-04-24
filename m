From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v2] btrfs: allow changing 'thread_pool' size at remount
 time
Date: Tue, 24 Apr 2012 16:00:36 -0400
Message-ID: <20120424200035.GA7100@localhost.localdomain>
References: <20120424181025.GC6164@localhost.localdomain>
 <1335297556-11160-1-git-send-email-slyich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org,
	Sergei Trofimovich <slyfox@gentoo.org>,
	Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1335297556-11160-1-git-send-email-slyich@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 24, 2012 at 10:59:16PM +0300, Sergei Trofimovich wrote:
> From: Sergei Trofimovich <slyfox@gentoo.org>
> 
> Changing 'mount -oremount,thread_pool=2 /' didn't make any effect:
> 
> maximum amount of worker threads is specified in 2 places:
> - in 'strict btrfs_fs_info::thread_pool_size'
> - in each worker struct: 'struct btrfs_workers::max_workers'
> 
> 'mount -oremount' updated only 'btrfs_fs_info::thread_pool_size'.
> 
> Fix it by pushing new maximum value to all created worker structures
> as well.
> 
> Cc: Josef Bacik <josef@redhat.com>
> Cc: Chris Mason <chris.mason@oracle.com>
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef

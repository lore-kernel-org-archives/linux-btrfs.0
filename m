Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:35428 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366Ab2HXORl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 10:17:41 -0400
Received: from [192.168.0.27] (151.24.44.165) by smtp208.alice.it (8.6.023.02) (authenticated as kreijack@alice.it)
        id 500F3F9405593B12 for linux-btrfs@vger.kernel.org; Fri, 24 Aug 2012 16:11:40 +0200
Message-ID: <50378BC7.9060508@libero.it>
Date: Fri, 24 Aug 2012 16:12:23 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v1 0/4] BTRFS sysfs support
References: <20120824135322.20478.88578.stgit@venice.bhome>
In-Reply-To: <20120824135322.20478.88578.stgit@venice.bhome>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

You can pull the source from the following repo:

	http://cassiopea.homelinux.net/git/btrfs-unstable.git

branch

	sysfs

thanks.
G.Baroncelli

On 08/24/2012 03:58 PM, Goffredo Baroncelli wrote:
> Hi all,
> The following series restores the BTRFS sysfs support. My idea is to
> exporting some information via sysfs to get rid of some ioctl(s) which
> are particular solution of a more general problem: exporting information
> from kernel space to user space.
> 
> These patches export basically the fields of the following structure:
> - btrfs_device
> - btrfs_fs_info
> - btrfs_fs_devices
> 
> You can read more about which information are exported reading the
> patch which contains an update of the btrfs.txt file (the last one).
> 
> The goal of this attempt is to collect comments relating to
> which information we should export and which not or the sysfs structure.
> 
> For now these information are read-only. In the future we could 
> consider the idea to allow updates: for example to change the 
> label of a filesystem.
> 
> Comments are welcome.
> BR
> G.Baroncelli
> 
> 
> Changelog:
> 
> v0:	First issue
> v1:	Source cleanup and replacing of the printk with pr_info/pr_warn/
>         pr_crit
> 
> ---
> 
> Goffredo Baroncelli (4):
>       Add support for sysfs to btrfs.
>       Add hook for sysfs to btrfs.
>       Add a new Kconfig section to enable or disable the sysfs.
>       Btrfs sysfs support documentation.
> 
> 
>  fs/btrfs/Kconfig   |    9 
>  fs/btrfs/super.c   |    4 
>  fs/btrfs/sysfs.c   |  938 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/sysfs.h   |   31 ++
>  fs/btrfs/volumes.c |   10 -
>  5 files changed, 986 insertions(+), 6 deletions(-)
>  create mode 100644 fs/btrfs/sysfs.h
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 


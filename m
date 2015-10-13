Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274AbbJMP7S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 11:59:18 -0400
Date: Tue, 13 Oct 2015 17:58:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/11] btrfs-progs: Use btrfs_open_dir to avoid show
 error of ioctl or tree search
Message-ID: <20151013155807.GK27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1444655800.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1444655800.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 12, 2015 at 09:22:53PM +0800, Zhao Lei wrote:
> Use btrfs_open_dir() instead of open_file_or_dir(), to show error before
> real action(in ioctl or tree search), to make the error message exact
> and unified.
> 
> Zhao Lei (11):
>   btrfs-progs: subvolume: use btrfs_open_dir for btrfs subvolume command
>   btrfs-progs: filesystem: use btrfs_open_dir for btrfs filesystem
>     command
>   btrfs-progs: balance: use btrfs_open_dir for btrfs balance command
>   btrfs-progs: inspect: Bypass unnecessary clean function in open_error
>   btrfs-progs: inspect: set return value of error case
>   btrfs-progs: inspect: use btrfs_open_dir for btrfs inspect command
>   btrfs-progs: qgroup: use btrfs_open_dir for btrfs qgroup command
>   btrfs-progs: quota: use btrfs_open_dir for btrfs quota command
>   btrfs-progs: use btrfs_open_dir in open_path_or_dev_mnt
>   btrfs-progs: replace: use btrfs_open_dir for btrfs replace command
>   btrfs-progs: fragments: use btrfs_open_dir for btrfs-fragments command

All merged, thanks! I appreciate you took the time to test all the
changes and the patch separation made review easy.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbcCaEXu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 00:23:50 -0400
Date: Thu, 31 Mar 2016 12:23:48 +0800
From: Eryu Guan <eguan@redhat.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 1/2] fstests: generic test for fsync after renaming
 directory
Message-ID: <20160331042348.GI19986@eguan.usersys.redhat.com>
References: <1459330722-3227-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459330722-3227-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 30, 2016 at 10:38:42AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that if we rename a directory, create a new file or directory that
> has the old name of our former directory and is a child of the same
> parent directory, fsync the new inode, power fail and mount the
> filesystem, we see our first directory with the new name and no files
> under it were lost.
> 
> This test is motivated by an issue found in btrfs which is fixed by the
> following patch for the linux kernel:
> 
>   "Btrfs: fix file loss caused by fsync after rename and new inode"
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Looks good to me, tested on ext4/3 xfs and btrfs, with 4.6-rc1 kernel,
btrfs failed as expected, ext4/3 and xfs all passed.

Reviewed-by: Eryu Guan <eguan@redhat.com>

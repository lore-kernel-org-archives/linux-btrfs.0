Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbcCaEYr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 00:24:47 -0400
Date: Thu, 31 Mar 2016 12:24:45 +0800
From: Eryu Guan <eguan@redhat.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 2/2] fstests: generic test for fsync after renaming file
Message-ID: <20160331042444.GJ19986@eguan.usersys.redhat.com>
References: <1459330750-3284-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459330750-3284-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 30, 2016 at 10:39:10AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that if we rename a file, create a new file that has the old name
> of the other file and is a child of the same parent directory, fsync the
> new inode, power fail and mount the filesystem, we do not lose the first
> file and that file has the name it was renamed to.
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

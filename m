Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219AbcDGHgp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Apr 2016 03:36:45 -0400
Date: Thu, 7 Apr 2016 15:36:43 +0800
From: Eryu Guan <eguan@redhat.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] fstests: generic test for fsync after adding a link and
 moving other inode
Message-ID: <20160407073643.GP10345@eguan.usersys.redhat.com>
References: <1459980716-4705-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459980716-4705-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 06, 2016 at 11:11:56PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that if we create a hard link for a file F in some directory A,
> then move some directory or file B from its parent directory C into
> directory A, fsync file F, power fail and mount the filesystem, the
> directory/file B is located only at directory A and both links for
> file F exist.
> 
> This test is motivated by an issue found in btrfs which is fixed by the
> following patch for the linux kernel:
> 
>   Btrfs: fix for incorrect directory entries after fsync log replay
> 
> Tested against ext3/4, xfs, reiserfs and f2fs.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Looks good to me. Test passed with ext3/4 and xfs, failed with btrfs as
expected.

Reviewed-by: Eryu Guan <eguan@redhat.com>

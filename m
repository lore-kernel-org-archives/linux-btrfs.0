Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42254 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751203AbdFGJgr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Jun 2017 05:36:47 -0400
Date: Wed, 7 Jun 2017 17:36:45 +0800
From: Eryu Guan <eguan@redhat.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: test Btrfs delalloc accounting overflow
Message-ID: <20170607093645.GZ19952@eguan.usersys.redhat.com>
References: <e7bcf330422ed18883c9ad8ad4caa57624ed7cc0.1496818581.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e7bcf330422ed18883c9ad8ad4caa57624ed7cc0.1496818581.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 11:57:10PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> This is a regression test for "[PATCH] Btrfs: fix delalloc accounting
> leak caused by u32 overflow". It creates a bunch of delalloc extents and
> merges them together to make sure the accounting is done right.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

I refer to the patch by its commit id 8b8b08cbfb90 as well, and replaced
xfs_io with $XFS_IO_PROG, and queued for next update.

Thanks,
Eryu

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:53221 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaI1Iv1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Sep 2014 04:51:27 -0400
Received: by mail-pd0-f171.google.com with SMTP id y13so15443132pdi.2
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Sep 2014 01:51:27 -0700 (PDT)
Date: Sun, 28 Sep 2014 01:52:30 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs: fix several sparse warnings
Message-ID: <20140928085230.GA31649@molino.home.network>
References: <1411894092-28784-1-git-send-email-osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1411894092-28784-1-git-send-email-osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 28, 2014 at 01:48:10AM -0700, Omar Sandoval wrote:
> This patch series fixes some warnings reported by sparse when building the
> btrfs module. It fixes two classes of warnings: address space warnings and lock
> context warnings. This didn't uncover any logical errors, but it reduces the
> noise when checking the source. There are a few less straightforward sparse
> warnings still remaining.
> 
> Omar Sandoval (2):
>   btrfs: fix sparse address space warnings
>   btrfs: fix sparse lock context warnings
> 
>  fs/btrfs/ctree.c            | 3 ++-
>  fs/btrfs/extent-tree.c      | 1 +
>  fs/btrfs/extent_io.c        | 2 +-
>  fs/btrfs/free-space-cache.c | 1 +
>  fs/btrfs/ioctl.c            | 6 +++---
>  fs/btrfs/locking.c          | 1 +
>  fs/btrfs/send.c             | 8 ++++----
>  7 files changed, 13 insertions(+), 9 deletions(-)
> 

This patch series applies to 3.17-rc6.

-- 
Omar

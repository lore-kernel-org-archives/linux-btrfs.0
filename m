Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:57454 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab2LTQeM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Dec 2012 11:34:12 -0500
Date: Thu, 20 Dec 2012 11:34:08 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Rock Lee <zimilo@code-trick.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: HIT WARN_ON WARNING: at fs/btrfs/extent-tree.c:6339
 btrfs_alloc_free_block+0x126/0x330 [btrfs]()
Message-ID: <20121220163408.GE4033@localhost.localdomain>
References: <CAMRmmp+=YT_-KdGHRWo5GrofiSnkZB_xVpN1Z8Jp4xgo0fVS3A@mail.gmail.com>
 <20121219152925.GC4033@localhost.localdomain>
 <CAMRmmp+gqw11a32GV=X1VGKvJWGRO0PXk-13fMyEmWyKgCkngg@mail.gmail.com>
 <CAMRmmpKMxjjRShPY=VTJ+29eVY_hu-PTVAFsmhKpx1wRBi0akQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAMRmmpKMxjjRShPY=VTJ+29eVY_hu-PTVAFsmhKpx1wRBi0akQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 20, 2012 at 07:46:12AM -0700, Rock Lee wrote:
> Is there anyone who are tracking this issue?
> 

Yeah I'm working on it now.  It's a problem I've known about for a while but
haven't had a good reproducer or a good idea of how to fix it, but now it has my
full attention, hopefully I'll have something today or tomorrow.  Thanks,

Josef

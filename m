Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35938 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751559AbdFGDID (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Jun 2017 23:08:03 -0400
Date: Wed, 7 Jun 2017 11:08:01 +0800
From: Eryu Guan <eguan@redhat.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] generic: test Btrfs delalloc accounting overflow
Message-ID: <20170607030801.GU19952@eguan.usersys.redhat.com>
References: <49a0c7551c337566be29b2c073ba0be57779d321.1496391726.git.osandov@fb.com>
 <20170603073700.GA30383@infradead.org>
 <20170607000305.GB31692@vader.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170607000305.GB31692@vader.DHCP.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 05:03:05PM -0700, Omar Sandoval wrote:
> On Sat, Jun 03, 2017 at 12:37:00AM -0700, Christoph Hellwig wrote:
> > This looks like a btrfs-specific test, and not like a generic one
> > to me.
> 
> Nothing about the workload itself is btrfs-specific, we just have the
> extra check at the end. But I don't really care, I can make it a btrfs
> test unless Eryu has already applied it.

What's not very clear to me is that how do we check the accountings for
non-btrfs filesystems, i.e. what would cause a test failure on non-btrfs
filesystems besides an xfs_io write failure? I'd prefer a btrfs-specific
test if there's no good way to do the check. Or if we want to keep it a
generic test, some comments on the non-btrfs case would be good. I'm
fine with either way.

Thanks,
Eryu

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:33352 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbdFGDMn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 23:12:43 -0400
Received: by mail-pf0-f172.google.com with SMTP id 83so530263pfr.0
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Jun 2017 20:12:43 -0700 (PDT)
Date: Tue, 6 Jun 2017 20:12:41 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Eryu Guan <eguan@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] generic: test Btrfs delalloc accounting overflow
Message-ID: <20170607031241.GA8621@vader>
References: <49a0c7551c337566be29b2c073ba0be57779d321.1496391726.git.osandov@fb.com>
 <20170603073700.GA30383@infradead.org>
 <20170607000305.GB31692@vader.DHCP.thefacebook.com>
 <20170607030801.GU19952@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170607030801.GU19952@eguan.usersys.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 07, 2017 at 11:08:01AM +0800, Eryu Guan wrote:
> On Tue, Jun 06, 2017 at 05:03:05PM -0700, Omar Sandoval wrote:
> > On Sat, Jun 03, 2017 at 12:37:00AM -0700, Christoph Hellwig wrote:
> > > This looks like a btrfs-specific test, and not like a generic one
> > > to me.
> > 
> > Nothing about the workload itself is btrfs-specific, we just have the
> > extra check at the end. But I don't really care, I can make it a btrfs
> > test unless Eryu has already applied it.
> 
> What's not very clear to me is that how do we check the accountings for
> non-btrfs filesystems, i.e. what would cause a test failure on non-btrfs
> filesystems besides an xfs_io write failure? I'd prefer a btrfs-specific
> test if there's no good way to do the check. Or if we want to keep it a
> generic test, some comments on the non-btrfs case would be good. I'm
> fine with either way.
> 
> Thanks,
> Eryu

The only thing I can imagine other filesystems hitting would be an early
enospc or some sort of kernel warning, so I'll resend it as a btrfs test.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:33165 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbdFGReP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 13:34:15 -0400
Received: by mail-pg0-f53.google.com with SMTP id f185so7547500pgc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Jun 2017 10:34:15 -0700 (PDT)
Date: Wed, 7 Jun 2017 10:34:13 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: test Btrfs delalloc accounting overflow
Message-ID: <20170607173413.GA7481@vader.DHCP.thefacebook.com>
References: <e7bcf330422ed18883c9ad8ad4caa57624ed7cc0.1496818581.git.osandov@fb.com>
 <20170607093645.GZ19952@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170607093645.GZ19952@eguan.usersys.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 07, 2017 at 05:36:45PM +0800, Eryu Guan wrote:
> On Tue, Jun 06, 2017 at 11:57:10PM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > This is a regression test for "[PATCH] Btrfs: fix delalloc accounting
> > leak caused by u32 overflow". It creates a bunch of delalloc extents and
> > merges them together to make sure the accounting is done right.
> > 
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> 
> I refer to the patch by its commit id 8b8b08cbfb90 as well, and replaced
> xfs_io with $XFS_IO_PROG, and queued for next update.

Hi, Eryu,

8b8b08cbfb90 is actually a different fix, my patch isn't upstream yet
(but Dave has it queued up for 4.13).

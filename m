Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51168 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731532AbeGSN5O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 09:57:14 -0400
Date: Thu, 19 Jul 2018 15:13:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: ins: Add v2 ioctl support in logical-resolve
Message-ID: <20180719131358.GN26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <fe355417-0516-b27f-1114-a3777916fb87@jp.fujitsu.com>
 <3ed9676f-13e1-3072-5d2c-9b9e10fd36e5@gmx.com>
 <20180719055904.GK575@fnst.localdomain>
 <98442027-887b-d787-1a6b-f4014f95b846@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <98442027-887b-d787-1a6b-f4014f95b846@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2018 at 02:03:38PM +0800, Qu Wenruo wrote:
> >>>  cmds-inspect.c                                | 17 +++++++++++++++--
> >>>  ioctl.h                                       | 10 +++++++++-
> >>>  libbtrfsutil/btrfs.h                          | 10 +++++++++-
> >>
> >> Not related to this patch itself, but I'm wondering could we just use
> >> /usr/include/linux/btrfs.h?
> >>
> >> So we could save 2 same copies of headers here.
> > 
> > If we want to compile the newest btrfs-progs, but the older
> > /usr/include/linux/btrfs.h maybe doesn't have already defined the ioctl,
> > this will cause the compile error.
> 
> Makes sense.

Yeah, the system header may be missing or older than the btrfs-progs
version built. The linux/btrfs.h is exported from kernel sources and
should match ioctl.h, but both are managed in different projects so this
is a bit of duplication.

> > I am curious about why the
> > libbtrfsutil need to copy the part of ioctl.h instead of including the
> > ioctl.h directly?
> 
> Maybe for distribution purpose? Some binding may be delivered as
> independent package just as Omar tries to do.
> So in that case independent header makes sense.

And same here, there should be no fundamental difference in the
btrfs-progs and libbtrfsutil versions, but some level of independence is
desired for future changes.

In the end, all the three files should match as much as possible so it's
easy to open side by side diff in vim and just to see if there are parts
that need to be applied to the others. The might be some slight
differences like the __cpluplus protection but that are obvious in the
visual diff.

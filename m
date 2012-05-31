Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388Ab2EaSQC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 May 2012 14:16:02 -0400
Date: Thu, 31 May 2012 14:15:55 -0400
From: Josef Bacik <josef@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miao Xie <miaox@cn.fujitsu.com>,
        Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 2/2] Btrfs: fix wrong the mount information in /proc
Message-ID: <20120531181555.GF2080@localhost.localdomain>
References: <4FC7470A.7020005@cn.fujitsu.com>
 <20120531143605.GE11775@ZenIV.linux.org.uk>
 <20120531155304.GF11775@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120531155304.GF11775@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 31, 2012 at 04:53:04PM +0100, Al Viro wrote:
> On Thu, May 31, 2012 at 03:36:05PM +0100, Al Viro wrote:
> > On Thu, May 31, 2012 at 06:25:14PM +0800, Miao Xie wrote:
> > > +#include "../mount.h"
> > 
> > No.
> > 
> > > +	struct mount *r = real_mount(mnt);
> > 
> > And even more so.  Find a way to do that without layering violations or
> > live with the current behaviour.
> > 
> > Both patches NAKed with extreme prejudice.  Don't bring them back, you
> > are *not* going to get them in.  Any filesystem code that wants to do
> > that kind of thing is seriously out of luck.
> 
> BTW, resulting behaviour is bogus, regardless of layering violations  -
> note that device_list_add() renames existing btrfs_device.  *And* does so
> without holding ->device_list_mutex, so your patch would've cheerfully
> walked right into strcmp() vs. kfree() races.  And while the order of
> kfree vs. reassignment in device_list_add() is clearly wrong, flipping it
> won't fix that problem.
> 
> Try to formulate the rules for names you are generating - when do they
> change, what can we say about two mounts by comparing these names,
> when can two that used to give different names start giving the same
> and vice versa.  You won't be happy with the result.

I'm fixing this up right now and then I'll also fix the show_devname thing, we
can just keep track of which device mount() was called with so that we can print
that out and then if that device is ever removed we can just print out something
different.  Thanks,

Josef

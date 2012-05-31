Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:33092 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2EaPxH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 May 2012 11:53:07 -0400
Date: Thu, 31 May 2012 16:53:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 2/2] Btrfs: fix wrong the mount information in /proc
Message-ID: <20120531155304.GF11775@ZenIV.linux.org.uk>
References: <4FC7470A.7020005@cn.fujitsu.com>
 <20120531143605.GE11775@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120531143605.GE11775@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 31, 2012 at 03:36:05PM +0100, Al Viro wrote:
> On Thu, May 31, 2012 at 06:25:14PM +0800, Miao Xie wrote:
> > +#include "../mount.h"
> 
> No.
> 
> > +	struct mount *r = real_mount(mnt);
> 
> And even more so.  Find a way to do that without layering violations or
> live with the current behaviour.
> 
> Both patches NAKed with extreme prejudice.  Don't bring them back, you
> are *not* going to get them in.  Any filesystem code that wants to do
> that kind of thing is seriously out of luck.

BTW, resulting behaviour is bogus, regardless of layering violations  -
note that device_list_add() renames existing btrfs_device.  *And* does so
without holding ->device_list_mutex, so your patch would've cheerfully
walked right into strcmp() vs. kfree() races.  And while the order of
kfree vs. reassignment in device_list_add() is clearly wrong, flipping it
won't fix that problem.

Try to formulate the rules for names you are generating - when do they
change, what can we say about two mounts by comparing these names,
when can two that used to give different names start giving the same
and vice versa.  You won't be happy with the result.

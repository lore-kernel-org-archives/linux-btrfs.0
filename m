Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:37932 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab2EaOh5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 May 2012 10:37:57 -0400
Date: Thu, 31 May 2012 15:36:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 2/2] Btrfs: fix wrong the mount information in /proc
Message-ID: <20120531143605.GE11775@ZenIV.linux.org.uk>
References: <4FC7470A.7020005@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FC7470A.7020005@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 31, 2012 at 06:25:14PM +0800, Miao Xie wrote:
> +#include "../mount.h"

No.

> +	struct mount *r = real_mount(mnt);

And even more so.  Find a way to do that without layering violations or
live with the current behaviour.

Both patches NAKed with extreme prejudice.  Don't bring them back, you
are *not* going to get them in.  Any filesystem code that wants to do
that kind of thing is seriously out of luck.

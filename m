Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:55330 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbbC3DYY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Mar 2015 23:24:24 -0400
Received: from mailnull by bh-25.webhostbox.net with sa-checked (Exim 4.82)
	(envelope-from <linux@roeck-us.net>)
	id 1YcQJL-0040QU-7C
	for linux-btrfs@vger.kernel.org; Mon, 30 Mar 2015 03:24:23 +0000
Date: Sun, 29 Mar 2015 20:24:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fs: btrfs: Add missing include file
Message-ID: <20150330032413.GA26566@roeck-us.net>
References: <1426237126-9700-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426237126-9700-1-git-send-email-linux@roeck-us.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 13, 2015 at 01:58:46AM -0700, Guenter Roeck wrote:
> Building alpha:allmodconfig fails with
> 
> fs/btrfs/inode.c: In function 'check_direct_IO':
> fs/btrfs/inode.c:8050:2: error: implicit declaration of function 'iov_iter_alignment'
> 
> due to a missing include file.
> 
> Fixes: 3737c63e1fb0 ("fs: move struct kiocb to fs.h")
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---

This problem still affects the following builds as of today.

alpha:allmodconfig
i386:allyesconfig
i386:allmodconfig
m68k:allmodconfig
mips:allmodconfig
xtensa:allmodconfig

and thus probabably many other allmodconfig builds which I don't try to build.

This is getting really annoying, and prevents us from finding and fixing
other build problems.

It has been more than two weeks since I submitted the patch. This suggests 
that the patch got lost otr that the Powers That Be don't care. Which one
is it ?

Should I request to revert 3737c63e1fb0 instead ?

Guenter

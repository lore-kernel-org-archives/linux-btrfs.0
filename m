Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35288 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbbCMJOQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Mar 2015 05:14:16 -0400
Date: Fri, 13 Mar 2015 10:14:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fs: btrfs: Add missing include file
Message-ID: <20150313091413.GF20767@suse.cz>
Reply-To: dsterba@suse.cz
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

Acked-by: David Sterba <dsterba@suse.cz>

Thanks.

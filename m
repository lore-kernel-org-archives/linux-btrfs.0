Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56080 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1422896AbcIZRNb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 13:13:31 -0400
Date: Mon, 26 Sep 2016 19:11:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Jeff Mahoney <jeffm@suse.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, Filipe Manana <fdmanana@suse.com>,
        Omar Sandoval <osandov@fb.com>, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix btrfs_no_printk stub helper
Message-ID: <20160926171121.GE16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160923160532.3619432-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160923160532.3619432-1-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 23, 2016 at 06:05:21PM +0200, Arnd Bergmann wrote:
> The addition of btrfs_no_printk() caused a build failure when
> CONFIG_PRINTK is disabled:
> 
> fs/btrfs/send.c: In function 'send_rename':
> fs/btrfs/ctree.h:3367:2: error: implicit declaration of function 'btrfs_no_printk' [-Werror=implicit-function-declaration]
> 
> This moves the helper outside of that #ifdef so it is always
> defined, and changes the existing #ifdef to refer to that
> helper as well for consistency.
> 
> Fixes: 47c57058ff2c ("btrfs: btrfs_debug should consume fs_info when DEBUG is not defined")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: David Sterba <dsterba@suse.com>

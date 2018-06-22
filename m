Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57140 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751210AbeFVJiC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 05:38:02 -0400
Date: Fri, 22 Jun 2018 11:35:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Refactor count handling in
 btrfs_unpin_free_ino()
Message-ID: <20180622093510.GV24375@suse.cz>
Reply-To: dsterba@suse.cz
References: <20180622071829.1356-1-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20180622071829.1356-1-geert@linux-m68k.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 22, 2018 at 09:18:29AM +0200, Geert Uytterhoeven wrote:
> With gcc 4.1.2:
> 
>     fs/btrfs/inode-map.c: In function ‘btrfs_unpin_free_ino’:
>     fs/btrfs/inode-map.c:241: warning: ‘count’ may be used uninitialized in this function
> 
> While this warning is a false-positive, it can easily be killed by
> refactoring the code.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> Please review. Compile-tested only.

Reviewed-by: David Sterba <dsterba@suse.com>

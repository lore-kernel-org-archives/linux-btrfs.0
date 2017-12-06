Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50091 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751989AbdLFOZB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Dec 2017 09:25:01 -0500
Date: Wed, 6 Dec 2017 15:23:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Su Yue <suy.fnst@cn.fujitsu.com>, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: tree-checker: use %zu format string for size_t
Message-ID: <20171206142300.GA3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171206141844.788362-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171206141844.788362-1-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 06, 2017 at 03:18:14PM +0100, Arnd Bergmann wrote:
> The return value of sizeof() is of type size_t, so we must print it
> using the %z format modifier rather than %l to avoid this warning
> on some architectures:
> 
> fs/btrfs/tree-checker.c: In function 'check_dir_item':
> fs/btrfs/tree-checker.c:273:50: error: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'u32' {aka 'unsigned int'} [-Werror=format=]
> 
> Fixes: 005887f2e3e0 ("btrfs: tree-checker: Add checker for dir item")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: David Sterba <dsterba@suse.com>

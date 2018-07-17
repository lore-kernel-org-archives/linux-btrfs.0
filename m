Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54854 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731737AbeGQPhN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 11:37:13 -0400
Date: Tue, 17 Jul 2018 17:04:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Nikolay Borisov <nborisov@suse.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix size_t format string
Message-ID: <20180717150400.GA3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180717135236.3673195-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180717135236.3673195-1-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 17, 2018 at 03:52:27PM +0200, Arnd Bergmann wrote:
> The newly added check_block_group_item() function causes a build warning
> on 32-bit architectures:
> 
> fs/btrfs/tree-checker.c: In function 'check_block_group_item':
> fs/btrfs/tree-checker.c:404:41: error: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'unsigned int' [-Werror=format=]
> 
> The type of a sizeof() expression is size_t, which is correctly printed
> using the %zu format string.
> 
> Fixes: 9dc16aad5660 ("btrfs: tree-checker: Verify block_group_item")

Folded to the commit, thanks.

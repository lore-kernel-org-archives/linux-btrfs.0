Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45759 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753258AbdJMMIE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 08:08:04 -0400
Date: Fri, 13 Oct 2017 14:06:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: tree-checker: use %zu format string for size_t
Message-ID: <20171013120618.GH3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171013092759.712725-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171013092759.712725-1-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 13, 2017 at 11:27:35AM +0200, Arnd Bergmann wrote:
> We now get a harmless compile-time on 32-bit architectures:
> 
> fs/btrfs/tree-checker.c: In function 'check_extent_data_item':
> fs/btrfs/tree-checker.c:189:70: error: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'unsigned int' [-Werror=format=]
> 
> This changes the format string to use %zu instead of %lu for size_t.
> 
> Fixes: c1f6520bf360 ("btrfs: tree-checker: Enhance output for check_extent_data_item")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: David Sterba <dsterba@suse.com>

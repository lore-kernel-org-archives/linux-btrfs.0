Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45461 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754525AbdLGPKZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Dec 2017 10:10:25 -0500
Date: Thu, 7 Dec 2017 16:08:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        Qu Wenruo <wqu@suse.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: tree-checker: use %zu format string for size_t
Message-ID: <20171207150824.GG3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171206141844.788362-1-arnd@arndb.de>
 <a05374d3-401f-bec3-03f4-45d4072d43f4@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <a05374d3-401f-bec3-03f4-45d4072d43f4@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 07, 2017 at 08:32:04AM +0800, Qu Wenruo wrote:
> 
> 
> On 2017年12月06日 22:18, Arnd Bergmann wrote:
> > The return value of sizeof() is of type size_t, so we must print it
> > using the %z format modifier rather than %l to avoid this warning
> > on some architectures:
> > 
> > fs/btrfs/tree-checker.c: In function 'check_dir_item':
> > fs/btrfs/tree-checker.c:273:50: error: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'u32' {aka 'unsigned int'} [-Werror=format=]
> 
> Any idea about which architecture will cause such warning?
> On x86_64 I always fail to get such warning.

The intel 0-day build bot compiles on various architectures and 32/64
setups, I'm not sure if this warning has been reported, no such mail in
my mboxes.

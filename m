Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33522 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727329AbeGPPYw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 11:24:52 -0400
Date: Mon, 16 Jul 2018 16:56:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH RESEND 2/2] btrfs-progs: make all programs and libraries
 optional
Message-ID: <20180716145657.GK3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1531436967.git.osandov@fb.com>
 <116774c27511a8186b837f82053fbeba2a50d75c.1531436967.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <116774c27511a8186b837f82053fbeba2a50d75c.1531436967.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 12, 2018 at 04:11:19PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> We have a build system internally which only needs to build the
> libraries out of a repository, not any binaries. I looked at how this
> works with other projects, and the best example was util-linux, which
> makes it possible to enable or disable everything individually. This is
> nice and really flexible, so let's do the same. This way, if you only
> want to build and install libbtrfsutil, you can simply do
> 
>   ./configure --disable-documentation --disable-all-programs --enable-libbtrfsutil
>   make
>   make install

I think this is an overkill and abusing the --enable-XXX options.  You
want to avoid building the tools by default, so adding an option for
that is fine. Selectively building only certain tools can utilize that
option too and just follow with 'make btrfs-image' etc.

The number of --enable-* will stay minimal and we don't even have to
discuss how to find a good naming scheme (that works for util-linux but
looks a bit confusing for btrfs-progs).

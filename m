Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38717 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934905AbcJXMwJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 08:52:09 -0400
Date: Mon, 24 Oct 2016 14:52:05 +0200
From: David Sterba <dsterba@suse.cz>
To: slyich@gmail.com
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: [PATCH] ioctl.h: add missing kernel compatibility header for
 BUILD_ASSERT
Message-ID: <20161024125205.GB11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161024082912.20253-1-slyich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161024082912.20253-1-slyich@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Mon, Oct 24, 2016 at 09:29:12AM +0100, slyich@gmail.com wrote:
> From: Sergei Trofimovich <slyfox@gentoo.org>
> 
> Header breakage noticed by cynede. Reproducible as:
> 
>     $ gcc -c /usr/include/btrfs/ioctl.h -o /tmp/a.o
>         /usr/include/btrfs/ioctl.h:42:14: error: expected declaration specifiers or '...' before 'sizeof'
>      BUILD_ASSERT(sizeof(struct btrfs_ioctl_vol_args) == 4096);
>                   ^~~~~~
> 
> Basically gcc tries to say us BUILD_ASSERT is not visible.
> 
> BUILD_ASSERT lives in kerncompat.h which this change adds.

I think including the kerncompat.h is too intrusive here, I've fixed by
providing an empty macro if it's not defined. I'll release 4.8.2 soon.

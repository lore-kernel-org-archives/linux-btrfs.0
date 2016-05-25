Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbcEYUME (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 16:12:04 -0400
Date: Wed, 25 May 2016 22:11:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Al Viro <viro@zeniv.linux.org.uk>, kernel-team@fb.com,
        Omar Sandoval <osandov@fb.com>
Subject: Re: [PATCH] Btrfs: fix ->iterate_shared() by upgrading i_rwsem for
 delayed nodes
Message-ID: <20160525201129.GQ29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1e937bd41beebb68b1bf1201205059cb8f614dad.1463777299.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1e937bd41beebb68b1bf1201205059cb8f614dad.1463777299.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 20, 2016 at 01:50:33PM -0700, Omar Sandoval wrote:
> Commit fe742fd4f90f ("Revert "btrfs: switch to ->iterate_shared()"")
> backed out the conversion to ->iterate_shared() for Btrfs because the
> delayed inode handling in btrfs_real_readdir() is racy. However, we can
> still do readdir in parallel if there are no delayed nodes.

So this is for current master (pre 4.7-rc1), I'll add an appropriate
merge point for to my for-next.

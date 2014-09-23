Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37508 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbaIWMwp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 08:52:45 -0400
Date: Tue, 23 Sep 2014 15:03:40 +0200
From: David Disseldorp <ddiss@suse.de>
To: Filipe Manana <fdmanana@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: btrfs: add test regarding clearing
 compression flag/property
Message-ID: <20140923150340.10e84449@linux-1mn8>
In-Reply-To: <1410432334-21796-1-git-send-email-fdmanana@suse.com>
References: <1410432334-21796-1-git-send-email-fdmanana@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 11 Sep 2014 11:45:34 +0100, Filipe Manana wrote:

> Regression test for btrfs where removing the flag FS_COMPR_FL
> (chattr -c) from an inode wouldn't clear its compression property.
> This was fixed in the following linux kernel patch:
> 
>   Btrfs: add missing compression property remove in btrfs_ioctl_setflags
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

I would have expected this to fail with MOUNT_OPTIONS="-o compress=no",
but it looks as though Btrfs stores the attributes unconditionally.
Either way this change looks good to me.
Reviewed-by: David Disseldorp <ddiss@suse.de>

Cheers, David

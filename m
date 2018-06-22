Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34373 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932172AbeFVKvZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 06:51:25 -0400
Date: Fri, 22 Jun 2018 12:48:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Chengguang Xu <cgxu519@gmx.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: treat -ERANGE as an error case in btrfs_get_acl()
Message-ID: <20180622104831.GY24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180622025816.29239-1-cgxu519@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180622025816.29239-1-cgxu519@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 22, 2018 at 10:58:16AM +0800, Chengguang Xu wrote:
> Currently, when encoutering -ERANGE in btrfs_get_acl(),
> just set acl to NULL so that we cannot get proper
> acl information but the operation looks successful.

Do you have a reproducer for that?

ERANGE is returned from btrfs_getxattr in case the buffer is not large
enough to store the restult, but the first call to btrfs_getxattr will
read the size and then a temporary buffer of that size is allocated.

So ERANGE should not be able to make it to the the condition at all.

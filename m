Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38091 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932509AbeF0HYC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 03:24:02 -0400
Date: Wed, 27 Jun 2018 09:21:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Chengguang Xu <cgxu519@gmx.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 0/5] code cleanups for btrfs_get_acl()
Message-ID: <20180627072107.GQ27958@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180627041638.13210-1-cgxu519@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180627041638.13210-1-cgxu519@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 27, 2018 at 12:16:33PM +0800, Chengguang Xu wrote:
> This patch set does code cleanups for btrfs_get_acl().
> 
> Chengguang Xu (5):
>   btrfs: return error instead of crash when detecting unexpected type in
>     btrfs_get_acl()
>   btrfs: replace empty string with NULL when getting attribute length in
>     btrfs_get_acl()
>   btrfs: remove unnecessary -ERANGE check in btrfs_get_acl()
>   btrfs: avoid error code overriding in btrfs_get_acl()
>   btrfs: remove unnecessary bracket in btrfs_get_acl()

Perfect, that's exactly what I expected. Thanks.

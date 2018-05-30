Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60778 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752705AbeE3PgX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 11:36:23 -0400
Date: Wed, 30 May 2018 17:33:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: returns -ENOMEM if path allocation failed in
 btrfs_cross_ref_exist()
Message-ID: <20180530153338.GF3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180530020752.23788-1-suy.fnst@cn.fujitsu.com>
 <20180530064910.8724-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180530064910.8724-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 30, 2018 at 02:49:10PM +0800, Su Yue wrote:
> btrfs_alloc_path() may fail due to no enough memory,
> so let the function return -ENOMEM instead of -ENOENT is better.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Thanks. I've audited all return codes after failed path allocation, this
was the only one not matching.

The return code of btrfs_cross_ref_exist should be also distinguished at
the call sites, as both places expect only the ENOENT but should not
react to ENOMEM as if it were ENOENT.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39361 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754042AbdGJQyR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Jul 2017 12:54:17 -0400
Date: Mon, 10 Jul 2017 18:53:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Edmund Nadolski <enadolski@suse.com>
Cc: jeffm@suse.com, linux-btrfs@vger.kernel.org, lufq.fnst@cn.fujitsu.com
Subject: Re: [PATCH v2 07/13] btrfs: remove ref_tree implementation from
 backref.c
Message-ID: <20170710165303.GO2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170629035705.1589-1-enadolski@suse.com>
 <20170629035705.1589-8-enadolski@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170629035705.1589-8-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 28, 2017 at 09:56:59PM -0600, Edmund Nadolski wrote:
> Commit afce772e87c3 ("btrfs: fix check_shared for fiemap ioctl") added
> the ref_tree code in backref.c to reduce backref searching for
> shared extents under the FIEMAP ioctl. This code will not be
> compatible with the upcoming rbtree changes for improved backref
> searching, so this patch removes the ref_tree code.  The rbtree
> changes will provide the equivalent functionality for FIEMAP.
> 
> The above commit also introduced transaction semantics around calls to
> btrfs_check_shared() in order to accurately account for delayed refs.
> This functionality needs to be retained, so a complete revert of the
> above commit is not desirable. This patch therefore removes the
> ref_tree portion of the commit as above, however it does not remove
> the transaction portion.
> 
> Signed-off-by: Edmund Nadolski <enadolski@suse.com>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

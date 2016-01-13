Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758514AbcAMNbH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jan 2016 08:31:07 -0500
Date: Wed, 13 Jan 2016 14:31:02 +0100
From: David Sterba <dsterba@suse.cz>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Chris Mason <clm@fb.com>, Liu Bo <bo.li.liu@oracle.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] Btrfs: clean up an error code in btrfs_init_space_info()
Message-ID: <20160113133102.GQ4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160113122117.GB19993@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160113122117.GB19993@mwanda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 13, 2016 at 03:21:17PM +0300, Dan Carpenter wrote:
> If we return 1 here, then the caller treats it as an error and returns
> -EINVAL.  It causes a static checker warning to treat positive returns
> as an error.
> 
> Fixes: 1aba86d67f34 ('Btrfs: fix easily get into ENOSPC in mixed case')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> I would appreciate a little review here.  This patch doesn't change
> behavior, but it's possible that we had intended to do something else.

No, it makes sense to switch it to -EINVAL. Thanks.

Reviewed-by: David Sterba <dsterba@suse.com>

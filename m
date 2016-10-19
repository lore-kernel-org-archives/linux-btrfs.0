Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40176 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756905AbcJSOXw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 10:23:52 -0400
Date: Wed, 19 Oct 2016 16:05:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Chris Mason <clm@fb.com>, Omar Sandoval <osandov@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] Btrfs: remove some no-op casts
Message-ID: <20161019140542.GQ11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161012063924.GB13780@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161012063924.GB13780@mwanda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2016 at 11:33:21AM +0300, Dan Carpenter wrote:
> We cast 0 to a u8 but then because of type promotion, it's immediately
> cast to int back to int before we do a bitwise negate.  The cast doesn't
> matter in this case, the code works as intended.  It causes a static
> checker warning though so let's remove it.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applies to the free space tree fixes that are now in master.

Reviewed-by: David Sterba <dsterba@suse.com>

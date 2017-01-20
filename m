Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52568 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752075AbdATSMa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jan 2017 13:12:30 -0500
Date: Fri, 20 Jan 2017 19:11:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: constify struct btrfs_{,disk_}key wherever
 possible
Message-ID: <20170120181146.GD11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <28e17c356a456cd03635e6c6f2c7a46c82de45ac.1484724045.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <28e17c356a456cd03635e6c6f2c7a46c82de45ac.1484724045.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 17, 2017 at 11:24:37PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> In a lot of places, it's unclear when it's safe to reuse a struct
> btrfs_key after it has been passed to a helper function. Constify these
> arguments wherever possible to make it obvious.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> This applies to Dave's for-next branch. If it's too intrusive of a
> change, it can wait, but I think it's a nice cleanup.

Applies cleanly on the for 4.11 branch (that now has most of for-next),
thanks.

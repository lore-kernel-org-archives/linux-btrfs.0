From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] create/destroy io workqueues on module init/exit
Date: Mon, 16 Jun 2008 14:01:18 -0400
Message-ID: <20080616180118.GA19121@unused.rdu.redhat.com>
References: <20080616175423.GA17364@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080616175423.GA17364@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 16, 2008 at 01:54:23PM -0400, Josef Bacik wrote:
> Hello,
> 
> Theres a problem with btrfs where if you have more than one btrfs fs's mounted,
> if you unmount one of the fs's, and then do some work on the other fs, the box
> will panic.  This is because in close_ctree() we destroy the two global io
> workqueues, even though we're still using them for the other fs.  This patch
> moves the creation/destruction of the workqueues to the init/exit parts of the
> btrfs module.  I tested with this patch and my panic went away.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@redhat.com>
> 
>

Hmm sorry I pulled down the stable repo, not the unstable, ignore this.

Josef 

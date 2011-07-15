From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH 0/7] btrfs: don't BUG_ON btrfs_alloc_path errors
Date: Fri, 15 Jul 2011 14:10:27 +0900
Message-ID: <4E1FCBC3.9050402@jp.fujitsu.com>
References: <1310681702-13922-1-git-send-email-mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Mark Fasheh <mfasheh@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310681702-13922-1-git-send-email-mfasheh@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Mark,

(2011/07/15 7:14), Mark Fasheh wrote:
> Hi,
> 
> 	The following patches attempt to replace all the paths where we
> BUG_ON the return value of btrfs_alloc_path with proper error handling. It's
> pretty clear that these places aren't BUGing because of code error. To be
> explicit, much of the code is doing something like this:
> 
> 	path = btrfs_alloc_path();
> 	BUG_ON(!path);
> 
> which can be fixed by sending -ENOMEM back up the stack instead of the BUG.

I'm commenting to the similar patch posted before.
Please refer to the following mail.
  http://marc.info/?l=linux-btrfs&m=130258604905768&w=2

Thanks,
Tsutomu

> 
> 	The first patch in my series fixes the most trivial sites in one go.
> The patches after the 1st fix one (more complicated) site each. In the patch
> descriptions I try my best to describe the thought process that went behind
> each change.
> 
> 	Generally my guiding principle is that we want to "bubble up" some
> of the BUG_ON's that can be trapped and handled at a higher level -- the lower
> layer has an error and instead of killing the machine, sends it back up the
> stack for later handling
> 
> 	I tested the patches with some kernel builds and snapshot commands.
> Please review - comments and feedback are welcome.
> 
> The patches can also be had from git:
> 
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/btrfs-error-handling.git alloc_path
> 	--Mark
> 
> 
>  extent-tree.c |   20 +++++++++++++++-----
>  file-item.c   |    7 +++++--
>  file.c        |    3 ++-
>  inode.c       |   49 +++++++++++++++++++++++++++++++++++--------------
>  tree-log.c    |   12 +++++++++---
>  volumes.c     |   12 ++++++++----
>  6 files changed, 74 insertions(+), 29 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


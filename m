Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab3CARhL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Mar 2013 12:37:11 -0500
Message-ID: <5130E745.9010306@redhat.com>
Date: Fri, 01 Mar 2013 11:37:09 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: traverse to backup super-block only when
 indicated
References: <5127022B.6070200@oracle.com> <1362132800-29563-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1362132800-29563-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/1/13 4:13 AM, Anand Jain wrote:
> This patch adds 4th parameter to btrfs_scan_one_device()
> which when set to non-zero value will traverse to check
> backup super-block.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  btrfs-show.c      |  2 +-
>  btrfsctl.c        |  2 +-
>  cmds-device.c     |  4 ++--
>  cmds-filesystem.c |  4 ++--
>  cmds-replace.c    |  2 +-
>  disk-io.c         | 11 +++++++----
>  disk-io.h         |  3 ++-
>  find-root.c       |  6 +++---
>  utils.c           | 19 ++++++++++---------
>  utils.h           |  6 +++---
>  volumes.c         |  4 ++--
>  volumes.h         |  2 +-
>  12 files changed, 35 insertions(+), 30 deletions(-)
> 
> diff --git a/btrfs-show.c b/btrfs-show.c
> index 8210fd2..7b1a35f 100644
> --- a/btrfs-show.c
> +++ b/btrfs-show.c
> @@ -138,7 +138,7 @@ int main(int ac, char **av)
>  		search = av[optind];
>  	}
>  
> -	ret = btrfs_scan_one_dir("/dev", 0);
> +	ret = btrfs_scan_one_dir("/dev", 0, 1);

It might be helpful to define some self-documenting macros
for the 0/1 boolean args, which otherwise are pretty nonobvious.

i.e. BTRFS_SCAN_ALL_SB / BTRFS_SCAN_PRIMARY_SB or something
similar, also for the "run_ioctls" arg - maybe BTRFS_SCAN_REGISTER etc?

btrfs_scan_one_dir("/dev/", BTRFS_SCAN_REGISTER, BTRFS_SCAN_PRIMARY_SB)

is clearer than:

btrfs_scan_one_dir("/dev/", 1, 0);

Or maybe a flags var:

flags = BTRFS_SCAN_REGISTER | BTRFS_SCAN_PRIMARY_SB;
btrfs_scan_one_dir("/dev/", flags)

Or, depending on how things get called, maybe self-named wrappers:

btrfs_scan_one_dir_primary("/dev");

I think anything is better than a string of 0's & 1's :)

-Eric


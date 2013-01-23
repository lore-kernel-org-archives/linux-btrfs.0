Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo203.cox.net ([68.230.241.218]:59129 "EHLO
	eastrmfepo203.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab3AWV5o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 16:57:44 -0500
Received: from eastrmimpo305 ([68.230.241.237]) by eastrmfepo203.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130123215743.FXWN21186.eastrmfepo203.cox.net@eastrmimpo305>
          for <linux-btrfs@vger.kernel.org>;
          Wed, 23 Jan 2013 16:57:43 -0500
Message-ID: <51005CD6.7000202@czarc.net>
Date: Wed, 23 Jan 2013 16:57:42 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 00/10] add show sub-command for btrfs subvol cli
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/23/2013 03:12 AM, Anand Jain wrote:
> David, Gene
>
> Please accept this patch set which is on top of
>    git://repo.or.cz/btrfs-progs-unstable/devel.git for-chris
Oops.  I am sorry to rain on your parade but the patches need another 
rebasing.  The ones in "for-chris" are the original set of patches David 
pulled together.  The bigger list is in the "integration-20130121" 
branch and your current version does not apply.

However, you may want to wait a bit as David has a few more patches he  
is working on.  Also, one of the new (not in for-chris) patches has a 
conflict with another patch in the first set.

Gene
>
> to add 'show' sub-command feature for the btrfs subvol cli
> as in an example below..
>
> eg:
> btrfs su list /mnt
> ID 256 gen 54 top level 5 path sv1
> ID 278 gen 56 top level 5 path sv1/snap1
> ID 279 gen 54 top level 5 path sv2
> ID 280 gen 41 top level 5 path sv2/snap1
>
> btrfs su show /mnt/sv1
> /mnt/sv1
> 	Name: 			sv1
> 	uuid: 			3a914db2-8a40-1e49-9382-126c595e9abf
> 	Parent uuid: 		-
> 	Creation time: 		2013-01-10 12:16:18
> 	Object ID: 		256
> 	Generation (Gen): 	54
> 	Gen at creation: 	5
> 	Parent: 		5
> 	Top Level: 		5
> 	Snapshot(s):
> 				snap1
> 				<FS_TREE>/sv2/snap_sv1
>
> Anand Jain (10):
>    Btrfs-progs: move open_file_or_dir() to utils.c
>    Btrfs-progs: move printing subvol list outside of btrfs_list_subvols
>    Btrfs-progs: add parent uuid for snapshots
>    Btrfs-progs: move struct root_info to btrfs-list.h
>    Btrfs-progs: add function btrfs_get_subvol to get root_info of a
>      subvol
>    Btrfs-progs: add method to filter snapshots by parent uuid
>    Btrfs-progs: put find_mount_root() in commands.h
>    Btrfs-progs: make printing subvol extensible to newer layouts
>    Btrfs-progs: make get_subvol_name non cmds-send specific
>    Btrfs-progs: add show subcommand to subvol cli
>
>   Makefile         |   4 +-
>   btrfs-list.c     | 190 +++++++++++++++++++++++++++++++++-------------------
>   btrfs-list.h     |  58 +++++++++++++++-
>   btrfsctl.c       |   7 +-
>   cmds-balance.c   |   1 +
>   cmds-inspect.c   |   1 +
>   cmds-qgroup.c    |   1 +
>   cmds-quota.c     |   1 +
>   cmds-send.c      |  12 ++--
>   cmds-subvolume.c | 200 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
>   commands.h       |   7 +-
>   common.c         |  46 -------------
>   man/btrfs.8.in   |   6 ++
>   utils.c          |  30 ++++++++-
>   utils.h          |   3 +
>   15 files changed, 428 insertions(+), 139 deletions(-)
>   delete mode 100644 common.c
>


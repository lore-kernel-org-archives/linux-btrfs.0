Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34886 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab3AWIXU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 03:23:20 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r0N8NJoM009045
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2013 08:23:20 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r0N8NJU4000420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2013 08:23:19 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r0N8NIdr017797
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2013 02:23:18 -0600
Message-ID: <50FF9F9C.40205@oracle.com>
Date: Wed, 23 Jan 2013 16:30:20 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/11 V3] add show command to the subvol sub command
References: <1356664382-24423-1-git-send-email-Anand.Jain@oracle.com> <1357818083-15531-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1357818083-15531-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  kindly note
  The patch-set in this email-thread is now obsolete,
  since a newer patch-set[1] based on the git repo at
   git://repo.or.cz/btrfs-progs-unstable/devel.git for-chris
  has been submitted which IMO is easy and good for integration.

  [1]
  Subject: [PATCH 00/10] add show sub-command for btrfs subvol cli
  Date: Wed, 23 Jan 2013 16:12:41 +0800

Thanks, Anand


On 01/10/2013 07:41 PM, Anand Jain wrote:
> This is an attempt to make btrfs cli more end user friendly.
> And adds show subcommand to display all known (as of now)
> information of the given subvol including its snapshot(s).
>
> The below patch:
>   "Btrfs-progs: accommodate different layout for printing subvol list"
> obsoletes the previosuly submitted patch
>   "Btrfs-progs: make provision to print subvol list tree format"
>
> Please provide your review comments. Thanks.
>
> An example output:
>
> First list out all the subvols/snapshots using the list subcommand.
>
> btrfs su list /btrfs
> ID 256 gen 10 top level 5 path sv1
> ID 259 gen 6 top level 5 path sv1/snap
> ID 260 gen 7 top level 5 path snap
> ID 261 gen 8 top level 5 path sv2
> ID 262 gen 9 top level 5 path sv1/snap2
> ID 263 gen 10 top level 5 path sv1/snap3
>
> Then use show subcommand to know all known information about the
> given subvol.
>
> btrfs su show /btrfs/sv1
> /btrfs/sv1
> 	uuid: 			508b12a5-ed2a-3942-af63-830967201070
> 	Parent uuid: 		-
> 	Creation time: 		2013-01-07 13:53:30
> 	Object ID: 		256
> 	Generation (Gen): 	10
> 	Gen at creation: 	5
> 	Parent: 		5
> 	Top Level: 		5
> 	Snapshot(s):
> 				sv1/snap
> 				sv1/snap2
> 				sv1/snap3
>
>
> v2->v3: List snapshots of the given subvol if any.
>          Uses a more simple approach to obtain the snapshots.
>
> Anand Jain (11):
>    Btrfs-progs: move open_file_or_dir() to utils.c
>    Btrfs-progs: Move printing outside of btrfs_list_subvols
>    Btrfs-progs: add parent uuid for snapshots
>    Btrfs-progs: move struct root_info to btrfs-list.h
>    Btrfs-progs: function to get root_info of a subvol
>    Btrfs-progs: provide method to check if filter is set
>    Btrfs-progs: add method to filter snapshots by parent uuid
>    Btrfs-progs: put find_mount_root() in commands.h
>    Btrfs-progs: maintain similar case in heading prefix
>    Btrfs-progs: accommodate different layout for printing subvol list
>    Btrfs-progs: add show to display all known parameters of the given
>      subvol
>
>   Makefile         |    4 +-
>   btrfs-list.c     |  200 +++++++++++++++++++++++++++++++++++-------------------
>   btrfs-list.h     |   60 +++++++++++++++-
>   btrfsctl.c       |    7 +-
>   cmds-balance.c   |    1 +
>   cmds-inspect.c   |    1 +
>   cmds-qgroup.c    |    1 +
>   cmds-quota.c     |    1 +
>   cmds-subvolume.c |  172 +++++++++++++++++++++++++++++++++++++++++++++-
>   commands.h       |    6 +-
>   common.c         |   46 ------------
>   man/btrfs.8.in   |    6 ++
>   utils.c          |   30 ++++++++-
>   utils.h          |    3 +
>   14 files changed, 405 insertions(+), 133 deletions(-)
>   delete mode 100644 common.c
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

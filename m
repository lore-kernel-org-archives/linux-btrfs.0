Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47017 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3C0XSp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 19:18:45 -0400
Message-ID: <51537E1E.5060507@oracle.com>
Date: Thu, 28 Mar 2013 07:17:50 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: sandeen@redhat.com, dsterba@suse.cz
Subject: Re: [PATCH 0/5 v5] access to backup-sb and btrfs' multipath aware
References: <1362132800-29563-1-git-send-email-anand.jain@oracle.com> <1364378856-21053-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1364378856-21053-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  Any review comments on this ? pls.

Thanks, Anand


On 27/03/2013 18:07, Anand Jain wrote:
> We need a mechanism to tell when to use the backup super_block.
> To do this it needs a frame-work, and the patch #2 and #3 below
> provides the same without change in the logic.
>
> Its been found and posted to the list that check_mounted needs
> access to the backup-sb. so patch #3 adds flags parameter
> to the function btrfs_scan_one_device so that _only_
> check_mounted can set the flag to access the backup-sb.
>
> patch#4 below is to enable and disable acecss to backup-sb
> for only certain threads
>
> v4->v5:
> 	Rebase with integration-20130321 and with my own changes (patch #1)
> 	Allow check_mounted thread-path to use backup-sb
>
> v3->v4:
> 	Fixed some warnings introduced by patch #3 below,
> 	sorry my mistake.
>
> v2->v3:
>          Accepts David and Eric review, which would result in disabled
>            access to backup-superblock by default.
>          Dropped the patch
>                  [PATCH 3/3] btrfs-progs: use BTRFS_SCAN_BACKUP_SB flag in btrfs_scan_one_device
>          Introduced a new patch
>                  [PATCH 3/3] btrfs-progs: disable using backup superblock by default
>
> v1->v2:
>          Accepts Eric and Zach review.
>          Separates fix into 3 patches for easy logical understanding
>
> Anand Jain (5):
>    btrfs-progs: make btrfs dev scan multi path aware
>    btrfs-progs: Introduce flag BTRFS_SCAN_REGISTER to replace run_ioctl
>    btrfs-progs: Introduce flag BTRFS_SCAN_BACKUP_SB for
>      btrfs_read_dev_super
>    btrfs-progs: introduce passing flags to btrfs_scan_one_device
>    btrfs-progs: disable using backup superblock by default
>
>   cmds-device.c  | 57 +++++++++++++++++++++++++++++++++++++++++----------------
>   cmds-replace.c |  2 +-
>   disk-io.c      | 15 ++++++++++-----
>   disk-io.h      |  3 ++-
>   find-root.c    |  9 ++++++---
>   utils.c        | 57 +++++++++++++++++++++++++++++++++++++++------------------
>   utils.h        |  8 +++++---
>   volumes.c      |  6 ++++--
>   volumes.h      |  2 +-
>   9 files changed, 109 insertions(+), 50 deletions(-)
>

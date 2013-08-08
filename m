Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29662 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933922Ab3HHILD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 04:11:03 -0400
Message-ID: <52035290.6070405@oracle.com>
Date: Thu, 08 Aug 2013 16:10:56 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/2] scan /dev/mapper in filesystem show and device scan
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com> <1375949368-23798-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1375949368-23798-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Oh., I missed the libblkid part of David recommendation.
  I will be rewriting this patch set. sorry about that.

Thanks, Anand

On 08/08/2013 16:09, Anand Jain wrote:
> This patch brings the /dev/mapper to be used as the path for
> the btrfs kernel through dev scan
> 1/2 is the preparatory patch
>
> Anand Jain (2):
>    btrfs-progs: btrfs_scan_one_dir not to skip links when /dev/mapper is
>      provided
>    btrfs-progs: scan /dev/mapper in filesystem show and device scan
>
>   cmds-device.c     |  8 +++++++-
>   cmds-filesystem.c |  7 +++++--
>   man/btrfs.8.in    | 22 ++++++++++++----------
>   utils.c           | 22 +++++++++++++++++++---
>   utils.h           |  1 +
>   5 files changed, 44 insertions(+), 16 deletions(-)
>

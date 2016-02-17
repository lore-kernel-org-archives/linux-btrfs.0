Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161149AbcBQKtR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Feb 2016 05:49:17 -0500
Date: Wed, 17 Feb 2016 11:49:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 12/13] btrfs: introduce device delete by devid
Message-ID: <20160217104911.GS4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
 <1455328900-1476-13-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1455328900-1476-13-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 13, 2016 at 10:01:39AM +0800, Anand Jain wrote:
> +	if (vol_args->flags & BTRFS_DEVICE_BY_ID) {
> +		ret = btrfs_rm_device(root, NULL, vol_args->devid);
> +	} else {
> +		vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';

			       BTRFS_SUBVOL_NAME_MAX

Spotted by Chris,

fs/btrfs/ioctl.c:2703: warning: array subscript is above array bounds

my gcc version does not report that. Fixed and for-next pushed.

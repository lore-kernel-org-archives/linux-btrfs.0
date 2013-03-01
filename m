Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab3CAS1n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Mar 2013 13:27:43 -0500
Date: Fri, 1 Mar 2013 10:27:41 -0800
From: Zach Brown <zab@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: traverse to backup super-block only when
 indicated
Message-ID: <20130301182741.GW1658@lenny.home.zabbo.net>
References: <5127022B.6070200@oracle.com>
 <1362132800-29563-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362132800-29563-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 01, 2013 at 06:13:20PM +0800, Anand Jain wrote:
> This patch adds 4th parameter to btrfs_scan_one_device()
> which when set to non-zero value will traverse to check
> backup super-block.

Cool, thanks for working on this.

How'd you decide which callers wanted to scan the backups and which
didn't?  Where are the options to force checking the backups?  This
should be discussed in the commit message.

>  	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
> +		if (i > 0 && !rd_sb_mirror)
> +			break;

FWIW, I probably would have done something like

	max = rd_sb_mirror ? BTRFS_SUPER_MIRROR_MAX : 1;
  	for (i = 0; i < max; i++) {

> -		if((ret = btrfs_scan_for_fsid(fs_devices_mnt, total_devs, 1)))
> +		if((ret = btrfs_scan_for_fsid(fs_devices_mnt, total_devs, 1, 0)))

I agree with Eric.  The ", 1, 0" isn't great.  I guess I'd go for flags
(SCAN_REGISTER|SCAN_BACKUPS), but don't feel strongly about it.
Whatever feels least gross to you ;).

- z 

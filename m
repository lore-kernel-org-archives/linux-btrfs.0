Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33992 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729647AbeGMPbi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 11:31:38 -0400
Date: Fri, 13 Jul 2018 17:16:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, anand.jain@oracle.com, nborisov@suse.com
Subject: Re: [PATCH v4 1/2] btrfs: make fs_devices to be a local variable
Message-ID: <20180713151627.GZ3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1531376596-26333-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1531376596-26333-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 12, 2018 at 02:23:15PM +0800, Gu Jinxiang wrote:
> fs_devices is always passed to btrfs_scan_one_device which
> overrides it. And in the call stack below fs_devices is passed to
> btrfs_scan_one_device from btrfs_mount_root.
> And in btrfs_mount_root the output fs_devices of this call stack
> is not used.
> btrfs_mount_root
> 	-> btrfs_parse_early_options
> 		->btrfs_scan_one_device
> So, there is no necessary to pass fs_devices from btrfs_mount_root,
> use a local variable in btrfs_parse_early_options is enough.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> Reviewed-by: Anand Jain <Anand.Jain@oracle.com>

Please send cover letter for patch series (ie. > 1 patch).

I've applied both on top of recent patches that update some code around
device scanning and there were conflicts with patch 2, but simple to fix.
Please check the result in misc-next once it's pushed, thanks.

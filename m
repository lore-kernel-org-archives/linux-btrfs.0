Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52927 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425080AbcBRQt2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 11:49:28 -0500
Date: Thu, 18 Feb 2016 17:49:21 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH V3 2/2] btrfs-progs: Introduce device delete by devid
Message-ID: <20160218164921.GZ4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1444123990-8832-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444123990-8832-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 06, 2015 at 05:33:10PM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> This patch introduces new option <devid> for the command
> 
>   btrfs device delete <device_path|devid>[..]  <mnt>
> 
> In a user reported issue on a 3-disk-RAID1, one disk failed with its
> SB unreadable. Now with this patch user will have a choice to delete
> the device using devid.
> 
> The other method we could do, is to match the input device_path
> to the available device_paths with in the kernel. But that won't
> work in all the cases, like what if user provided mapper path
> when the path within the kernel is a non-mapper path.
> 
> This patch depends on the below kernel patch for the new feature to work,
> however it will fail-back to the old interface for the kernel without the
> patch
> 
>   Btrfs: Introduce device delete by devid
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Applied and refreshed.

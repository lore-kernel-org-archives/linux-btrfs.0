Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259AbbIYN6m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 09:58:42 -0400
Date: Fri, 25 Sep 2015 15:57:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: optimize not to scan repeated fsid
 mount points
Message-ID: <20150925135745.GH11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1442306783-1288-1-git-send-email-anand.jain@oracle.com>
 <1442306783-1288-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442306783-1288-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 15, 2015 at 04:46:23PM +0800, Anand Jain wrote:
> fsid can be mounted multiple times, with different subvolid.
> And we don't have to scan a mount point if we already have
> that in the scanned list.
> 
> And thus nicely avoids the following warning with multiple
> subvol mounts on older kernel like 2.6.32 where
> BTRFS_IOC_GET_FSLABEL ioctl does not exist.
> 
> ./btrfs fi show -m
> Label: none  uuid: 31845933-611e-422d-ae6f-386e57ad81aa
> 	Total devices 2 FS bytes used 172.00KiB
> 	devid    1 size 3.00GiB used 642.38MiB path /dev/sdd
> 	devid    2 size 3.00GiB used 622.38MiB path /dev/sde
> 
> warning, device 2 is missing
> warning devid 2 not found already
> warning, device 2 is missing
> warning devid 2 not found already
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Applied, thanks.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbaFCNlR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jun 2014 09:41:17 -0400
Date: Tue, 3 Jun 2014 15:41:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, jeffm@suse.com, dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH 5/6 v2] btrfs: create sprout should rename fsid on the
 sysfs as well
Message-ID: <20140603134115.GN22324@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com>
 <1401766564-7381-6-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401766564-7381-6-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 03, 2014 at 11:36:03AM +0800, Anand Jain wrote:
> Creating sprout will change the fsid of the mounted root.
> do the same on the sysfs as well.
> 
> reproducer:
>  mount /dev/sdb /btrfs (seed disk)
>  btrfs dev add /dev/sdc /btrfs
>  mount -o rw,remount /btrfs
>  btrfs dev del /dev/sdb /btrfs
>  mount /dev/sdb /btrfs
> 
> Error:
> kobject_add_internal failed for fe350492-dc28-4051-a601-e017b17e6145 with -EEXIST, don't try to register things with the same name in the same directory.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

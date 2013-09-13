Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35181 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab3IMQT0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 12:19:26 -0400
Date: Fri, 13 Sep 2013 18:19:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Frank Holton <fholton@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Add btrfs: prefix to kernel log output
Message-ID: <20130913161923.GM6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1379087210-21012-1-git-send-email-fholton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1379087210-21012-1-git-send-email-fholton@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 13, 2013 at 11:46:50AM -0400, Frank Holton wrote:
> The kernel log entries for device label %s and device fsid %pU
> are missing the btrfs: prefix. Add those here.
> 
> Signed-off-by: Frank Holton <fholton@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

> -		printk(KERN_INFO "device label %s ", disk_super->label);
> +		printk(KERN_INFO "btrfs: device label %s ", disk_super->label);

We can't use btrfs_info directly in this context, it wants a fs_info
pointer. Although btrfs_info calls to btrfs_printk that actually uses
fs_info only to get the superblock, this is not available at all
callsites either.

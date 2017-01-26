Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35670 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752875AbdAZIlS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jan 2017 03:41:18 -0500
Date: Thu, 26 Jan 2017 09:40:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Chris Mason <clm@fb.com>, Nikolay Borisov <n.borisov.lkml@gmail.com>,
        Josef Bacik <jbacik@fb.com>, kernel-janitors@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [patch] btrfs: white space cleanup in btrfs_log_inode()
Message-ID: <20170126084059.GB11951@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170125151126.GA27572@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170125151126.GA27572@mwanda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 25, 2017 at 06:11:26PM +0300, Dan Carpenter wrote:
> We accidentally deleted a new line in commit 0921910aa6fe ("btrfs: Make
> btrfs_log_inode take btrfs_inode")

Thanks, I've folded the change to the patch that introduced it.

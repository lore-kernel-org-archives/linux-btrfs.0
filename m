Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49984 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934392AbcLTPrN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Dec 2016 10:47:13 -0500
Date: Tue, 20 Dec 2016 16:46:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Colin King <colin.king@canonical.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Jeff Mahoney <jeffm@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove redundant inode null check
Message-ID: <20161220154655.GJ3620@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161216152446.23361-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161216152446.23361-1-colin.king@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 16, 2016 at 03:24:46PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The check for a null inode is redundant since the function
> is a callback for exportfs, which will itself crash if
> dentry->d_inode or parent->d_inode is NULL.  Removing the
> null check makes this consistent with other file systems.

This also means that the if (!dir) check is redundant. I've looked up
the call chain and haven't seen any instance that would lead to a NULL
dir down in the filesystem callback. So please remove both.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaKYQC5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 11:02:57 -0500
Date: Tue, 25 Nov 2014 17:02:56 +0100
From: David Sterba <dsterba@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        XFS Developers <xfs@oss.sgi.com>
Subject: Re: [PATCH-v3 6/6] btrfs: add an is_readonly() so btrfs can use
 common code for update_time()
Message-ID: <20141125160256.GH26471@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1416893674-419-1-git-send-email-tytso@mit.edu>
 <1416893674-419-7-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416893674-419-7-git-send-email-tytso@mit.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 25, 2014 at 12:34:34AM -0500, Theodore Ts'o wrote:
> The only reason btrfs cloned code from the VFS layer was so it could
> add a check to see if a subvolume is read-ony.  Instead of doing that,
> let's add a new inode operation which allows a file system to return
> an error if the inode is read-only, and use that in update_time().
> There may be other places where the VFS layer may want to know that
> btrfs would want to treat an inode is read-only.
> 
> With this commit, there are no remaining users of update_time() in the
> inode operations structure, so we can remove it and simply things
> further.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: linux-btrfs@vger.kernel.org

Reviewed-by: David Sterba <dsterba@suse.cz>

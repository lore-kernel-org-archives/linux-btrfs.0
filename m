Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaKYPvn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 10:51:43 -0500
Date: Tue, 25 Nov 2014 16:51:41 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Christoph Hellwig <hch@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] fs: split update_time() into update_time() and
 write_time()
Message-ID: <20141125155141.GF26471@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
 <1416599964-21892-2-git-send-email-tytso@mit.edu>
 <20141124152101.GA12575@infradead.org>
 <20141124173430.GB26471@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141124173430.GB26471@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 24, 2014 at 06:34:30PM +0100, David Sterba wrote:
> The btrfs_root_readonly checks in setxattr and removexattr are
> unnecessary because they're done through xattr_permisssion. I'll send a
> patch to remove them.

Does not work because the security.* and system.* namespaces do not call
the permission() hook, so no patch. However, if the proposed
inode_is_readonly callback is merged, we can replace the btrfs-specific
checks with is_readonly check in xattr_permission().

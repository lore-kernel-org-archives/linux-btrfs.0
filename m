Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38426 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752222AbeENKmH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 06:42:07 -0400
Date: Mon, 14 May 2018 12:39:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Chris Mason <clm@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC][PATCH] btrfs: take the last remnants of ->d_fsdata use out
Message-ID: <20180514103925.GF6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180513180317.GR30522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180513180317.GR30522@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 13, 2018 at 07:03:18PM +0100, Al Viro wrote:
> [spotted while going through ->d_fsdata handling around d_splice_alias();
> don't really care which tree that goes through]
> 
> The only thing even looking at ->d_fsdata in there (since 2012)
> had been kfree(dentry->d_fsdata) in btrfs_dentry_delete().  Which,
> incidentally, is all btrfs_dentry_delete() does.

Right, it's a leftover after the DCACHE_NEED_LOOKUP removal. I'll add it
to btrfs tree, thanks.

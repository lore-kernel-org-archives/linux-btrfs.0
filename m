Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:43253 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaKXWLs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 17:11:48 -0500
Date: Mon, 24 Nov 2014 17:11:45 -0500
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH-v2 0/5] add support for a lazytime mount option
Message-ID: <20141124221145.GB24003@fieldses.org>
References: <1416675267-2191-1-git-send-email-tytso@mit.edu>
 <20141124090755.GA28534@infradead.org>
 <20141124115727.GA19918@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141124115727.GA19918@thunk.org>
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 24, 2014 at 06:57:27AM -0500, Theodore Ts'o wrote:
> If we want to be paranoid, we handle i_version updates non-lazily; I
> can see arguments in favor of that.
> 
> Ext4 only enables MS_I_VERSION if the user asks for it explicitly, so
> it wouldn't cause me any problems.  However, xfs and btrfs enables it
> by default, so that means xfs and btrfs wouldn't see the benefits of
> lazytime (if you're going to have to push I_VERSION to disk, you might
> as well update the [acm]time while you're at it).  I've always thought
> that we *should* do is to only enable it if nfsv4 is serving the file
> system, and not otherwise, though, which would also give us
> consistency across all the file systems.

I guess you need to worry about the case where you shutdown nfsd, modify
a file, then restart nfsd--you don't want a client to miss the
modification in that case.

--b.

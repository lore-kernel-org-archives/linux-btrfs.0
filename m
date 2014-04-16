Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55220 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbaDPLJS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 07:09:18 -0400
Date: Wed, 16 Apr 2014 04:09:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linuxpatches@star.c10r.facebook.com
Subject: Re: [PATCH] Btrfs: implement inode_operations callback tmpfile
Message-ID: <20140416110916.GA10386@infradead.org>
References: <1396392799-9858-1-git-send-email-fdmanana@gmail.com>
 <1468801.p0fTO3mgjp@localhost.localdomain>
 <CAL3q7H68Z+6=oHUFMuHpkPET+Q-U23F_0W7rWEa7vXsGX_QgAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H68Z+6=oHUFMuHpkPET+Q-U23F_0W7rWEa7vXsGX_QgAg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 16, 2014 at 11:36:23AM +0100, Filipe David Manana wrote:
> The xattr is needed for the case where an acl is inherited. And 5
> units are required for orphan insertion (see comment on top of
> btrfs_orphan_add).
> I'll update the comment.

I don't think think a tmpfile should inherit any ACL, as it does not
have a parent.  Anyway, we're currently having a discussion on that on
various lists including linux-fsdevel.


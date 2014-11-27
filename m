Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33000 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaK0Qtx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Nov 2014 11:49:53 -0500
Date: Thu, 27 Nov 2014 08:49:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        XFS Developers <xfs@oss.sgi.com>
Subject: Re: [PATCH-v4 1/7] vfs: split update_time() into update_time() and
 write_time()
Message-ID: <20141127164952.GA1622@infradead.org>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
 <1416997437-26092-2-git-send-email-tytso@mit.edu>
 <20141126192328.GA20436@infradead.org>
 <20141127144116.GA14091@thunk.org>
 <20141127153315.GC14091@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141127153315.GC14091@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't think this scheme works well.  As mentioned earlier XFS doesn't
even use vfs dirty tracking at the moment, so introducing this in a
hidden way sounds like a bad idea.  Probably the same for btrfs.

I'd rather keep update_time as-is for now, don't add ->write_time and
let btrfs and XFS figure out how to implement the semantics on their
own.

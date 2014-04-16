Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35629 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbaDPL1B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 07:27:01 -0400
Date: Wed, 16 Apr 2014 04:27:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linuxpatches@star.c10r.facebook.com
Subject: Re: [PATCH] Btrfs: implement inode_operations callback tmpfile
Message-ID: <20140416112700.GA1187@infradead.org>
References: <1396392799-9858-1-git-send-email-fdmanana@gmail.com>
 <1468801.p0fTO3mgjp@localhost.localdomain>
 <CAL3q7H68Z+6=oHUFMuHpkPET+Q-U23F_0W7rWEa7vXsGX_QgAg@mail.gmail.com>
 <20140416110916.GA10386@infradead.org>
 <CAL3q7H5zO8nVrXRcdMwAa-6MDG_RFxUdWHpMV7MrY03Bvet3+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5zO8nVrXRcdMwAa-6MDG_RFxUdWHpMV7MrY03Bvet3+A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 16, 2014 at 12:25:07PM +0100, Filipe David Manana wrote:
> Interesting Christoph.
> I was following the ext4 implementation initially.
> 
> So it seems the question is still open, and none of the following
> alternatives is decided yet (unless I missed something in the thread
> at fsdevel):
> 
> 1) inherit acl from directory passed to the tmpfile handler;
> 2) inherit acl at link time from directory we're linking to;
> 3) don't inherit acls
> 
> Thanks for the heads up.

I'll make sure we'll have a testcase in xfstests to cover whatever
behavior we decide on to make sure all filesystems behave the same way.

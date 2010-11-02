From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] direct-io: btrfs: avoid splitting dio requests for
 non-btrfs filesystems
Date: Tue, 2 Nov 2010 14:58:33 -0400
Message-ID: <20101102185833.GA7404@infradead.org>
References: <4CD001A2.4000408@linux.vnet.ibm.com>
 <20101102145717.GA2531@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Josef Bacik <jbacik@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101102145717.GA2531@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 02, 2010 at 10:57:18AM -0400, Josef Bacik wrote:
> (which I did anyway because of my bug).  So maybe the right idea is to rip out
> my logical offset tests altogether and fix dio so we treat buffer_boundary()
> like gospel.  That way Btrfs can get what it needs without having this weird
> special code, and then we can look at how other fs's set buffer_boundary (I'm
> pretty sure ext2/3 are the only ones) and make sure they are setting it when
> they really mean to.

That sounds pretty reasonable to me.  I really don't like the flag in
the kiocb in this patch, and handling it as part of the get_blocks
callback sounds much better to me.  I don't know enough about the
bounary blocks to know if we can reuse them - if we can it's perfect,
if not another buffer flag seems like the way to go.


From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 0/5] btrfs-progs: Create libbtrfs and package it up
Date: Fri, 13 Jun 2008 16:29:53 -0400
Message-ID: <20080613202953.GA8819@infradead.org>
References: <20080613200906.180149089@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Jeff Mahoney <jeffm@jeffreymahoney.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080613200906.180149089@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 13, 2008 at 04:09:06PM -0400, Jeff Mahoney wrote:
> lib contains the objects that used to be $(COMMON_OBJS), but are now
> a full-fledged shared library with supporting includes to be installed
> in /usr/include/btrfs. Headers are also placed in lib so that patches
> indended for the kernel can also apply to the library without a lot of
> effort.

I don't think making this a public library yet is a good idea, the API
will change frequently and it'll be a pain to keep it uptodate.  Just
make it an internal static library for now.


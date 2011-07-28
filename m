From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfstests: Add support for btrfs in 015
Date: Thu, 28 Jul 2011 16:05:37 -0400
Message-ID: <20110728200537.GA12758@infradead.org>
References: <cover.1311776403.git.sbehrens@giantdisaster.de>
 <bebfc5c98e0fb878f55c1312d8750ce7b7f82e07.1311776403.git.sbehrens@giantdisaster.de>
 <20110728084756.GC3407@infradead.org>
 <4E31A265.5050909@giantdisaster.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
To: Stefan Behrens <sbehrens@giantdisaster.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4E31A265.5050909@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 28, 2011 at 07:54:45PM +0200, Stefan Behrens wrote:
> To add a 10% tolerance for btrfs was a bad idea.
> Since the output of df(1) is not yet reliable on btrfs volumes while
> data is not flushed to disk, the better implementation would be to
> either let this test fail, or to force a flush to disk before taking
> the output of df(1).
> The latter is what I have implemented now.

I don't think it's correct either.  dellalloc blocks should be included
in the statfs output, else it it is pretty pointless.  Can you send the
patch to make it generic without that adjustment for now.


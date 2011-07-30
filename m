From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/4] xfstests: Changed test 062 to be generic for all
 filesystems
Date: Sat, 30 Jul 2011 10:25:30 -0400
Message-ID: <20110730142530.GA31200@infradead.org>
References: <cover.1311953979.git.sbehrens@giantdisaster.de>
 <95dfa968c48d2bd1095876a6db3369672e76db5f.1311953979.git.sbehrens@giantdisaster.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
To: Stefan Behrens <sbehrens@giantdisaster.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <95dfa968c48d2bd1095876a6db3369672e76db5f.1311953979.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 29, 2011 at 06:06:58PM +0200, Stefan Behrens wrote:
> Changed the test 062 to be generic for all filesystems and to be
> executed for all filesystems.
> Remove output of mkfs since this is specific to mkfs.xfs and now
> filtered out.

The first three patches look good, but can you please merge them into
on.  And maybe make the subject description a bit less verbose, e.g.

xfstests: make more tests generic

Use _scratch_mkfs / _scratch_mkfs_sized instead of _scratch_mkfs_xfs
where possible. 


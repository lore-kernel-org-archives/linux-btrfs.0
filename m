From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfstests: Add support for btrfs in 062
Date: Thu, 28 Jul 2011 04:45:04 -0400
Message-ID: <20110728084504.GA3407@infradead.org>
References: <cover.1311776403.git.sbehrens@giantdisaster.de>
 <d42f34a30289157f262ffe31760a54cc1b5d3d4b.1311776403.git.sbehrens@giantdisaster.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
To: Stefan Behrens <sbehrens@giantdisaster.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <d42f34a30289157f262ffe31760a54cc1b5d3d4b.1311776403.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 28, 2011 at 10:27:58AM +0200, Stefan Behrens wrote:
> Added btrfs to the list of supported filesystems for this test.
> Remove output of mkfs since this is specific to mkfs.xfs and now filtered
> out.

Why can't it be generic?  Any reason this one doesn't work on e.g. ext2
or reiserfs?


From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: add test 254 for testing basic btrfs volume
 functionality
Date: Wed, 25 May 2011 03:54:28 -0400
Message-ID: <20110525075428.GA11150@infradead.org>
References: <1306268763-7932-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306268763-7932-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 24, 2011 at 04:26:03PM -0400, Josef Bacik wrote:
> This test just runs through all of the basic btrfs commands that manipulate our
> subvolume stuff.  It creates a snapshot, a subvolume, sets the subvolume as a
> default, lists the volumes and deletes the snapshot.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>

Thanks, applied.


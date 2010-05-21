From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] fs: kill blockdev_direct_IO_no_locking
Date: Fri, 21 May 2010 11:21:22 -0400
Message-ID: <20100521152122.GC16049@infradead.org>
References: <1274300694-8976-1-git-send-email-josef@redhat.com> <1274300694-8976-4-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	akpm@linux-foundation.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1274300694-8976-4-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 19, 2010 at 04:24:52PM -0400, Josef Bacik wrote:
> Christoph said he'd rather everybody use __blockdev_direct_IO directly instead
> of having a bunch of random helper functions, so thats what this patch does.
> It's a basic change, I've tested it with xfstests on ext4 and xfs.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>

Ok,


Reviewed-by: Christoph Hellwig <hch@lst.de>


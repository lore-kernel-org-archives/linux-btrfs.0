From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Btrfs: add a "df" ioctl for btrfs
Date: Wed, 13 Jan 2010 16:46:20 -0500
Message-ID: <20100113214620.GA27943@infradead.org>
References: <20100112202513.GA13414@localhost.localdomain> <20100113102503.GA6887@infradead.org> <20100113142923.GL14979@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100113142923.GL14979@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 13, 2010 at 09:29:23AM -0500, Chris Mason wrote:
> This is more than just df being inaccurate, it's a way to find out how
> much space is used by each of the raid modes.  We've had a ton of
> feature requests for this, and it really helps identify drives that have
> a ton of free space tied up for data vs metadata.

Which again is not a fs specific feature.  Much better to add a statfs
revision to the core that does this for everone.  That would also
have the nice side effect that we could actually make it statvfs and
could get rid of the braindamage in glibc's current statvfs wrapper.


From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/8] remove i_alloc_sem
Date: Mon, 20 Jun 2011 16:32:11 -0400
Message-ID: <20110620203211.GA2290@infradead.org>
References: <20110620201533.847236272@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com, jlbec@evilplan.org
To: viro@zeniv.linux.org.uk, tglx@linutronix.de
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20110620201533.847236272@bombadil.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 20, 2011 at 04:15:33PM -0400, Christoph Hellwig wrote:
> This series removes it in favour of a simpler counter scheme, thus getting
> rid of the rw_semaphore non-owner APIs as requests by Thomas, while at the
> same time shrinking the size of struct inode by 160 bytes on 64-bit systems.

This should be 160 bits, aka 20 bytes of course, sorry.


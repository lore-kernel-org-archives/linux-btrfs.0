From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Rename BTRfs to MuchSlowerFS ?
Date: Mon, 5 Sep 2011 12:25:21 -0400
Message-ID: <20110905162521.GA29124@infradead.org>
References: <4E64F77B.1090401@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E64F77B.1090401@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 05, 2011 at 06:23:23PM +0200, Tomasz Chmielewski wrote:
> >   That's because dpkg is known for using (f)sync very heavily.  btrfs
> >honours the sync request in all cases, so it's much much slower than
> >ext3, which doesn't.
> 
> Hmm, is it really the case with ext3/ext4 (ignoring fsync in some cases)?
> 
> Sounds like a bug in ext3/ext4 then.
> 
> Is it documented anywhere where ext3/ext4 would just silently ignore fsync?

They don't.  Unteil recently ext3 and reiserfs would not flush the
disk caches unless enabled by a mount option, but even that has recently
been fixed.

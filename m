From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Add a new file op for fsync to give fs's more control
Date: Fri, 15 Apr 2011 15:49:27 -0400
Message-ID: <20110415194927.GA4225@infradead.org>
References: <1302894582-24341-1-git-send-email-josef@redhat.com>
 <20110415192412.GA17974@infradead.org>
 <1302896032-sup-86@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Josef Bacik <josef@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1302896032-sup-86@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 15, 2011 at 03:34:57PM -0400, Chris Mason wrote:
> Excerpts from Christoph Hellwig's message of 2011-04-15 15:24:12 -0400:
> > Sorry, but this is too ugly to live.  If the reason for this really is
> > good enough we'll just need to push the filemap_write_and_wait_range
> > and i_mutex locking into every ->fsync instance.
> > 
> 
> Which part is too ugly to live?  The special op? New parameters?

Two different fsync ops, when we could triviall do with one by pushing
things down.


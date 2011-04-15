From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] Add a new file op for fsync to give fs's more control
Date: Fri, 15 Apr 2011 15:34:57 -0400
Message-ID: <1302896032-sup-86@think>
References: <1302894582-24341-1-git-send-email-josef@redhat.com> <20110415192412.GA17974@infradead.org>
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20110415192412.GA17974@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Christoph Hellwig's message of 2011-04-15 15:24:12 -0400:
> Sorry, but this is too ugly to live.  If the reason for this really is
> good enough we'll just need to push the filemap_write_and_wait_range
> and i_mutex locking into every ->fsync instance.
> 

Which part is too ugly to live?  The special op? New parameters?

The unconditional taking of i_mutex hurts a lot, especially on directory
fsyncs, so I'd love to get rid of it.

-chris

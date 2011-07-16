From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: tag pages for writeback in sync
Date: Fri, 15 Jul 2011 20:47:23 -0400
Message-ID: <4E20DF9B.8010003@redhat.com>
References: <1310765198-10077-1-git-send-email-josef@redhat.com> <20110715215011.GA32601@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110715215011.GA32601@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/15/2011 05:50 PM, Christoph Hellwig wrote:
> On Fri, Jul 15, 2011 at 05:26:38PM -0400, Josef Bacik wrote:
>> Everybody else does this, we need to do it too.  If we're syncing, we need to
>> tag the pages we're going to write for writeback so we don't end up writing the
>> same stuff over and over again if somebody is constantly redirtying our file.
>> This will keep us from having latencies with heavy sync workloads.  Thanks,
>
> Maybe it's time to find a wait to merge the btrfs copy of write_cache_pages
> back into the main one?

I looked at it, but we need to be able to call a special helper to lock 
the page for our btree pages, and we can queue up a bio in order to add 
pages to it from delalloc which we will submit if we have to wait on a 
page to complete writeback.  Maybe I can use the block plugging stuff 
instead of our bio thing so that if we have to wait it will get flushed 
automatically, then that just leaves our locking thing which I guess 
would be ok to pass down to write_cache_pages?  Thanks,

Josef

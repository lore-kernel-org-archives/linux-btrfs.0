From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Btrfs: tag pages for writeback in sync
Date: Fri, 15 Jul 2011 17:50:11 -0400
Message-ID: <20110715215011.GA32601@infradead.org>
References: <1310765198-10077-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310765198-10077-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 15, 2011 at 05:26:38PM -0400, Josef Bacik wrote:
> Everybody else does this, we need to do it too.  If we're syncing, we need to
> tag the pages we're going to write for writeback so we don't end up writing the
> same stuff over and over again if somebody is constantly redirtying our file.
> This will keep us from having latencies with heavy sync workloads.  Thanks,

Maybe it's time to find a wait to merge the btrfs copy of write_cache_pages
back into the main one?


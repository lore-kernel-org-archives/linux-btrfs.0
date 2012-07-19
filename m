Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:36729 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab2GSCFc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jul 2012 22:05:32 -0400
Date: Thu, 19 Jul 2012 04:05:19 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: David Sterba <dave@jikos.cz>, linux-btrfs@vger.kernel.org,
        chris.mason@fusionio.com, JBacik@fusionio.com
Subject: Re: [PATCH v3] Btrfs: improve multi-thread buffer read
Message-ID: <20120719020518.GE17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1342461925-22495-1-git-send-email-liubo2009@cn.fujitsu.com>
 <20120718115735.GI11226@twin.jikos.cz>
 <50075EAA.9030806@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50075EAA.9030806@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2012 at 09:11:06AM +0800, Liu Bo wrote:
> On 07/18/2012 07:57 PM, David Sterba wrote:
> 
> > On Mon, Jul 16, 2012 at 02:05:25PM -0400, Liu Bo wrote:
> >> v2->v3: adopt kernel native pagevec instead of kmalloc.
> > 
> > Do we really use the pagevec features here? It looks more like a fancy
> > way to employ a simple array ...
> > 
> > And with a simple array we could use 16 page pointers covering 16 * 4k =
> > 64k bytes which looks more friendly than 14 * 4K = 56K (available in a
> > pagevec). This may have a negative effect on the troughput, but I
> > haven't measured that. Can you please benchmark it against pagevec?
> > 
> 
> 
> Thanks for the advice.
> 
> Yes, it is a simple array that is needed.
> 
> Indeed I even tried 128 page array, with which I can get the biggest improvement on my box.
> Basically in range [1, 128], the more pages in the array, the bigger improvement we'll get.

128 is too much, this would snip 128 * 8 = 1K off the stack.

> But as Chris suggested, my test is really a race case in practical use, half of improvement
> is somehow enough, so we turn to use pagevec struct because it is closer to how we solve
> similar problems in other parts of the kernel.

Yes it's an optimization, nice and simple one, but I don't see the
use of pagevec justified. By the other parts of kernel is probably meant
memory management, and pagevec's are used along with lookups to inode
mappings, plus there are other sideefects on pagecache (like calling
lru_add_drain() from pagevec_release, as can be seen in your code).

Filesystems can use pagevec_lookup instead of find_get_pages,
like ext4 does, but btrfs uses simple arrays of 16 pages, in
lock_delalloc_pages, end_compressed_writeback, __unlock_for_delalloc and
extent_clear_unlock_delalloc (in connection with find_get_pages).

I was specifically interested in benchmarking pagevec used as in V3
against simple array with 16 elements, but now that I looked around
while writing this mail, I think that pagevec is not the way to go.


david

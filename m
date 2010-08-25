From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Wed, 25 Aug 2010 15:35:42 +0200
Message-ID: <1282743342.2605.3707.camel@laptop>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
	 <1282656558.2605.2742.camel@laptop> <4C73CA24.3060707@fusionio.com>
	 <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com>
	 <20100825112433.GB4453@thunk.org> <1282736132.2605.3563.camel@laptop>
	 <20100825115709.GD4453@thunk.org> <1282740516.2605.3644.camel@laptop>
	 <20100825132417.GQ31488@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ted Ts'o <tytso@mit.edu>, David Rientjes <rientjes@google.com>,
	Jens Axboe <jaxboe@fusionio.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"cluster-devel@redhat.com" <cluster-devel@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20100825132417.GQ31488@dastard>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2010-08-25 at 23:24 +1000, Dave Chinner wrote:
> 
> That is, the guarantee that we will always make progress simply does
> not exist in filesystems, so a mempool-like concept seems to me to
> be doomed from the start.... 

While I appreciate that it might be somewhat (a lot) harder for a
filesystem to provide that guarantee, I'd be deeply worried about your
claim that its impossible.

It would render a system without swap very prone to deadlocks. Even with
the very tight dirty page accounting we currently have you can fill all
your memory with anonymous pages, at which point there's nothing free
and you require writeout of dirty pages to succeed.


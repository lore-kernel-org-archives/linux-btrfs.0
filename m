From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 0/2]btrfs: add two ioctls to do metadata readahead
Date: Mon, 19 Jul 2010 04:03:54 -0400
Message-ID: <20100719080354.GA12808@infradead.org>
References: <1279094536.1528.93.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	"Wu, Fengguang" <fengguang.wu@intel.com>
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1279094536.1528.93.camel@sli10-desk.sh.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

This seems like iteration 66 of the ill fated mobling readahead crap.

Please go to linux-fsdevel to define a proper interface instead of
your per-filesystem hacks.  I had hoped Arjan got it after the last big
flameware, but it seems like you're only moving from one target to the
next.

NACK in this current form.


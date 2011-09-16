From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/7] BTRFS: Fix lseek return value for error
Date: Fri, 16 Sep 2011 09:38:31 -0700
Message-ID: <20110916163831.GA24876@tassilo.jf.intel.com>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
 <1316128013-21980-2-git-send-email-andi@firstfloor.org>
 <20110916154815.GA27150@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110916154815.GA27150@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 16, 2011 at 11:48:15AM -0400, Christoph Hellwig wrote:
> On Thu, Sep 15, 2011 at 04:06:47PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Introduced by 9a4327ca1f45f82edad7dc0a4e52ce9316e0950c
> 
> I think this should go to Chris/Linus ASAP.  But a slightly better
> patch description wouldn't hurt either.

Josef acked it earlier, but with a missing Chris the btrfs merge
pipeline seems to be disfunctional at the moment.

-Andi

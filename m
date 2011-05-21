From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] fs: add a DCACHE_NEED_LOOKUP flag for d_flags
Date: Sat, 21 May 2011 05:00:50 +0200
Message-ID: <20110521030050.GT12317@one.firstfloor.org>
References: <1305827929-18491-1-git-send-email-josef@redhat.com> <m2hb8pyw4b.fsf@firstfloor.org> <7B320C9C-0748-419B-9E40-7A15397E0064@dilger.ca> <20110520213112.GS12317@one.firstfloor.org> <4DD7079B.6070302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Andreas Dilger <adilger@dilger.ca>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"hch@lst.de" <hch@lst.de>,
	"aarcange@redhat.com" <aarcange@redhat.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DD7079B.6070302@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 20, 2011 at 08:30:19PM -0400, Josef Bacik wrote:
> On 05/20/2011 05:31 PM, Andi Kleen wrote:
> >> Putting them at the end of the cache LRU instead of the head would allow them to be dropped quickly under memory pressure. 
> > 
> > This still would fill up your memory for find /, potentially pushing
> > out other stuff.
> > 
> > -Andi
> 
> So these things are just hashed on dput, so they don't have any
> references to them and they are automatically put on the LRU list, so if
> we get under memory pressure they will be easily discarded, especially
> if nobody is actually stating them.  Thanks,

They are allocated. The allocation will push out other things too.
There's no mechanism to only push dentries when allocating other dentries,
or limit the total consumption from the dcache.

-Andi

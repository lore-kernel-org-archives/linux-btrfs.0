From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/2] fs: add a DCACHE_NEED_LOOKUP flag for d_flags
Date: Fri, 20 May 2011 20:30:19 -0400
Message-ID: <4DD7079B.6070302@redhat.com>
References: <1305827929-18491-1-git-send-email-josef@redhat.com> <m2hb8pyw4b.fsf@firstfloor.org> <7B320C9C-0748-419B-9E40-7A15397E0064@dilger.ca> <20110520213112.GS12317@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"hch@lst.de" <hch@lst.de>,
	"aarcange@redhat.com" <aarcange@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110520213112.GS12317@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/20/2011 05:31 PM, Andi Kleen wrote:
>> Putting them at the end of the cache LRU instead of the head would allow them to be dropped quickly under memory pressure. 
> 
> This still would fill up your memory for find /, potentially pushing
> out other stuff.
> 
> -Andi

So these things are just hashed on dput, so they don't have any
references to them and they are automatically put on the LRU list, so if
we get under memory pressure they will be easily discarded, especially
if nobody is actually stating them.  Thanks,

Josef

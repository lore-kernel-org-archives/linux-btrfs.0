From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2] fs: add a DCACHE_NEED_LOOKUP flag for d_flags
Date: Fri, 20 May 2011 14:51:16 -0600
Message-ID: <7B320C9C-0748-419B-9E40-7A15397E0064@dilger.ca>
References: <1305827929-18491-1-git-send-email-josef@redhat.com> <m2hb8pyw4b.fsf@firstfloor.org>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"hch@lst.de" <hch@lst.de>,
	"aarcange@redhat.com" <aarcange@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <m2hb8pyw4b.fsf@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 2011-05-20, at 2:07 PM, Andi Kleen <andi@firstfloor.org> wrote:

> Josef Bacik <josef@redhat.com> writes:
> 
>> Btrfs (and I'd venture most other fs's) stores its indexes in nice disk order
>> for readdir, but unfortunately in the case of anything that stats the files in
>> order that readdir spits back (like oh say ls) that means we still have to do
>> the normal lookup of the file, which means looking up our other index and then
>> looking up the inode.  What I want is a way to create dummy dentries when we
>> find them in readdir so that when ls or anything else subsequently does a
>> stat(), we already have the location information in the dentry and can go
> 
> Funny I remember discussing this optimization a long time ago with
> Andrea. But the problem is still that it has the potential to pollute
> the dcache a lot when someone is reading a large directory.
> 
> Consider the find / case. You don't want that to turn over all
> of your dcache.
> 
> So if you do that you need some way to put the dummy dentries on a
> special LRU list that gets cleaned quickly and is kept small.

Actually, I recall years ago looking into something similar. It should be possible to drop such dentries even under GFP_NOFS because they can't be dirty and don't need any inode operations to free.

Putting them at the end of the cache LRU instead of the head would allow them to be dropped quickly under memory pressure. 

Cheers, Andreas
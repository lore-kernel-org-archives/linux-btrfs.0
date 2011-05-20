From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] fs: add a DCACHE_NEED_LOOKUP flag for d_flags
Date: Fri, 20 May 2011 13:07:00 -0700
Message-ID: <m2hb8pyw4b.fsf@firstfloor.org>
References: <1305827929-18491-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	viro@ZenIV.linux.org.uk, hch@lst.de, aarcange@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1305827929-18491-1-git-send-email-josef@redhat.com> (Josef
	Bacik's message of "Thu, 19 May 2011 13:58:48 -0400")
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik <josef@redhat.com> writes:

> Btrfs (and I'd venture most other fs's) stores its indexes in nice disk order
> for readdir, but unfortunately in the case of anything that stats the files in
> order that readdir spits back (like oh say ls) that means we still have to do
> the normal lookup of the file, which means looking up our other index and then
> looking up the inode.  What I want is a way to create dummy dentries when we
> find them in readdir so that when ls or anything else subsequently does a
> stat(), we already have the location information in the dentry and can go

Funny I remember discussing this optimization a long time ago with
Andrea. But the problem is still that it has the potential to pollute
the dcache a lot when someone is reading a large directory.

Consider the find / case. You don't want that to turn over all
of your dcache.

So if you do that you need some way to put the dummy dentries on a
special LRU list that gets cleaned quickly and is kept small.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

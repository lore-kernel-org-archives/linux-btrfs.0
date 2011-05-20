From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] fs: add a DCACHE_NEED_LOOKUP flag for d_flags
Date: Fri, 20 May 2011 23:31:12 +0200
Message-ID: <20110520213112.GS12317@one.firstfloor.org>
References: <1305827929-18491-1-git-send-email-josef@redhat.com> <m2hb8pyw4b.fsf@firstfloor.org> <7B320C9C-0748-419B-9E40-7A15397E0064@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, Josef Bacik <josef@redhat.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"hch@lst.de" <hch@lst.de>,
	"aarcange@redhat.com" <aarcange@redhat.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <7B320C9C-0748-419B-9E40-7A15397E0064@dilger.ca>
List-ID: <linux-btrfs.vger.kernel.org>

> Putting them at the end of the cache LRU instead of the head would allow them to be dropped quickly under memory pressure. 

This still would fill up your memory for find /, potentially pushing
out other stuff.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

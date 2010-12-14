From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [RFC 1/5] add metadata_incore ioctl in vfs
Date: Tue, 14 Dec 2010 09:12:48 +0800
Message-ID: <1292289168.2323.460.camel@sli10-conroe>
References: <1292224930.2323.450.camel@sli10-conroe>
	 <20101213164036.020be83d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101213164036.020be83d.akpm@linux-foundation.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2010-12-14 at 08:40 +0800, Andrew Morton wrote:
> On Mon, 13 Dec 2010 15:22:10 +0800
> Shaohua Li <shaohua.li@intel.com> wrote:
> 
> > Add an ioctl to dump filesystem's metadata in memory in vfs. Userspace collects
> > such info and uses it to do metadata readahead.
> > Filesystem can hook to super_operations.metadata_incore to get metadata in
> > specific approach. Next patch will give an example how to implement
> > .metadata_incore in btrfs.
> > 
Thanks for your time, akpm. I'll adopt your suggestions in next post.

Thanks,
Shaohua


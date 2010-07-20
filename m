From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [patch 1/2]btrfs: add an ioctl to dump metadata info
Date: Tue, 20 Jul 2010 08:37:30 +0800
Message-ID: <20100720003730.GA14218@sli10-desk.sh.intel.com>
References: <1279094541.1528.94.camel@sli10-desk.sh.intel.com>
 <20100719112705.GX8623@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	Arjan van de Ven <arjan@linux.intel.com>,
	"Wu, Fengguang" <fengguang.wu@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100719112705.GX8623@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 19, 2010 at 07:27:05PM +0800, Chris Mason wrote:
> On Wed, Jul 14, 2010 at 04:02:21PM +0800, Shaohua Li wrote:
> > Add an ioctl to dump btrfs btree_inode's existing pages. Userspace collects such
> > info and uses it to do metadata readahead.
> 
> In your tests, how often is the mincore done on metadata?  With cow
> (especially with cow and atime), the metadata blocks are going to change
> quite a lot.
Meego uses relatime. The proposal is doing mincore in every boot. In my test,
I delete several files and a dir, create a dir and several files, the hit rate
is > 80%, which is already pretty good for boot. In userspace, we record some
extra pages. For example, if mincore returns two pages 2 and 4, userspace will
record pages 2-4, in total 3 pages, this will slightly increase hit rate too.

Thanks,
Shaohua

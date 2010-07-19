From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [patch 1/2]btrfs: add an ioctl to dump metadata info
Date: Mon, 19 Jul 2010 07:27:05 -0400
Message-ID: <20100719112705.GX8623@think>
References: <1279094541.1528.94.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org,
	Arjan van de Ven <arjan@linux.intel.com>,
	"Wu, Fengguang" <fengguang.wu@intel.com>
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1279094541.1528.94.camel@sli10-desk.sh.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 14, 2010 at 04:02:21PM +0800, Shaohua Li wrote:
> Add an ioctl to dump btrfs btree_inode's existing pages. Userspace collects such
> info and uses it to do metadata readahead.

In your tests, how often is the mincore done on metadata?  With cow
(especially with cow and atime), the metadata blocks are going to change
quite a lot.

-chris

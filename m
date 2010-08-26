From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [RFC v2 PATCH 0/6] Btrfs: Add hot data relocation functionality
Date: Thu, 26 Aug 2010 10:13:43 +0800
Message-ID: <20100826021343.GA452@sli10-conroe.sh.intel.com>
References: <1281651726-23501-1-git-send-email-bchociej@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "chris.mason@oracle.com" <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"cmm@us.ibm.com" <cmm@us.ibm.com>,
	"bcchocie@us.ibm.com" <bcchocie@us.ibm.com>,
	"mrlupfer@us.ibm.com" <mrlupfer@us.ibm.com>,
	"crscott@us.ibm.com" <crscott@us.ibm.com>,
	"mlupfer@gmail.com" <mlupfer@gmail.com>,
	"conscott@vt.edu" <conscott@vt.edu>
To: "bchociej@gmail.com" <bchociej@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1281651726-23501-1-git-send-email-bchociej@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 13, 2010 at 06:22:00AM +0800, bchociej@gmail.com wrote:
> 
> - Hooks in existing Btrfs functions to track data access frequency
>   (btrfs_direct_IO, btrfs_readpages, and extent_write_cache_pages)
> 
> - New rbtrees for tracking access frequency of inodes and sub-file
>   ranges (hotdata_map.c)
> 
> - A hash list for indexing data by its temperature (hotdata_hash.c)
> 
> - A debugfs interface for dumping data from the rbtrees (debugfs.c)
> 
> - A background kthread for relocating data to faster media based on
>   temperature
Hi,
I'm wondering if the temperature info can be exported to userspace, and
let a daemon to do the relocation (by ioctl). A userspace daemon is more
flexible.

Thanks,
Shaohua

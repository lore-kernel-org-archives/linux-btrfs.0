From: "Andrey Panin" <pazke@centrinvest.ru>
Subject: Re: [PATCH 2/2] Btrfs-progs: Add hot data support in mkfs
Date: Fri, 13 Aug 2010 17:14:22 +0400
Message-ID: <20100813131422.GA615@centrinvest.ru>
References: <1281652177-23562-1-git-send-email-bchociej@gmail.com>
 <1281652177-23562-3-git-send-email-bchociej@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	cmm@us.ibm.com, bcchocie@us.ibm.com, mrlupfer@us.ibm.com,
	crscott@us.ibm.com, mlupfer@gmail.com, conscott@vt.edu
To: bchociej@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1281652177-23562-3-git-send-email-bchociej@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 224, 08 12, 2010 at 05:29:37PM -0500, bchociej@gmail.com wrote:
> From: Ben Chociej <bchociej@gmail.com>
> 
> Modified mkfs.btrfs to add hot data relocation option (-h) which
> preallocates BTRFS_BLOCK_GROUP_DATA_SSD and
> BTRFS_BLOCK_GROUP_METADATA_SSD at mkfs time for future use by hot data
> relocation code.  Also added a userspace function to detect whether a
> block device is an SSD by reading the sysfs block queue rotational flag.

IMHO this policy is too inflexible. What if I have large array of slow SATA 
disks and some fast SAS ones ?

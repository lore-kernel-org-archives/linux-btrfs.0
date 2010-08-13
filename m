From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: [PATCH 2/2] Btrfs-progs: Add hot data support in mkfs
Date: Fri, 13 Aug 2010 16:08:10 +0200
Message-ID: <20100813140810.GB24029@mother.pipebreaker.pl>
References: <1281652177-23562-1-git-send-email-bchociej@gmail.com>
 <1281652177-23562-3-git-send-email-bchociej@gmail.com>
 <20100813131422.GA615@centrinvest.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bchociej@gmail.com, chris.mason@oracle.com,
	linux-fsdevel@vger.kernel.org, cmm@us.ibm.com, bcchocie@us.ibm.com,
	mrlupfer@us.ibm.com, crscott@us.ibm.com, mlupfer@gmail.com,
	conscott@vt.edu
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100813131422.GA615@centrinvest.ru>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 13, 2010 at 05:14:22PM +0400, Andrey Panin wrote:
> On 224, 08 12, 2010 at 05:29:37PM -0500, bchociej@gmail.com wrote:
> > From: Ben Chociej <bchociej@gmail.com>
> > 
> > Modified mkfs.btrfs to add hot data relocation option (-h) which
> > preallocates BTRFS_BLOCK_GROUP_DATA_SSD and
> > BTRFS_BLOCK_GROUP_METADATA_SSD at mkfs time for future use by hot data
> > relocation code.  Also added a userspace function to detect whether a
> > block device is an SSD by reading the sysfs block queue rotational flag.
> 
> IMHO this policy is too inflexible. What if I have large array of slow SATA 
> disks and some fast SAS ones ?

  I'm hoping that this is just first cut, and future versions will have options.
For now, it is totally unusable without a way of using mirrored SSD for
hot data.
  Ideally, hot storage devices should be online selectable and changeable.

-- 
Tomasz Torcz                                                       72->|   80->|
xmpp: zdzichubg@chrome.pl                                          72->|   80->|


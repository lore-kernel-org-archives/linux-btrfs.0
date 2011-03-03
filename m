From: Josef Bacik <josef@redhat.com>
Subject: Re: About btrfs chunk tree backups
Date: Thu, 3 Mar 2011 07:37:25 -0500
Message-ID: <20110303123724.GA4558@dhcp231-156.rdu.redhat.com>
References: <4D6F58CC.9030003@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D6F58CC.9030003@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 03, 2011 at 05:01:00PM +0800, Miao Xie wrote:
> Hi, Chris and Josef
> 
> Recently, I am interested in chunk tree backups, which is described in
> Project ideas web. But I found it is hard to be implemented.
> 
> The description said "make the mappings discoverable via a block device
> scan so that we can recover from corrupted chunk trees", I think it is
> hard to find the boundary of each stripe, which is the constituent of
> the chunks, via a block device scan according to the current on-disk data
> structures. And besides that, even though we find the stripes of each
> chunks, we still don't know the order of the stripes in one chunk. So
> I think chunk tree backups is hard to be implemented.
> 
> Maybe I made some mistakes in understanding this project idea?
>

We talked about this some earlier this week.  This will require a format change,
basically we need to put down some metadata at the start of every chunk so that
we can scan the disk and find the chunks.  This could probably be done in a
backwards compatible way, we just need to make sure the space for the block
thats used is taken up in the extent tree so old kernels don't write over the
block.  Thanks,

Josef 

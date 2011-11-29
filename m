From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 2/2] Btrfs: set the i_nlink to 2 for an initial dir inode
Date: Tue, 29 Nov 2011 01:08:36 +0100
Message-ID: <20111129000836.GL12759@twin.jikos.cz>
References: <4ED33C88.8060501@oracle.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Jeff Liu <jeff.liu@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED33C88.8060501@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 28, 2011 at 03:47:20PM +0800, Jeff Liu wrote:
> For an initial dir inode, stat(1) show it links as 1, IMHO it should be
> 2 by default.

Yes, this is correct for directories. And newly created subvolumes
should have nlink == 2 as well, can you please add it to your patch?
(I have tested your patch + the proposed change.)


Thanks,
david

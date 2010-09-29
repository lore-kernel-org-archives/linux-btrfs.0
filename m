From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: add a disk info ioctl to get the disks attached
	to a filesystem
Date: Tue, 28 Sep 2010 20:24:33 -0400
Message-ID: <20100929002433.GD32420@dhcp231-156.rdu.redhat.com>
References: <1285707196-16268-1-git-send-email-josef@redhat.com> <201009290028.52133.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201009290028.52133.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 29, 2010 at 12:28:51AM +0200, Goffredo Baroncelli wrote:
> Hi Josef,
> 
> what about using your ioctl to exporting also other info ? For example devid, 
> size, bytes, uuid ...
> 
> I know that btrfs filesystem-show does the same, but it reads the partition 
> (the disk) instead of query the filesystem. That means:
> - It work even for unmounted filesystem (which is good)
> - The results are inaccurate for a mounted filesystem, because the read data 
> is not valid until a flush of the pages (which is bad.. very bad).
>

Well a) the data on disk is always valid, thats the point :).  And b) the only
way the data is not uptodate is if we happened to add/remove/resize a disk right
before running btrfs-show, something that isn't going to happen often.  So I
think btrfs-show solves this problem well enough.  My ioctl is to give apps a
nice quick programmable way to get the list of disks in the fs so they can do
whatever they want instead of having to ship a libbtrfs or some such thing and
make them use that.  Thanks,

Josef

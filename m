From: Josef Bacik <josef@redhat.com>
Subject: Re: "No filesystem could mount root" after adding a second device
	to fs
Date: Mon, 30 Nov 2009 09:51:11 -0500
Message-ID: <20091130145111.GB4046@localhost.localdomain>
References: <23a15590911300341t6d4a73f5qc41fbea063d93cdf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Leszek Ciesielski <skolima@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <23a15590911300341t6d4a73f5qc41fbea063d93cdf@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 30, 2009 at 12:41:29PM +0100, Leszek Ciesielski wrote:
> Hi,
> 
> after adding a second device to a btrfs filesystem (kernel 2.6.31)
> used for root fs, I am getting a "No filesystem could mount root"
> message upon reboot. Is the caveat
> 
> "btrfsctl -a is used to scan all of the block devices under /dev and
> probe for Btrfs volumes. This is required after loading the btrfs
> module if you're running with more than one device in a filesystem. "
> 
> still true? If yes, is there a technical reason for it - am I wrong to
> assume that btrfs could execute the scan upon mount request when the
> filesystem requires it for assembling?
> 

The btrfs module needs to have an idea of what devices are available for it to
use.  The btrfsctl -a needs to be done in userspace since it scans /dev for
block devices to probe to see if they are btrfs devices.  To do it in the kernel
would require calling out to userspace to run btrfsctl -a for the uncommon case
that you are booting from a multi-disk setup.  Hopefully as btrfs becomes more
and more common distributions will start putting btrfsctl -a in their initrd's
if they detect you have a mutli-disk root.  Thanks,

Josef

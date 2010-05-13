From: Josef Bacik <josef@redhat.com>
Subject: Re: OOPS when subvol=xxx where xxx does not exist
Date: Thu, 13 May 2010 14:00:05 -0400
Message-ID: <20100513180005.GG27011@dhcp231-156.rdu.redhat.com>
References: <4BEBE180.9080705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Victor Roetman <victory747@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BEBE180.9080705@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 13, 2010 at 07:24:48PM +0800, Victor Roetman wrote:
> I am running 2.6.34-rc5, testing was done with a 4G thumb drive.
> 
> # mkfs.btrfs /dev/sdd1
> 
> WARNING! - Btrfs v0.19-16-g075587c IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
> 
> fs created label (null) on /dev/sdd1
> 	nodesize 4096 leafsize 4096 sectorsize 4096 size 3.73GB
> Btrfs v0.19-16-g075587c
> 
> # mkdir one
> # mkdir two
> # mount /dev/sdd1 one
> # mount /dev/sdd1 two -o subvol=xxx
> mount: /dev/sdd1 is not a valid block device
> # umount one

Thanks for this, I just posted a patch to fix the problem.

Josef

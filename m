From: Josef Bacik <josef@redhat.com>
Subject: Re: add subvolume when / is not mounted?
Date: Thu, 13 May 2010 15:26:21 -0400
Message-ID: <20100513192621.GJ27011@dhcp231-156.rdu.redhat.com>
References: <4BEC42A9.4090005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BEC42A9.4090005@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 13, 2010 at 08:19:21PM +0200, Andreas Philipp wrote:
> Hi,
> 
> Well, I do not know if here is the right place to ask questions like
> this one so please tell me if it is not.
> The situation is the following: btrfs (data and metadata single) on
> /dev/sda3 (size 100GB) with two subvolumes /one and /two. Both
> subvolumes are mounted to /mnt/one resp. /mnt/two. Is there a way to
> create a third subvolume, say three outside of the two existing
> subvolumes without mounting "the whole volume /dev/sda3" or even worse
> unmounting the two subvolumes before?
> 

At the moment no, you have to mount the default volume, or as you say "the whole
volume /dev/sda3", and then create the new subvolume three.  Thanks,

Josef

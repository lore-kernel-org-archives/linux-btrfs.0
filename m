From: Chris Mason <chris.mason@oracle.com>
Subject: Re: 2.6.32-rc1: btrfs hugs
Date: Fri, 2 Oct 2009 14:37:48 -0400
Message-ID: <20091002183748.GJ2881@think>
References: <a4423d670910020418w4de348c7x763bb7d548d927ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a4423d670910020418w4de348c7x763bb7d548d927ef@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 02, 2009 at 03:18:41PM +0400, Alexander Beregalov wrote:
> Hi
> The kernel is  2.6.32-rc2-00196-g0efe5e3
> SMP, 4cpus
> 
> I tested dbench with 150 threads on 120G partition.
> 
> 
> device fsid b467c30bdb79768-7e6f9a05192ee4b5 devid 1 transid 7 /dev/sda3
> thread pool is 6

I think I've tracked this down to the helper threads getting stuck
waiting for ram to start more helper threads.  I've got a fixed version
here that I'm testing and should push out for 2.6.32-rc3.

-chris

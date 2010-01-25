From: Josef Bacik <josef@redhat.com>
Subject: Re: Howto mount intact left-over device of a degraded btrfs-raid?
Date: Mon, 25 Jan 2010 13:43:27 -0500
Message-ID: <20100125184326.GA2204@localhost.localdomain>
References: <BLU0-SMTP89D73FD06036781FE98000D8640@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "Mr. Tux" <tuxoholic@hotmail.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP89D73FD06036781FE98000D8640@phx.gbl>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 20, 2010 at 07:31:24PM +0100, Mr. Tux wrote:
> Hi list
> 
> I tried to mount the intact device of a two memer btrfs raid array with one 
> device missing:
> 
> # mount -o degraded /dev/sdb /mnt
> 
> this wouldn't work with kernel 2.6.32-2 - caused some sort of memory segfault
> 
> # btrfs-vol -r missing /mnt
> 
> complained and refused to mount the array degraded with only one intact array 
> member left -> demanded two intact members
> 
> How can I mount this array anyway?
> 

How did you setup this array to begin with?  I'm trying to reproduce this bug
but I haven't been able to.  Thanks,

Josef

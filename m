From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs no csum found for inode X start 0
Date: Thu, 25 Feb 2010 19:45:30 -0500
Message-ID: <20100226004530.GD29451@think>
References: <23a15591002242352r665ffddax479d4cbfd8c88cdb@mail.gmail.com>
 <23a15591002250134m753cd437jb14e320d2e8b39b3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Leszek Ciesielski <skolima@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <23a15591002250134m753cd437jb14e320d2e8b39b3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 25, 2010 at 10:34:22AM +0100, Leszek Ciesielski wrote:
> (My previous post seems to have been discarded because of the
> attachment size, I'm resending it without the dmesg output - which can
> be found @ http://pastebin.com/T0J3z59j )
> 
> Hi,
> 
> yesterday I updated my kernel (clean clone from
> mason/btrfs-unstable.gi), pulling in the single latest change I have
> been missing ( http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commit;h=3f6fae9559225741c91f1320090b285da1413290
> ) and adding my patch from http://patchwork.kernel.org/patch/81547/ .
> Previous kernel version (without my patch - could this be my fault?)
> has been running fine for 14 days, but after recompiling and
> rebooting, my dmesg output is full of "btrfs no csum found for inode
> 386 start 0" and "btrfs csum failed ino 386 extent 65191274496 csum
> 1851253866 wanted 0 mirror 1" and "btrfs csum failed ino 82619 off
> 8749056 csum 2686054019 private 0",

I don't think your patch alone could have caused this.  Has anything
else strange been happening on this machine?

The fact that all your files are wrong is especially strange.  Have you
ever mounted this FS with mount -o nodatasum?

-chris

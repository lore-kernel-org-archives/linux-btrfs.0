From: Josef Bacik <josef@redhat.com>
Subject: Re: Ooops mounting non existant subvolume.
Date: Fri, 22 Oct 2010 18:29:31 -0400
Message-ID: <20101022222931.GA20188@dhcp231-156.rdu.redhat.com>
References: <20101023104256.4a256f6d.suckfish@ihug.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Ralph Loader <suckfish@ihug.co.nz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101023104256.4a256f6d.suckfish@ihug.co.nz>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 23, 2010 at 10:42:56AM +1300, Ralph Loader wrote:
> Hi,
> 
> If I attempt to mount a non-existant subvolume, e.g.,
> 
> mount -o subvol=1 /dev/sda6 /mnt
> 
> then I get an an oops (see end of message).
> 
> /dev/sda6 is my root filesystem, 'btrfs sub list /' gives
> 
> ID 331 top level 5 path snap/rawhide
> ID 341 top level 5 path snap/20101014
> ID 342 top level 5 path snap/20101016
> ID 343 top level 5 path snap/20101020
> 
> subvol 343 is set as the default subvolume.
>

You'll want this

http://git.kernel.org/?p=linux/kernel/git/josef/btrfs-work.git;a=commit;h=a5ecef26de54d54982053e3f6895df6e39807b07

> Cheers,
> Ralph.
> 
> PS.  What I'm actually trying to achieve is get back to the original subvolume I had before I did a 'btrfs subvol set-default', is there any way of doing that?
>

mount -o subvolid=0.  Thanks,

Josef 

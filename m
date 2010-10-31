From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Can't remove missing drive
Date: Sun, 31 Oct 2010 08:01:11 -0400
Message-ID: <20101031120111.GD2918@think>
References: <096423C3-E94C-4969-95C8-42557AA41D0D@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: William Uther <willu.mailingLists@cse.unsw.edu.au>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <096423C3-E94C-4969-95C8-42557AA41D0D@cse.unsw.edu.au>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 30, 2010 at 06:37:06PM +1100, William Uther wrote:
> Hi,
>   I have a raid1 setup with a missing device.  I have added a new device and everything seems to be working fine, except I cannot remove the old, missing, device.  There is no error - but the 'some devices missing' tag doesn't go away.
> 
> root@willvo:~# btrfs filesystem show
> failed to read /dev/sr0
> Label: none  uuid: f929c413-01c8-443f-b4f2-86f36702f519
>     Total devices 3 FS bytes used 578.39GB
>     devid    1 size 931.51GB used 604.00GB path /dev/sdb1
>     devid    2 size 931.51GB used 604.00GB path /dev/sdc1
>     *** Some devices missing
> 
> Btrfs Btrfs v0.19
> root@willvo:~# btrfs device delete missing /data
> root@willvo:~# btrfs filesystem show
> failed to read /dev/sr0
> Label: none  uuid: f929c413-01c8-443f-b4f2-86f36702f519
>     Total devices 3 FS bytes used 578.39GB
>     devid    1 size 931.51GB used 604.00GB path /dev/sdb1
>     devid    2 size 931.51GB used 604.00GB path /dev/sdc1
>     *** Some devices missing
> 
> Btrfs Btrfs v0.19
> 
> There are a number of sub-volumes of /data that are mounted in other locations.  I'm using kernel 2.6.36 (the lucid backport of the natty kernel) and similar btrfs-tools (lucid backport of natty tools).  Interestingly looking at the output of `dh -h`, it appears that the 'missing' devices are no longer being counted in the filesystem size - there is just a phantom 'missing' tag in btrfs-show.
> 
> Is this actually a problem, or can I just keep running as is?  It seems to mount fine without -odegraded.
> 
> Any ideas how I can list the missing devices?  Any ideas on how I can remove the missing devices?

What have you tried so far?

The general formula is:

mount -o degraded /dev/xxx /mnt (where xxx is one drive still in the
array)

btrfs-vol -r missing /mnt

I'd suggest pulling the master branch of the unstable tree first, it has
a fix for the btrfs-vol -r missing code.

-chris


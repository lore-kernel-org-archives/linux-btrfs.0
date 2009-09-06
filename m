From: Josef Bacik <josef@redhat.com>
Subject: Re: Discrepant st_rdev and st_dev stats in btrfs block and fs
	device ids
Date: Sun, 6 Sep 2009 18:27:15 -0400
Message-ID: <20090906222714.GA22784@dhcp231-156.rdu.redhat.com>
References: <7a83c8e0909060851w70305142oc775b28bcd1ef093@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Marcus <smurca@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7a83c8e0909060851w70305142oc775b28bcd1ef093@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 06, 2009 at 04:51:55PM +0100, Marcus wrote:
> Hello,
> 
> I think I found a btrfs 0.19 problem when used in an lvm2 volume;
> btrfs is returning a st_dev stat from the mounted filesystem / that is
> different from the lvm2 blockdevice st_rdev stat in
> /dev/mapper/vg0-os0.
> 
> This btrfs behavior is different from ext4, where the st_dev and
> st_rdev stats match (http://pastebin.com/m64e90a8e or a summary
> below). Because of that, in grub2, 'grub-probe -t device / ' fails
> with ' grub-probe: error: cannot find a device for /. ' , and so
> update-grub2 fails causing cascading problems all around.
> 
> Can anyone repeat this? Any ideas why this could be happening? Is this expected?
>

Yes this is expected.  Because of the way that btrfs can have multiple disks and
snapshot and such, it creates this sort of virtual device as its backing device
in the kernel to keep track of everything, so it's st_dev will not match the
actual device it resides on.  Thanks,

Josef 

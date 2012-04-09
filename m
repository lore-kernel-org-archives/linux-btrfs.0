From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: Boot speed/mount time regression with 3.4.0-rc2
Date: Mon, 09 Apr 2012 13:10:04 -0400
Message-ID: <1333991404.2817.6.camel@ayu>
References: <1333986823.2928.6.camel@ayu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1333986823.2928.6.camel@ayu>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2012-04-09 at 11:53 -0400, Calvin Walton wrote:
> Hi,
> 
> I have a system that's using a dracut-generated initramfs to mount a
> btrfs root. After upgrading to kernel 3.4.0-rc2 to test it out, I've
> noticed that the process of mounting the root filesystem takes much
> longer with 3.4.0-rc2 than it did with 3.3.1 - nearly 30 seconds slower!
> 
> Does anyone have any ideas? I'm going to try bisecting the issue to see
> if I can narrow down the cause. I've included excerpts from dmesg of the
> bad and good kernels here, and attached the complete dmesg from the bad
> kernel, in case it has anything interesting that I've trimmed out here.

And the bisect results are in:
285ff5af6ce358e73f53b55c9efadd4335f4c2ff is the first bad commit
commit 285ff5af6ce358e73f53b55c9efadd4335f4c2ff
Author: Josef Bacik <josef@redhat.com>
Date:   Fri Jan 13 15:27:45 2012 -0500

    Btrfs: remove the ideal caching code
   
    This is a relic from before we had the disk space cache and it was to make
    bootup times when you had btrfs as root not be so damned slow.  Now that we have
    the disk space cache this isn't a problem anymore and really having this code
    casues uneeded fragmentation and complexity, so just remove it.  Thanks,
    
    Signed-off-by: Josef Bacik <josef@redhat.com>

The commit doesn't revert cleanly on top of 3.4.0-rc2, so I haven't
tested that; but it looks like that caching code is in fact still useful
to make "btrfs as root not be so damned slow."

> slow:
> [    0.000000] Linux version 3.4.0-rc2 (cwalton@ayu) (gcc version 4.6.3 (Exherbo gcc-4.6.3) ) #57 SMP PREEMPT Mon Apr 9 11:19:43 EDT 2012
> [    0.000000] Command line: root=UUID=43969cd0-4aca-4297-bfbe-952a692f7d55 rootflags=subvolid=262,compress=lzo,autodefrag,space_cache,inode_cache,noatime mtrr_chunk_size=512M quiet
> <snip>
> [    1.058257] udevd[701]: starting version 182
> [    1.389606] device label Linux data devid 1 transid 611923 /dev/sda4
> [    1.498659] dracut: Checking, if btrfs device complete
> [    1.644808] device label Linux data devid 1 transid 611923 /dev/sda4
> [    1.647993] btrfs: disk space caching is enabled
> [    2.180836] device label Linux data devid 1 transid 611923 /dev/sda4
> [    2.181663] btrfs: use lzo compression
> [    2.181667] btrfs: enabling auto defrag
> [    2.181670] btrfs: enabling inode map caching
> [    2.181672] btrfs: disk space caching is enabled
> [    2.697845] dracut: Checking btrfs: /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55
> [    2.699999] dracut: trying to mount /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55
> [    2.702637] device label Linux data devid 1 transid 611923 /dev/sda4
> [    2.704376] btrfs: disk space caching is enabled
> [    3.081720] dracut: btrfs: /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55 is clean
> [   29.934639] dracut: Remounting /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55 with -o subvolid=262,compress=lzo,autodefrag,space_cache,inode_cache,noatime,ro
> [   29.936810] device label Linux data devid 1 transid 611926 /dev/sda4
> [   29.937720] btrfs: use lzo compression
> [   29.937726] btrfs: enabling auto defrag
> [   29.937733] btrfs: enabling inode map caching
> [   29.937735] btrfs: disk space caching is enabled
> [   30.388066] dracut: Mounted root filesystem /dev/sda4
> [   30.461884] dracut: Switching root
> [   31.241729] udevd[1322]: starting version 182
> [   31.422905] btrfs: use lzo compression
> [   31.422909] btrfs: enabling auto defrag
> [   31.422913] btrfs: enabling inode map caching
> [   31.422915] btrfs: disk space caching is enabled

-- 
Calvin Walton <calvin.walton@kepstin.ca>


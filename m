Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34761 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbcBZUhM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 15:37:12 -0500
Subject: Re: loop subsystem corrupted after mounting multiple btrfs
 sub-volumes
To: Al Viro <viro@ZenIV.linux.org.uk>
References: <56CF5490.7040102@suse.cz> <56D04630.1020809@gmail.com>
 <56D0743F.9040102@suse.cz> <56D07FAF.3080605@gmail.com>
 <20160226175311.GC17997@ZenIV.linux.org.uk> <56D0A38B.3050701@suse.cz>
 <56D0B007.2050106@gmail.com> <20160226203010.GD17997@ZenIV.linux.org.uk>
Cc: Stanislav Brabec <sbrabec@suse.cz>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56D0B736.2050904@gmail.com>
Date: Fri, 26 Feb 2016 15:36:06 -0500
MIME-Version: 1.0
In-Reply-To: <20160226203010.GD17997@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-26 15:30, Al Viro wrote:
> On Fri, Feb 26, 2016 at 03:05:27PM -0500, Austin S. Hemmelgarn wrote:
>>> Where is /mnt/2?
>> It's kind of interesting, but I can't reproduce _any_ of this
>> behavior with either ext4 or BTRFS when I manually set up the loop
>> devices and point mount(8) at those instead of using -o loop on a
>> file. That really seems to indicate that this is caused by something
>> mount(8) is doing when it's calling losetup. I'm running a mostly
>> unmodified version of 4.4.2 (the only modification that would come
>> even remotely close to this is that I changed the default mount
>> options for everything from relatime to noatime), and util-linux
>> 2.27.1 from Gentoo.
>
> Sigh...  sys_mount() (mount_bdev(), actually) has no way to tell if two
> loop devices refer to the same underlying object.  As far as it's
> concerned, you are asking to mount a completely unrelated block device.
> Which just happens to see the data (living in separate pagecache, even)
> modified behind its back (with some delay) after it gets written to another
> device.  Filesystem drivers generally don't like when something is screwing
> the underlying data, to put it mildly...
>
> When you ask to mount the _same_ device, mount_bdev(), as well as btrfs
> counterpart, makes sure that you get a reference to the same struct
> super_block, which avoids all coherency problems - all mounted instances
> refer to the same in-core objects (dentries, inodes, page cache, etc.).
> They get separate struct vfsmount instances, but that only matters for
> mountpoint crossing.
>
> As soon as you've set the second /dev/loop alias for the same underlying
> file, you are asking for all kinds of trouble.  If you use the same one
> consistently, you are OK.  BTW, even
> losetup /dev/loop0 /dev/sda1
> mount -t ext2 /dev/sda1 /mnt/1
> mount -t ext2 /dev/loop0 /mnt/2
> is enough for trouble - you get (as far as ext2 knows) unrelated devices
> screwing each other, with no good way to predict that.  And you need to
> check propagation through more than one layer - loop over loop over block
> is also possible.
>
> IMO on-demand losetup a-la -o loop is simply a bad idea...
>
I agree wholeheartedly and wasn't disputing any of this, I meant I'm not 
seeing any of the odd mount(2) or /proc/self/mountinfo behavior that 
Stanislav started the thread about.  It was entirely trivial to get the 
filesystem images I used into a state where they couldn't be mounted 
again afterwards.

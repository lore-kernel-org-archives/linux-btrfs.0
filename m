From: David Sterba <dave@jikos.cz>
Subject: Re: LABEL only 1 device
Date: Mon, 27 Feb 2012 13:06:40 +0100
Message-ID: <20120227120640.GO1046@twin.jikos.cz>
References: <20120226153036.GB18898@carfax.org.uk> <C3b12r9i1uB@helmut.hullen.de> <20120226164400.GC18898@carfax.org.uk>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Hugo Mills <hugo@carfax.org.uk>, helmut@hullen.de,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120226164400.GC18898@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 26, 2012 at 04:44:00PM +0000, Hugo Mills wrote:
>    OK, the real problem you're seeing is that when btrfs removes a
> device from the filesystem, that device is not modified in any way.
> This means that the old superblock is left behind on it, containing
> the FS label information. What you need to do is, immediately after
> removing a device from the FS, zero the first part of the partition
> with dd and /dev/zero.

A correction here: if the device being removed is writable, the
superblock is cleared so it's not recognized as a part of any other fs:

int btrfs_rm_device(struct btrfs_root *root, char *device_path)
...
        /*
         * at this point, the device is zero sized.  We want to
         * remove it from the devices list and zero out the old super
         */
        if (clear_super) {
                /* make sure this device isn't detected as part of
                 * the FS anymore
                 */
                memset(&disk_super->magic, 0, sizeof(disk_super->magic));
                set_buffer_dirty(bh);
                sync_dirty_buffer(bh);
        }

Doing this manually means zeroing 4k block at all offsets up to
partition size:

Superblock 0 offset 65536
Superblock 1 offset 67108864
Superblock 2 offset 274877906944
Superblock 3 offset 1125899906842624
Superblock 4 offset 4611686018427387904


david

From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: Offline Deduplication for Btrfs
Date: Wed, 5 Jan 2011 19:33:59 -0800
Message-ID: <AANLkTimWfxbBma+SA+kTMfpjU8ej0U8v+Oz3EiXbPBtA@mail.gmail.com>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>
	<4D24AD92.4070107@bobich.net>
	<20110105194645.GC2562@localhost.localdomain>
	<4D24D8BC.90808@bobich.net>
	<4D250B3C.6010708@shiftmail.org>
	<4D2514DC.6060306@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D2514DC.6060306@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 5, 2011 at 5:03 PM, Gordan Bobic <gordan@bobich.net> wrote:
> On 01/06/2011 12:22 AM, Spelic wrote:
> Definitely agree that it should be a per-directory option, rather than per
> mount.

JOOC, would the dedupe "table" be done per directory, per mount, per
sub-volume, or per volume?  The larger the pool of data to check
against, the better your dedupe ratios will be.

I'm not up-to-date on all the terminology that btrfs uses, and how it
compares to ZFS (disks -> vdevs -> pool -> filesystem/volume), so the
terms above may be incorrect.  :)

In the ZFS world, dedupe is done pool-wide in that any block in the
pool is a candidate for dedupe, but the dedupe property can be
enabled/disabled on a per-filesystem basis.  Thus, only blocks in
filesystems with the dedupe property enabled will be deduped.  But
blocks from any filesystem can be compared against.

> This is the point I was making - you end up paying double the cost in disk
> I/O and the same cost in CPU terms if you do it offline. And I am not
> convniced the overhead of calculating checksums is that great. There are
> already similar overheads in checksums being calculated to enable smart data
> recovery in case of silent disk corruption.
>
> Now that I mentioned, that, it's an interesting point. Could these be
> unified? If we crank up the checksums on files a bit, to something suitably
> useful for deduping, it could make the deduping feature almost free.

This is what ZFS does.  Every block in the pool has a checksum
attached to it.  Originally, the default algorithm was fletcher2, with
fletcher4 and sha256 as alternates.  When dedupe was enabled, the
default was changed to fletcher4.  Dedupe also came with the option to
enable/disable a byte-for-byte verify when the hashes match.

By switching the checksum algorithm for the pool to sha256 ahead of
time, you can enable dedupe, and get the dedupe checksumming for free.
 :)

>> Also, the OS is small even if identical on multiple virtual images, how
>> much is going to occupy anyway? Less than 5GB per disk image usually.
>> And that's the only thing that would be deduped because data likely to
>> be different on each instance. How many VMs running you have? 20? That's
>> at most 100GB saved one-time at the cost of a lot of fragmentation.
>
> That's also 100GB fewer disk blocks in contention for page cache. If you're
> hitting the disks, you're already going to slow down by several orders of
> magnitude. Better to make the caching more effective.

If you setup your VMs as diskless images, using NFS off a storage
server running <whatever FS> using dedupe, you can get a lot more out
of it than using disk image files (where you have all the block sizes
and alignment to worry about).  And the you can use all the fancy
snapshotting, cloning, etc features of <whatever FS> as well.

-- 
Freddie Cash
fjwcash@gmail.com

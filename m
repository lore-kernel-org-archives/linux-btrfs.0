From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [PATCH 3/4] xfstests: Add support for btrfs in 015
Date: Thu, 28 Jul 2011 19:54:45 +0200
Message-ID: <4E31A265.5050909@giantdisaster.de>
References: <cover.1311776403.git.sbehrens@giantdisaster.de> <bebfc5c98e0fb878f55c1312d8750ce7b7f82e07.1311776403.git.sbehrens@giantdisaster.de> <20110728084756.GC3407@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110728084756.GC3407@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 7/28/2011 10:47 AM, Christoph Hellwig wrote:
> On Thu, Jul 28, 2011 at 10:28:00AM +0200, Stefan Behrens wrote:
>> Added btrfs to the list of supported filesystems for test 015, and
>> increased free space reporting tolerance to 10% for btrfs.
>> Replaced the call to _scratch_mkfs_xfs with the XFS specific size
>> parameter by the generic one for sized filesystem creation which is
>> _scratch_mkfs_sized.
> 
> ACK for the _scratch_mkfs_sized changed, but I'm really curious why
> we would allow so much more tolerance for btrfs.
> 
> And again, why can't these be marked generic?

To add a 10% tolerance for btrfs was a bad idea.
Since the output of df(1) is not yet reliable on btrfs volumes while
data is not flushed to disk, the better implementation would be to
either let this test fail, or to force a flush to disk before taking
the output of df(1).
The latter is what I have implemented now.

This is a demo of what currently happens:
# mkfs.btrfs -b 2048M --mixed $SCRATCH_DEV
WARNING! - Btrfs v0.19-104-gd0fa1a8-dirty IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

Created a data/metadata chunk of size 8388608
fs created label (null) on /dev/sdu1
        nodesize 4096 leafsize 4096 sectorsize 4096 size 2.00GB
Btrfs v0.19-104-gd0fa1a8-dirty
# mount $SCRATCH_DEV $SCRATCH_MNT
# df -k $SCRATCH_MNT
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdu1              2097152        28   2093040   1% /mnt3
# dd if=/dev/zero of=$SCRATCH_MNT/foo bs=1M
dd: writing `/mnt3/foo': No space left on device
1881+0 records in
1880+0 records out
1971322880 bytes (2.0 GB) copied, 7.61947 s, 259 MB/s
# df -k $SCRATCH_MNT
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdu1              2097152       756   2092304   1% /mnt3
# sync
# df -k $SCRATCH_MNT
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdu1              2097152   1928420    164640  93% /mnt3
# rm -f $SCRATCH_MNT/foo
# df -k $SCRATCH_MNT
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdu1              2097152   1928420    164640  93% /mnt3
# sync
# df -k $SCRATCH_MNT
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdu1              2097152       676   2092384   1% /mnt3

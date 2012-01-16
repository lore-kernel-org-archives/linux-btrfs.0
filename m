From: David Sterba <dave@jikos.cz>
Subject: Re: Warning: bad fsid on block 20971520
Date: Mon, 16 Jan 2012 15:34:28 +0100
Message-ID: <20120116143428.GB7322@twin.jikos.cz>
References: <20120111154621.GX7322@twin.jikos.cz> <20120111163714.GE2179@shiny> <20120111223434.GY7322@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120111223434.GY7322@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 11, 2012 at 11:34:34PM +0100, David Sterba wrote:
> I will try to catch it with blktrace running.

Measurement disrupted the experiment. The second I start blktrace, these
messages

[450482.299863] device fsid 7f7bfb60-b8f3-457e-857a-9a1a187f750f devid 1 transid 7 /dev/sda9
[450482.309642] btrfs: force lzo compression
[450482.314802] btrfs: enabling inode map caching
[450482.320363] btrfs: enabling auto defrag
[450482.324138] btrfs: disk space caching is enabled
[450482.378652] btrfs: failed to read chunk root on sda9
[450482.385397] btrfs: open_ctree failed 

appear in the log, mount fails and the test is not performed. (And
immediately stop when blktrace stops.)

There are a few occurances of the

[450491.373282] btrfs bad fsid on block 20971520

message. Blktrace log does not contain any record of 'mkfs' activity,
the other involved process are there (mount, aio-dio, kernel threads).

The other day I saw

[ 8334.490486] device fsid 830e57b6-b9c3-471c-b4dc-4a8c2c56fb35 devid 1 transid 4 /dev/sda9
[ 8334.500482] btrfs: force lzo compression 
[ 8334.505853] btrfs: enabling inode map caching
[ 8334.511539] btrfs: enabling auto defrag
[ 8334.515234] btrfs: disk space caching is enabled
[ 8334.532517] btrfs  0 12582912
[ 8334.551594] btrfs bad tree block start 20971520 12582912
[ 8334.560353] btrfs bad tree block start 0 12582912
[ 8334.568263] btrfs bad tree block start 20971520 12582912
[ 8334.575188] btrfs bad tree block start 20971520 12582912
[ 8334.581946] btrfs bad tree block start 0 12582912
[ 8334.588044] btrfs bad tree block start 20971520 12582912
[ 8334.594543] btrfs: failed to read chunk root on sda9
[ 8334.601040] btrfs: open_ctree failed

a different instance of the the same.  So this looks rather serious.

Per your advice, I'll try to test with other filesystems, with older
kernels, and in btrfs case add fsync into mkfs.


david

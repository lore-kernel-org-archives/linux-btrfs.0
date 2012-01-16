From: David Sterba <dave@jikos.cz>
Subject: Re: Warning: bad fsid on block 20971520
Date: Mon, 16 Jan 2012 19:36:10 +0100
Message-ID: <20120116183610.GC7322@twin.jikos.cz>
References: <20120111154621.GX7322@twin.jikos.cz> <20120111163714.GE2179@shiny> <20120111223434.GY7322@twin.jikos.cz> <20120116143428.GB7322@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120116143428.GB7322@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 16, 2012 at 03:34:28PM +0100, David Sterba wrote:
> Per your advice, I'll try to test with other filesystems, with older
> kernels, and in btrfs case add fsync into mkfs.

I left looping the 3.0.13 based sles kernel and did not trigger the
warning for several hours.

In the meantime I grepped through my serial console logs and found that
first 'bad fsid' message appeared in 3.0.0-rc5+ dated to 2011-06-01:

[73673.623530] device fsid 5f1b5c0e-21ff-4896-bf48-8d64558dd205 devid 1 transid 7 /dev/sdb10
[73673.633194] btrfs: enabling auto defrag
[73673.636915] btrfs: enabling disk space caching
[73673.644124] btrfs: enabling inode map caching
[73673.649733] btrfs: force lzo compression
[73673.740630] btrfs bad fsid on block 20971520
[73673.746400] btrfs bad fsid on block 20971520
[73673.760785] btrfs bad fsid on block 20971520
[73673.766284] btrfs: failed to read chunk root on sdb10
[73673.772969] btrfs warning page private not zero on page 20971520
[73673.792224] btrfs: open_ctree failed

and there are several messages from 3.1.0-rc4 kernel, no more occurences
of "page private not zero" message.


david

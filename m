Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:62693 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756183Ab3KVWMe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 17:12:34 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [virt-devel] btrfs NOCOW for VM disk images
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1616992290.20969836.1385137054390.JavaMail.root@redhat.com>
Date: Fri, 22 Nov 2013 15:12:35 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <B7A7E800-4281-493C-B889-33F5B6EC4F72@colorremedies.com>
References: <20131122142051.GA32192@stefanha-thinkpad.redhat.com> <1616992290.20969836.1385137054390.JavaMail.root@redhat.com>
To: John Dulaney <jdulaney@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 22, 2013, at 9:17 AM, John Dulaney <jdulaney@redhat.com> wrote:
> 
> In upstream QEMU we're discussing patches that set the NOCOW flag on
> disk image files.  We're told that this increases btrfs performance
> greatly since the file system will modify data in-place like ext4/xfs.

The best performing qemu/kvm results I have, using installing Fedora 20 as the benchmark method and anaconda's time stamping of the start and completion of the installation, is Btrfs on the host with preallocated Raw file with xattr +C, and Btrfs used in the guest. The test matrix is 3x3: ext4, XFS, Btrfs. So each fs was used on the host, and in the guest.

By "best performing" we're talking about maybe 20-30 seconds better over a 7-8 minute install time on spinning rust. So with respect to installing an OS (the live image uses rsync), it seems Btrfs on Btrfs is at least no worse off than other file systems.

A 20GB preallocated Raw on Btrfs with +C set has 33 extents, which doesn't ever change.

When I do this with a qcow2 file with preallocated metadata, it starts out with only 5 extents upon creation, but with each successive installation using the same qcow2 file, also with +C xattr, the extent count grows quite a bit. Although it's very unclear from the testing if this negatively impacts performance, or if the extent increase eventually flattens out.

after installation1> fedoratest.img: 1255 extents found
after installation2> fedoratest.img: 1773 extents found
after installation3> fedoratest.img: 2148 extents found
after installation4> fedoratest.img: 2245 extents found

This is a whole lot less, however, than non-preallocated Raw, without +C xattr where it rapidly ends up with tens of thousands of extents with no end in sight.

> This leaves us with the choice between performance (NOCOW) and snapshots
> (default).  Both are important for VM disk images!

Some testing needs to be done with qcow2 on Btrfs with +C long term to see if there's a meaningful performance hit as the qcow2 ages.

It may also be possible to defragment the qcow2 file once extent allocation tapers off.

And another possibility would be for qcow2 to support full preallocation, so that its initial extent count is no worse than Raw.

If you don't need host based snapshotting, another possibility is using Btrfs in the guest, and snapshotting within the guest. It depends on the use case if this is preferred or not, but I think there could be some advantages to snapshotting within the guest. In this case, using Btrfs in the guest regardless of the backing method used, gives the guest the ability to at least flag for fs/data corruption, if not repair it (if a raid 1+ data profile is employed).


Chris Murphy
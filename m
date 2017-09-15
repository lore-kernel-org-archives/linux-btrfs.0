Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48317 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751434AbdIORIl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 13:08:41 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dsu6N-0005BN-3B
        for linux-btrfs@vger.kernel.org; Fri, 15 Sep 2017 19:08:27 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: defragmenting best practice?
Date: Fri, 15 Sep 2017 19:08:26 +0200
Message-ID: <20170915190826.1f0be8a9@jupiter.sol.kaishome.de>
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
        <20170912162843.GA32233@rus.uni-stuttgart.de>
        <20170914133824.5cf9b59c@jupiter.sol.kaishome.de>
        <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
        <20170914172434.39eae89d@jupiter.sol.kaishome.de>
        <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
        <59BBB15E.8010002@sarach.com.pl>
        <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
        <59BBDFA6.4020500@sarach.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Fri, 15 Sep 2017 16:11:50 +0200
schrieb Michał Sokołowski <michal@sarach.com.pl>:

> On 09/15/2017 03:07 PM, Tomasz Kłoczko wrote:
> > [...]
> > Case #1
> > 2x 7200 rpm HDD -> md raid 1 -> host BTRFS rootfs -> qemu cow2
> > storage -> guest BTRFS filesystem  
> > SQL table row insertions per second: 1-2
> >
> > Case #2
> > 2x 7200 rpm HDD -> md raid 1 -> host BTRFS rootfs -> qemu raw
> > storage -> guest EXT4 filesystem
> > SQL table row insertions per second: 10-15
> > Q -1) why you are comparing btrfs against ext4 on top of the btrfs
> > which is doing own COW operations on bottom of such sandwiches ..
> > if we SUPPOSE to be talking about impact of the fragmentation on
> > top of btrfs?  
> 
> Tomasz,
> you seem to be convinced that fragmentation does not matter. I found
> this (extremely bad, true) example says otherwise.

Sorry to jump this, but did you at least set the qemu image to nocow?
Otherwise this example is totally flawed because you're testing qemu
storage layer mostly and not btrfs.

A better test would've been to test qemu raw on btrfs cow vs on btrfs
nocow, with both the same file system inside the qemu image.

But you are modifying multiple parameters at once during the test, and
I expect then everyone has a huge impact on performance but only one is
specific to btrfs which you apparently did not test this way.

Personally, running qemu cow2 on btrfs cow really helps nothing except
really bad performance. Make one of both layers nocow and it should
become better.

If you want to give some better numbers, please reduce this test to
just one cow layer, the one at the top layer: btrfs host fs. Copy the
image somewhere else to restore from, and ensure (using filefrag) that
the starting situation matches each test run.

Don't change any parameters of the qemu layer at each test. And run a
file system inside which doesn't do any fancy stuff, like ext2 or ext3
without journal. Use qemu raw storage.

Then test again with cow vs nocow on the host side.

Create a nocow copy of your image (use size of the source image for
truncate):

# rm -f qemu-image-nocow.raw
# touch qemu-image-nocow.raw
# chattr +C -c qemu-image-nocow.raw
# dd if=source-image.raw of=qemu-image-nocow.raw bs=1M
# btrfs fi defrag -f qemu-image-nocow.raw
# filefrag -v qemu-image-nocow.raw

Create a cow copy of your image:

# rm -f qemu-image-cow.raw
# touch qemu-image-cow.raw
# chattr -C -c qemu-image-cow.raw
# dd if=source-image.raw of=qemu-image-cow.raw bs=1M
# btrfs fi defrag -f qemu-image-cow.raw
# filefrag -v qemu-image-cow.raw

Given that host btrfs is mounted datacow,compress=none and without
autodefrag, and you don't touch the source image contents during tests.

Now run your test script inside both qemu machines, take your
measurements and check fragmentation again after the run.

filefrag should report no more fragments than before the test for the
first test, but should report a magnitude more for the second test.

Now copy (cp) both one at a time to a new file and measure the time. It
should be slower for the highly fragmented version.

Don't forget to run tests with and without flushed caches so we get
cold and warm numbers.

In this scenario, qemu would only be the application to modify the raw
image files and you're actually testing the impact of fragmentation of
btrfs.

You could also make a reflink copy of the nocow test image and do a
third test to see that it introduces fragmentation now, tho probably
much lower than for the cow test image. You can verify the numbers with
filefrag.

According to Tomasz, your tests should not run at vastly different
speeds because fragmentation has no impact on performance, quod est
demonstrandum... I think we will not get to the "erat" part.


-- 
Regards,
Kai

Replies to list-only preferred.



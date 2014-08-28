Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:56734 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750941AbaH1QZg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Aug 2014 12:25:36 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:65062 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XN2Vy-000oiL-Vq
	for linux-btrfs@vger.kernel.org; Thu, 28 Aug 2014 10:25:35 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Undelete files / directory
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$2ed7a$1001c22e$8c89f27e$d20dc522@cox.net>
Date: Thu, 28 Aug 2014 10:25:33 -0600
Message-Id: <262E2EAA-FE5F-4ADB-9D1D-258D51D81AFE@colorremedies.com>
References: <53FE1DB2.8040900@sysnux.pf> <pan$2ed7a$1001c22e$8c89f27e$d20dc522@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Line 84
		"$dir/restore" -i -t $id -m "$regex" "$dev" $out

I don't see a -m option for btrfs restore, maybe use --path-regex instead.

I just did this without the script and it worked:

1. mkfs.btrfs /dev/sdc
2. mount /dev/sdc /mnt
3. mkdir /mnt/pics
4. scp IMG_3327.tif <blahhost>:/mnt/pics/    #copied TIFF from another computer
5. btrfs fi sync /mnt     #make sure it's committed
6. rm -f /mnt/pics/IMG_3327.tif
7. btrfs fi sync /mnt     #make sure it's gone, superfluous probably
8. umount /mnt
9. btrfs-find-root /dev/sdc
Super think's the tree root is at 29917184, chunk root 20987904
Well block 4194304 seems great, but generation doesn't match, have=2, want=9 level 0
Well block 4243456 seems great, but generation doesn't match, have=3, want=9 level 0
Well block 29376512 seems great, but generation doesn't match, have=4, want=9 level 0
Well block 29474816 seems great, but generation doesn't match, have=5, want=9 level 0
Well block 29556736 seems great, but generation doesn't match, have=6, want=9 level 0
Well block 29736960 seems great, but generation doesn't match, have=7, want=9 level 0
Well block 29900800 seems great, but generation doesn't match, have=8, want=9 level 0
Found tree root at 29917184 gen 9 level 0

At this point I can pretty much guess that the file I want is in generation 7. It might be in 8. But I went ahead and looked for it using btrfs-debug-tree and sure enough I see a bunch of items with very big lengths and it's gen 7. So in the above list, block 29736960 is for generation 7.

10. btrfs restore -t 29736960 -v /dev/sdc /home/chris
parent transid verify failed on 29736960 wanted 9 found 7
parent transid verify failed on 29736960 wanted 9 found 7
parent transid verify failed on 29736960 wanted 9 found 7
parent transid verify failed on 29736960 wanted 9 found 7
Ignoring transid failure
Restoring /home/chris/pics
Restoring /home/chris/pics/IMG_3327.tif
Done searching /pics
Done searching 


11. I did an shasum on the restored and original TIFFs and they match.


So the script probably makes it easier to find the right root, and also has a regex pattern to probably filter out the junk. In retrospect I probably should have deleted the directory rather than the file for this test, so I went back and mounted sdc, rmdir'd the directory, unmounted, and the same command still restores the file that was in that directory.


Chris Murphy
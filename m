Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35977 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab3BZVp1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 16:45:27 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UASLI-0001y4-Ct
	for linux-btrfs@vger.kernel.org; Tue, 26 Feb 2013 22:45:44 +0100
Received: from rain.gmane.org ([80.91.229.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 22:45:44 +0100
Received: from eternaleye by rain.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 22:45:44 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Swapfile on btrfs
Date: Tue, 26 Feb 2013 13:45:12 -0800
Message-ID: <kgjad5$7kt$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey, I was looking at the wiki 'unclaimed projects' list and I thought I'd 
take a look at what might be needed to use the swap-over-n{fs,bd} 
functionality in order to implement swapfile support. It *looks* like it's 
surprisingly uncomplicated - to the point where I suspect I'm missing 
something, and would like some sanity checking.

My primary references for this are the patch[1] implementing swap-over-NFS 
and HEAD of cmason's for-linus branch.

I'm going to go over the sections of the commitdiff from top to bottom (and 
hunk-by-hunk where I feel it necessary), and I'd like it if people could 
correct any mistakes I make.

Kconfig:
Simple enough that I'm not worried.

direct.c:
The first hunk seems to serve to factor out the difference between 
rw={READ,WRITE} and the KERNEL_ equivalents into a 'uio' parameter, so I'll 
view it as being mostly a code organization thing.

The second hunk just adds that uio param to read_schedule_segment(), which 
it is given secondhand via direct_read().

The third hunk seems to be where the actual reading occurs in 
read_schedule_segment(), and the differences between uio and !uio seem to 
boil down to that KERNEL_READ is only allowed to operate one page at a time 
under penalty of BUG, and that it uses get_kernel_page instead of 
get_user_pages. Since btrfs calls into __blockdev_direct_IO(), I suspect 
that fs/direct-io.c would (in this case) be the right place to implement 
both the {READ,WRITE} vs KERNEL_* logic and those checks in this case. Also, 
check_direct_IO() in fs/btrfs/inode.c may want to treat KERNEL_WRITE 
similarly to WRITE - I'm not completely sure of that, however.

Hunks 4-8 are just dealing with passing the additional uio parameter around.

Hunk 9 is the write-side equivalent of hunk 3, and seems to correspond 
pretty exactly. It's looking like fs/direct_io.c is definitely the place to 
implement this.

Hunks 10-17 are more uio parameter passing.

file.c:
Pretty simple - as far as I can tell, the activate() sets the span to what 
the swap header expects, the xs_swapper call basically sets the appropriate 
kmalloc flags for the network stuff (irrelevant here), and the deactivate() 
just resets those flags. All the smarts seem to be in the DIO code.

The rest:
The remainder of the patch seems to just be a.) handing that uio parameter 
around and b.) stuff specific to swapping over the network.

Did I miss anything important? If not, I may well decide to tackle this as 
my first non-trivial kernel contribution. Does anyone have any suggestions 
on how I should stresstest this? I figure a good starting point would be 
running xfstests under memory pressure with such a swapfile.

[1] 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;h=a564b8f


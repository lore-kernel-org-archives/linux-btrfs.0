Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:42292 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757737Ab2IKSky (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Sep 2012 14:40:54 -0400
Date: Tue, 11 Sep 2012 14:40:51 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Wade Cline <clinew@linux.vnet.ibm.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "cmm@linux.vnet.ibm.com" <cmm@linux.vnet.ibm.com>
Subject: Re: DIO Write Regression on Preallocated Extents
Message-ID: <20120911184051.GH2270@localhost.localdomain>
References: <504F756B.4020901@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <504F756B.4020901@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2012 at 11:31:23AM -0600, Wade Cline wrote:
> Hi,
> 
> I was doing some fragmentation tests on preallocated extents on Josef's
> btrfs-next branch (commit 8fe3b6) with the O_DIRECT flag enabled and
> noticed some strange behavior. Writing to a preallocated extent
> currently triggers a WARN_ON on in the kernel, triggers a csum error for
> what appears to be each block, and causes the remaining preallocated
> (and not written-to) area to read 1's.
> 
> The issue seems to have appeared in commit 8d37ef "Btrfs: improve fsync
> by filtering extents that we want" but the issues started earlier in
> 16ecb6 "Btrfs: turbo charge fsync". Prior to 16ecb6, direct I/O on
> preallocated extents was not generating false data, after 16ecb6 direct
> I/O was not writing -any- data, and after 8d37ef direct I/O was
> generating false data.
> 
> The tests were done using a simple program I wrote (below) which
> preallocates a 128k file and performs a 4096-byte write.
> 
> Steps to reproduce:
> 
> mkfs.btrfs /dev/sdb
> mount -t btrfs /dev/sdb /mnt/btrfs
> cd /mnt/btrfs
> gcc -o main <../main.c>
> ./main single direct
> od -A x -t x2 testfile
> 
> It seems that the issue in part occurs in unpin_extent_cache:
> 
>      WARN_ON(!em || em->start != start);
> 
> printk() shows that the function expects the extent_map for the write
> performed but instead receives the extent_map for the entire
> preallocated extent. The extent_map is then marked as read:
> 
>      if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) {
>          prealloc = true;
>          clear_bit(EXTENT_FLAG_PREALLOC, &em->flags);
>      }
> 
> which also causes fragmentation issues from further writes. I am not
> sure where the 1's are generated, though; using dd to check the on-disk
> contents shows that the data is uninitialized.
> 
> I don't currently have a patch for this, but thought it was important
> enough to bring up. Below are the od output, the main.c code I used to
> produce this error, and the kernel message. Let me know if you have any
> questions.

Heh oops sorry about that, I know what's wrong and I thought about it when I was
writing these patches but then I never went back to check to make sure DIO did
the right thing.  I will fix it up and run your test to make sure I got it
right.  Thanks,

Josef

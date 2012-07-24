Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33146 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab2GXGSi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jul 2012 02:18:38 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1StYS5-0005D3-Sk
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Jul 2012 23:18:37 -0700
Date: Mon, 23 Jul 2012 23:18:37 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Message-ID: <20120724061837.GC15507@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 22, 2012 at 11:42:03PM -0700, Marc MERLIN wrote:
> I just realized that the older thread got a bit confusing, so I'll keep
> problems separate and make things simpler :)
 
Since yesterday, I tried other kernels, including noprempt, volprempt and
preempt for 3.4.4.
I also tried a default 3.2.0 kernel from debian (all amd64), but that did
not help. I'm still seeing close to 25 seconds to scan 15K files.

How can it possibly be so slow?
More importantly how I can provide useful debug information.

- I don't think it's a problem with the kernel since I tried 4 kernels,
  including a default debian one.

- Alignement seem ok, I made sure cylinders was divisible by 512:
/dev/sda2          502272    52930559    26214144   83  Linux

- I tried another brand new btrfs, and thing are even slower now.
gandalfthegreat:/mnt/mnt2# mount -o ssd,discard,noatime /dev/sda2 /mnt/mnt2
gandalfthegreat:/mnt/mnt2# reset_cache 
gandalfthegreat:/mnt/mnt2# time du -sh src/
514M	src/
real	0m29.584s
gandalfthegreat:/mnt/mnt2# find src/| wc -l
15261

This is bad enough that there ought to be a way to debug this, right?

Can you suggest something?

Thanks,
Marc

> On an _unencrypted_ partition on the SSD, running du -sh on a directory
> with 15K files, takes 23 seconds on unencrypted SSD and 4 secs on
> encrypted spinning drive, both with a similar btrfs filesystem, and 
> the same kernel (3.4.4).
> 
> Unencrypted btrfs on SSD:
> gandalfthegreat:~# mount -o compress=lzo,discard,nossd,space_cache,noatime /dev/sda2 /mnt/mnt2
> gandalfthegreat:/mnt/mnt2# echo 3 > /proc/sys/vm/drop_caches; time du -sh src
> 514M	src
> real	0m22.667s
> 
> Encrypted btrfs on spinning drive of the same src directory:
> gandalfthegreat:/var/local# echo 3 > /proc/sys/vm/drop_caches; time du -sh src
> 514M	src
> real	0m3.881s
> 
> I've run this many times and get the same numbers.
> I've tried deadline and noop on /dev/sda (the SSD) and du is just as slow.  
> 
> I also tried with:
> - space_cache and nospace_cache
> - ssd and nossd
> - noatime didn't seem to help even though I was hopeful on this one.
> 
> In all cases, I get:
> gandalfthegreat:/mnt/mnt2# echo 3 > /proc/sys/vm/drop_caches; time du -sh src
> 514M	src
> real	0m22.537s
> 
> 
> I'm having the same slow speed on 2 btrfs filesystems on the same SSD.
> One is encrypted, the other one isnt:
> Label: 'btrfs_pool1'  uuid: d570c40a-4a0b-4d03-b1c9-cff319fc224d
> 	Total devices 1 FS bytes used 144.74GB
> 	devid    1 size 441.70GB used 195.04GB path /dev/dm-0
> 
> Label: 'boot'  uuid: 84199644-3542-430a-8f18-a5aa58959662
> 	Total devices 1 FS bytes used 2.33GB
> 	devid    1 size 25.00GB used 5.04GB path /dev/sda2
> 
> If instead of stating a bunch of files, I try reading a big file, I do get speeds
> that are quite fast (253MB/s and 423MB/s).
> 
> 22 seconds for 15K files on an SSD is super slow and being 5 times
> slower than a spinning disk with the same data.
> What's going on?
> 
> Thanks,
> Marc

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

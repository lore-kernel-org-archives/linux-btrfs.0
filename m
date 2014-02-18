Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50829 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaBRC4Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Feb 2014 21:56:16 -0500
Message-ID: <5302CE3E.6010800@oracle.com>
Date: Tue, 18 Feb 2014 11:06:38 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: know mount location with in FS
References: <5300D31E.6000600@oracle.com> <5302453B.8000509@redhat.com>
In-Reply-To: <5302453B.8000509@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> For what reason?
>
> Remember that a single block device can be mounted in multiple places
 > (or bind-mounted, etc), so there is not even necessarily a single
 > answer to that question.
>
> -Eric

  Yes indeed. (the attempt is should we be able to maintain all
  the mount points as a list saved/updated under per fs_devices. ?)

  some of the exported symbols at fs/namei.c looks closely
  related to the purpose here, but it didn't help unless
  I missed something.

  any comment is helpful..

  The reason:
     First of all btrfs-progs has used "scan-all-disks" very
     liberally which isn't a scalable design (imagine a data
     center with 1000's of LUN).
     Even a simple check_mounted() does scan-all-disks (when
     total_disk >1), that isn't necessary if the kernel could
     let it know.
     Scan for btrfs has expensive steps of reading each super-block,
     and the effect is, in general most of the btrfs-progs commands
     are very very slow when things like scrub is running.
     check_mounted() fails when seeding is used (since
     /proc/self/mounts would show disk with lowest devid and in
     most common scenario it will be a seed disk. (which has
     different FSID from the actual disk in question). and
     Further most severe problem is some btrfs-progs threads has been
     scan-all-disks more than once during the thread's life time.
     So a total revamp of this design has become an immediate need.

     What I am planning is
        - btrfs-progs to init btrfs-disk-list once per required thread
          (mostly use BTRFS_IOC_GET_DEVS, which would dump anything
          and everything about the btrfs devices)
        - the btrfs-disk-list is obtained from kernel first, and will
          fill with the remaining disks which kernel isn't aware of.
        - If the step one also provides the mount point(s) from the
          kernel that would complete the loop with what end user
          would want to know.


Thanks, Anand

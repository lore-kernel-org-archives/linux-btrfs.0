Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:65328 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbaBRIkV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 03:40:21 -0500
Received: from frosties.localnet ([149.172.224.32]) by smtp.web.de (mrweb003)
 with ESMTPSA (Nemesis) id 0Lheu9-1X1xSc2b4r-00mqi1 for
 <linux-btrfs@vger.kernel.org>; Tue, 18 Feb 2014 09:40:19 +0100
Date: Tue, 18 Feb 2014 09:40:18 +0100
From: Goswin von Brederlow <goswin-v-b@web.de>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: know mount location with in FS
Message-ID: <20140218084017.GB19265@frosties>
References: <5300D31E.6000600@oracle.com>
 <5302453B.8000509@redhat.com>
 <5302CE3E.6010800@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5302CE3E.6010800@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 18, 2014 at 11:06:38AM +0800, Anand Jain wrote:
> 
> >For what reason?
> >
> >Remember that a single block device can be mounted in multiple places
> > (or bind-mounted, etc), so there is not even necessarily a single
> > answer to that question.
> >
> >-Eric
> 
>  Yes indeed. (the attempt is should we be able to maintain all
>  the mount points as a list saved/updated under per fs_devices. ?)
> 
>  some of the exported symbols at fs/namei.c looks closely
>  related to the purpose here, but it didn't help unless
>  I missed something.
> 
>  any comment is helpful..
> 
>  The reason:
>     First of all btrfs-progs has used "scan-all-disks" very
>     liberally which isn't a scalable design (imagine a data
>     center with 1000's of LUN).
>     Even a simple check_mounted() does scan-all-disks (when
>     total_disk >1), that isn't necessary if the kernel could
>     let it know.
>     Scan for btrfs has expensive steps of reading each super-block,
>     and the effect is, in general most of the btrfs-progs commands
>     are very very slow when things like scrub is running.
>     check_mounted() fails when seeding is used (since
>     /proc/self/mounts would show disk with lowest devid and in
>     most common scenario it will be a seed disk. (which has
>     different FSID from the actual disk in question). and
>     Further most severe problem is some btrfs-progs threads has been
>     scan-all-disks more than once during the thread's life time.
>     So a total revamp of this design has become an immediate need.
> 
>     What I am planning is
>        - btrfs-progs to init btrfs-disk-list once per required thread
>          (mostly use BTRFS_IOC_GET_DEVS, which would dump anything
>          and everything about the btrfs devices)
>        - the btrfs-disk-list is obtained from kernel first, and will
>          fill with the remaining disks which kernel isn't aware of.
>        - If the step one also provides the mount point(s) from the
>          kernel that would complete the loop with what end user
>          would want to know.
> 
> 
> Thanks, Anand

What about mountpoints outside the current filesystem namespace or
ones that should be shortened to the filesystem namespace (e.g. in a
chroot the leading dirs need to be cut)?

MfG
	Goswin

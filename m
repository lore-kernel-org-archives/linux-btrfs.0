Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52101 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751339AbbDNEGP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Apr 2015 00:06:15 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Chris Mason'" <clm@fb.com>, <linux-btrfs@vger.kernel.org>
References: <cover.1428554022.git.zhaolei@cn.fujitsu.com> <4a2f9c8918b1386ef6296d52ee4e331b7099b247.1428554023.git.zhaolei@cn.fujitsu.com> <552BD8C1.3000400@fb.com>
In-Reply-To: <552BD8C1.3000400@fb.com>
Subject: RE: [PATCH 8/9] btrfs: wait for delayed iputs on no space
Date: Tue, 14 Apr 2015 12:06:02 +0800
Message-ID: <03bd01d07668$52e0e090$f8a2a1b0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris

> -----Original Message-----
> From: Chris Mason [mailto:clm@fb.com]
> Sent: Monday, April 13, 2015 10:55 PM
> To: Zhaolei; linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH 8/9] btrfs: wait for delayed iputs on no space
> 
> On 04/09/2015 12:34 AM, Zhaolei wrote:
> > From: Zhao Lei <zhaolei@cn.fujitsu.com>
> >
> > btrfs will report no_space when we run following write and delete file
> > loop:
> >  # FILE_SIZE_M=[ 75% of fs space ]
> >  # DEV=[ some dev ]
> >  # MNT=[ some dir ]
> >  #
> >  # mkfs.btrfs -f "$DEV"
> >  # mount -o nodatacow "$DEV" "$MNT"
> >  # for ((i = 0; i < 100; i++)); do dd if=/dev/zero of="$MNT"/file0
> > bs=1M count="$FILE_SIZE_M"; rm -f "$MNT"/file0; done  #
> >
> > Reason:
> >  iput() and evict() is run after write pages to block device, if
> > write pages work is not finished before next write, the "rm"ed space
> > is not freed, and caused above bug.
> >
> > Fix:
> >  We can add "-o flushoncommit" mount option to avoid above bug, but
> > it have performance problem. Actually, we can to wait for on-the-fly
> > writes only when no-space happened, it is which this patch do.
> 
> Can you please change this so we only do this flush if the first commit doesn't
> free up enough space?  I think this is going to have a performance impact as
> the FS fills up.
> 
btrfs_wait_ordered_roots() can only ensure that all bio are finished,
and relative iputs are added into delayed_iputs in end_io.
And we need 2 commit to make free space accessable:
One for run delayed_iputs(), and another for unpin.

It is why I put above line to first commit, to ensure we have
enough commit operation to make free space accessable.

It is only called then the disk is almost full, and have no performance impact
in most case(disk not full).

Another way is to call btrfs_wait_ordered_roots() after first commit() try,
but give it addition commit().

Thanks
Zhaolei



Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37899 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750867AbcEQWCI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 18:02:08 -0400
Date: Tue, 17 May 2016 18:01:43 -0400
From: Chris Mason <clm@fb.com>
To: Adam Borowski <kilobyte@angband.pl>
CC: <linux-btrfs@vger.kernel.org>, <dsj@fb.com>,
        Jakob =?iso-8859-1?Q?Sch=FCrz?= <wertstoffe@nurfuerspam.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH] Btrfs: fix handling of faults from btrfs_copy_from_user
Message-ID: <20160517220143.hboszkdhfioxkbpy@floor.thefacebook.com>
References: <20160516210655.sfsjtj5oleeksaxq@floor.thefacebook.com>
 <20160517151451.GA3882@angband.pl>
 <20160517162344.3znjdtgvfke2ouke@floor.thefacebook.com>
 <20160517204726.GA4851@angband.pl>
 <20160517210049.cjqryttwjxgsszkv@floor.thefacebook.com>
 <20160517215707.GA9430@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20160517215707.GA9430@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 17, 2016 at 11:57:07PM +0200, Adam Borowski wrote:
> On Tue, May 17, 2016 at 05:00:49PM -0400, Chris Mason wrote:
> > On Tue, May 17, 2016 at 10:47:27PM +0200, Adam Borowski wrote:
> > > > Hmmm, some of your traces mentioned compression, do you have compression
> > > > enabled?
> > > 
> > > Yeah, I mount with noatime,compress=lzo.
> > > 
> > > > Also, if you can gdb your vmlinux (or btrfs.ko) and find this line:
> > > > 
> > > > gdb> list *__btrfs_buffered_write+0x748
> > > 
> > > 0xffffffff8152eb78 is in __btrfs_buffered_write (fs/btrfs/file.c:1564).
> > > 1559	
> > > 1560	reserve_metadata:
> > > 1561			ret = btrfs_delalloc_reserve_metadata(inode, reserve_bytes);
> > > 1562			if (ret) {
> > > 1563				if (!only_release_metadata)
> > > 1564					btrfs_free_reserved_data_space(inode, pos,
> > > 1565								       write_bytes);
> > > 1566				else
> > > 1567					btrfs_end_write_no_snapshoting(root);
> > > 1568				break;
> > > 
> > 
> > Aha, so you're getting an enospc with compression on and the accounting
> > doesn't line up.  I should be able to trigger this.
> 
> This partition was fully balanced just a few days ago so I didn't even think
> to look at df.
> 
> [~]# df -h
> /dev/sda1       216G  161G   53G  76% /
> 
> [~]# btrfs files df /
> Data, single: total=209.12GiB, used=156.46GiB
> System, single: total=32.00MiB, used=48.00KiB
> Metadata, single: total=6.00GiB, used=3.51GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> However, after partially balancing it a bit:
> 
> [~]# btrfs files df /
> Data, single: total=172.00GiB, used=156.03GiB
> System, single: total=32.00MiB, used=48.00KiB
> Metadata, single: total=5.00GiB, used=3.50GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> I can't reproduce the failure anymore.

Yeah, I'm not sure yet if this is related to the page faulting problem,
but Dave Jones triggered this error back in v4.4.  I'll still fix it, it
should be an alignment issue with write_bytes.

-chris


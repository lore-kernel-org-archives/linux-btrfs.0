Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33948 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab3HLNsp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Aug 2013 09:48:45 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E2A119A0406
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Aug 2013 07:48:44 -0600 (MDT)
Date: Mon, 12 Aug 2013 09:48:40 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Why does btrfs benchmark so badly in this case?
Message-ID: <20130812134840.GA2150@localhost.localdomain>
References: <CAJBj3vcfSrWC3sxxxin93GYYPZY_z_MJnAHoMxB45MFqEXYXkA@mail.gmail.com>
 <20130808194015.GH16712@localhost.localdomain>
 <CAJBj3vfrHPDhM579JZDhUQgmyd2PnUtrgwYX0718tOrK8MzNCA@mail.gmail.com>
 <20130808203855.GI16712@localhost.localdomain>
 <8u3gda-evs.ln1@hurikhan77.spdns.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <8u3gda-evs.ln1@hurikhan77.spdns.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 09, 2013 at 11:35:33PM +0200, Kai Krakow wrote:
> Josef Bacik <jbacik@fusionio.com> schrieb:
> 
> >> So I guess the reason that ZFS does well with that workload is that
> >> ZFS is using smaller blocks, maybe just 512B ?
> > 
> > Yeah I'm not sure what ZFS does, but if you are writing over a block and
> > the size/offset isn't aligned then you'd see similar issues with ZFS since
> > it would
> > have to read+modify+write.  It is likely that ZFS just is using a smaller
> > blocksize.
> 
> From what I remember, ZFS uses dynamic block sizes. However, block size can 
> be forced and thus tuned for workloads that require it:
> 
> http://www.joyent.com/blog/bruning-questions-zfs-record-size
> 
> Maybe that's the reason...
> 
> It would be interesting to see how the benchmarks performed with forced 
> block size.
> 

When I did bs=4k in the fio job to force it to use 4k blocksizes we performed
the same as ext4 and xfs.  Thanks,

Josef

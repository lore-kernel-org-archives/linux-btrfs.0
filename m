Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:46290 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S966550Ab3HHVAB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 17:00:01 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:50810 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1V7XJP-002lEy-CE
	for linux-btrfs@vger.kernel.org; Thu, 08 Aug 2013 15:00:00 -0600
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Why does btrfs benchmark so badly in this case?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAJBj3vfrHPDhM579JZDhUQgmyd2PnUtrgwYX0718tOrK8MzNCA@mail.gmail.com>
Date: Thu, 8 Aug 2013 14:59:55 -0600
Message-Id: <2A60AA23-4496-4C0F-9B4A-22DF5DB3884F@colorremedies.com>
References: <CAJBj3vcfSrWC3sxxxin93GYYPZY_z_MJnAHoMxB45MFqEXYXkA@mail.gmail.com> <20130808194015.GH16712@localhost.localdomain> <CAJBj3vfrHPDhM579JZDhUQgmyd2PnUtrgwYX0718tOrK8MzNCA@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 8, 2013, at 2:23 PM, John Williams <jwilliams4200@gmail.com> wrote:
> 
> So I guess the reason that ZFS does well with that workload is that
> ZFS is using smaller blocks, maybe just 512B ?

Likely. It uses a variable block size.


> I wonder how common these type of non-4K aligned workloads are.
> Apparently, people with such workloads should avoid btrfs, but maybe
> these types of workloads are very rare?

I can't directly answer the question, but all of the typical file systems on OS X, Linux, and Windows default to 4KB block sizes for many years now, baked in at creation time. On OS X, the block size varies automatically with respect to volume size at fs creation time (it goes to 8KB block sizes above 2TB, and scales up to 1MB block sizes), but still isn't ever less than 4KB unless manually created this way. So I'd think such workloads are rare.

I also don't know if any common use fs has an optimization whereby just the modified sector(s) is overwritten, rather than all sectors making up the file system block being modified.

Chris Murphy
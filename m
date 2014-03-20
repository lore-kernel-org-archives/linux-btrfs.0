Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:52240 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaCTDUe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 23:20:34 -0400
Received: from /spool/local
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <aneesh.kumar@linux.vnet.ibm.com>;
	Thu, 20 Mar 2014 08:50:31 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 75B22E0044
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Mar 2014 08:54:22 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s2K3KMKf459132
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Mar 2014 08:50:22 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s2K3KSo4022249
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Mar 2014 08:50:28 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: dsterba@suse.cz, chandan <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6 EARLY RFC] Btrfs: Get rid of whole page I/O.
In-Reply-To: <20140319184107.GJ29256@suse.cz>
References: <1394634033-2528-1-git-send-email-chandan@linux.vnet.ibm.com> <20140317145555.GG29256@twin.jikos.cz> <1785327.CGV06aaKrn@localhost.localdomain> <20140319184107.GJ29256@suse.cz>
Date: Thu, 20 Mar 2014 08:50:27 +0530
Message-ID: <87a9climis.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba <dsterba@suse.cz> writes:

> On Tue, Mar 18, 2014 at 01:48:00PM +0630, chandan wrote:
>> The earlier patchset posted by Chandra Seethraman was to get 4k
>> blocksize to work with ppc64's 64k PAGE_SIZE.
>
> Are we talking about metadata block sizes or data block sizes?
>
>> The root node of "tree root" tree has 1957 bytes being written by
>> make_btrfs() (in btrfs-progs).  Hence I chose to do 2k blocksize for
>> the initial subpagesize-blocksize work. So with this patchset the
>> supported blocksizes would be in the range 2k-64k.
>
> So it's metadata blocks, and in this case 2k looks like the only
> allowed size that's smaller than 4k, and thus can demonstrage sub-page
> size allocations. I'm not sure if this is limiting for potential future
> extensions of metadata structures that could be larger.
>
> 2k is ok for testing purposes, but I think a 4k-page machine will hardly
> use a smaller page size. The more that 16k metadata blocks are now
> default.

The goal is to remove the assumption that supported blocks size is >= page
size. The primary reason to do that is to support migration of disk
devices across different architectures. If we have a btrfs disk created
on x86 box with data blocksize 4K and meta data block size 16K we should
make sure that, the disk can be read/written from ppc64 box (which have a page
size of 64K). To enable easy testing and community development we are
now focusing on achieving 2K data blocksize and 2K meata data block size
on x86. As you said this will never be used in production.

To achieve that we did the below
*) Add offset and len to btrfs_io_bio. These are file offsets and
len. This is later used to unlock extent io tree.

*) Now we also need to make sure that submit_extent_page only submit
 contiguous range in the file offset range. ie if we have holes in
 between we split them into two submit_extent_page.  This ensures that
 btrfs_io_bio offset and len represent a contiguous range.

Please let us know whether the above approach is acceptable.

 -aneesh
 


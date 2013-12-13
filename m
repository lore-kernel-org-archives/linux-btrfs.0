Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24498 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849Ab3LMSju (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 13:39:50 -0500
Message-ID: <52AB5470.3090108@fb.com>
Date: Fri, 13 Dec 2013 13:39:44 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Chandra Seetharaman <sekharan@us.ibm.com>, <linux-btrfs@vger.kernel.org>,
        <chandra_pdx@yahoo.com>
Subject: Re: [PATCH 0/7] Patches to support subpagesize blocksize
References: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 12/11/2013 06:38 PM, Chandra Seetharaman wrote:
> In btrfs, blocksize, the basic IO size of the filesystem, has been
> more than PAGE_SIZE.
>
> But, some 64 bit architures, like PPC64 and ARM64 have the default
> PAGE_SIZE as 64K, which means the filesystems handled in these
> architectures are with a blocksize of 64K.
>
> This works fine as long as you create and use the filesystems within
> these systems.
>
> In other words, one cannot create a filesystem in some other architecture
> and use that filesystem in PPC64 or ARM64, and vice versa.,
>
> Another restriction is that we cannot use ext? filesystems in these
> architectures as btrfs filesystems, since ext? filesystems have a blocksize
> of 4K.
>
> Sometime last year, Wade Cline posted a patch(http://lwn.net/Articles/529682/).
> I started testing it, and found many locking/race issues. So, I changed the
> logic and created an extent_buffer_head that holds an array of extent buffers that
> belong to a page.
>
> There are few wrinkles in this patchset, like some xfstests are failing, which
> could be due to me doing something incorrectly w.r.t how the blocksize and
> PAGE_SIZE are used in these patched.
>
> Would like to get some feedback, review comments.
>

Ok so the more we talked about it on IRC and talking with Chris I think 
we have a way forward here.

1) Add an extent_buffer_head that embeds an extent_buffer, and in the 
extent_buffer_head track the state of the whole page.  So this is where 
we have a linked list of all the extent_buffers on the page, we can keep 
track of the number of extent_buffers that are dirty/not so we can be 
sure to set the page state and everything right.

2) Set page->private to the first extent_buffer like we currently do.  
Then we just have checks in the endio stuff to see if the eb we found is 
the one for our currently range (ie bv_offset == 0) and if not do a 
linear search through the extent_buffers on the extent_buffer_head part 
to get the right one.

We have to do this because we need to be able to track IO for each of 
the extent_buffer's independently of each other in case a page spans a 
block_group.

Hopefully that makes sense, this way you don't have to futz with any of 
my crazier long term goals of no longer using pagecache or any of that 
mess.  Thanks,

Josef

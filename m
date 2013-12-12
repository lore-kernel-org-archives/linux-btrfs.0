Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35222 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751691Ab3LLUkg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 15:40:36 -0500
Message-ID: <52AA1F3D.6040501@fb.com>
Date: Thu, 12 Dec 2013 15:40:29 -0500
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

So I hate this whole approach, but that's not your fault ;).  We already 
keep track of what we need in the extent_buffer, adding a whole other 
layer of abstraction onto that will make me a very unhappy person.  The 
biggest problem with sub-page size block sizes is knowing when the page 
is really dirty or really clean.  For the most part we've done away with 
most of the tracking of the actual page state for metadata, we use flags 
on the EB for this.  We still depend on the page state for things like 
btree_write_cache_pages and being able to write out the transaction, but 
we can just replace that logic with setting the same tags in the extent 
buffer radix tree.  Then the only part we need to figure out is how to 
do the balance_dirty_pages() dance appropriately.  I'd be half tempted 
to just do account_page_dirtied() every time we mark an extent buffer 
dirty and then just abuse the metadata BDI's min_ratio/max_ratio to make 
sure it's properly adjusted for how many extent buffers per pages there 
are and see how that works, we should be able to adjust it so we're 
flushing as much as normal.  This should be simpler to implement and 
touch less stuff.  Thanks,

Josef

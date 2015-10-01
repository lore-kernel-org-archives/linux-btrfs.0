Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21101 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031AbbJAOsk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 10:48:40 -0400
Subject: Re: [PATCH V5 13/13] Btrfs: Return valid delalloc range when the page
 does not have PG_Dirty flag set or has been invalidated
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
References: <1443608912-31667-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1443608912-31667-14-git-send-email-chandan@linux.vnet.ibm.com>
CC: <clm@fb.com>, <bo.li.liu@oracle.com>, <dsterba@suse.cz>,
        <quwenruo@cn.fujitsu.com>, <chandan@mykolab.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <560D47B7.4000106@fb.com>
Date: Thu, 1 Oct 2015 10:48:23 -0400
MIME-Version: 1.0
In-Reply-To: <1443608912-31667-14-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/30/2015 06:28 AM, Chandan Rajendra wrote:
> The following issue was observed when running generic/095 test on
> subpagesize-blocksize patchset.
>
> Assume that we are trying to write a dirty page that is mapping file offset
> range [159744, 163839].
>
> writepage_delalloc()
>    find_lock_delalloc_range(*start = 159744, *end = 0)
>      find_delalloc_range()
>        Returns range [X, Y] where (X > 163839)
>      lock_delalloc_pages()
>        One of the pages in range [X, Y] has dirty flag cleared;
>        Loop once more restricting the delalloc range to span only
>        PAGE_CACHE_SIZE bytes;
>      find_delalloc_range()
>        Returns range [356352, 360447];
>      lock_delalloc_pages()
>        The page [356352, 360447] has dirty flag cleared;
>      Returns with *start = 159744 and *end = 0;
>    *start = *end + 1;
>    find_lock_delalloc_range(*start = 1, *end = 0)
>      Finds and returns delalloc range [1, 12288];
>    cow_file_range()
>      Clears delalloc range [1, 12288]
>      Create ordered extent for range [1, 12288]
>
> The ordered extent thus created above breaks the rule that extents have to be
> aligned to the filesystem's block size.
>
> In cases where lock_delalloc_pages() fails (either due to PG_dirty flag being
> cleared or the page no longer being a member of the inode's page cache), this
> patch sets and returns the delalloc range that was found by
> find_delalloc_range().
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:36131 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777AbcCaLkH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 07:40:07 -0400
Subject: Re: fallocate mode flag for "unshare blocks"?
To: bo.li.liu@oracle.com
References: <20160302155007.GB7125@infradead.org>
 <20160330182755.GC2236@birch.djwong.org>
 <20160331003242.GA5813@localhost.localdomain> <56FD079F.3060606@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, linux-api@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56FD0C49.7040308@gmail.com>
Date: Thu, 31 Mar 2016 07:38:49 -0400
MIME-Version: 1.0
In-Reply-To: <56FD079F.3060606@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-31 07:18, Austin S. Hemmelgarn wrote:
> On 2016-03-30 20:32, Liu Bo wrote:
>> On Wed, Mar 30, 2016 at 11:27:55AM -0700, Darrick J. Wong wrote:
>>> Hi all,
>>>
>>> Christoph and I have been working on adding reflink and CoW support to
>>> XFS recently.  Since the purpose of (mode 0) fallocate is to make sure
>>> that future file writes cannot ENOSPC, I extended the XFS fallocate
>>> handler to unshare any shared blocks via the copy on write mechanism I
>>> built for it.  However, Christoph shared the following concerns with
>>> me about that interpretation:
>>>
>>>> I know that I suggested unsharing blocks on fallocate, but it turns out
>>>> this is causing problems.  Applications expect falloc to be a fast
>>>> metadata operation, and copying a potentially large number of blocks
>>>> is against that expextation.  This is especially bad for the NFS
>>>> server, which should not be blocked for a long time in a synchronous
>>>> operation.
>>>>
>>>> I think we'll have to remove the unshare and just fail the fallocate
>>>> for a reflinked region for now.  I still think it makes sense to expose
>>>> an unshare operation, and we probably should make that another
>>>> fallocate mode.
>>
>> I'm expecting fallocate to be fast, too.
>>
>> Well, btrfs fallocate doesn't allocate space if it's a shared one
>> because it thinks the space is already allocated.  So a later overwrite
>> over this shared extent may hit enospc errors.
> And this _really_ should get fixed, otherwise glibc will add a check for
> running posix_fallocate against BTRFS and force emulation, and people
> _will_ complain about performance.
>
Thinking a bit further about this, how hard would it be to add the 
ability to have unwritten extents point somewhere else for reads?  Then 
when we get an fallocate call, we create the unwritten extents, and add 
the metadata to make them read from the shared region.  Then, when a 
write gets issued to that extent, the parts that aren't being written in 
that block get copied, the write happens, and then the link for that 
block gets removed.  This way, fallocate would still provide the correct 
semantics, it would be relatively fast (still not quite as fast as it is 
now, but it wouldn't be anywhere near as slow as copying the data), and 
the cost of copying gets amortized across writes (we may not need to 
copy everything, but we'll still copy less than we would for just 
un-sharing the extent).  This would of course need to be an incompat 
feature, but I would personally say that's not as much of an issue, as 
things are subtly broken in the common use-case right now (at this point 
I'm just thinking BTRFS, as what Darrick suggested for XFS seems to be a 
better solution there at least short term).

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57985 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754174AbeEWH6l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 03:58:41 -0400
Subject: Re: [PATCH] Btrfs: implement unlocked buffered write
To: Christoph Hellwig <hch@infradead.org>, Chris Mason <clm@fb.com>
Cc: robbieko <robbieko@synology.com>, linux-btrfs@vger.kernel.org
References: <1526442757-7167-1-git-send-email-robbieko@synology.com>
 <20180522180828.GA8340@infradead.org>
 <D87124BA-3EEC-480F-8520-EBD3B5A33C04@fb.com>
 <20180523063713.GA18285@infradead.org>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <66878a15-902b-dff8-1604-a918e2b25298@suse.com>
Date: Wed, 23 May 2018 10:58:36 +0300
MIME-Version: 1.0
In-Reply-To: <20180523063713.GA18285@infradead.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23.05.2018 09:37, Christoph Hellwig wrote:
> On Tue, May 22, 2018 at 02:31:36PM -0400, Chris Mason wrote:
>>> And what protects two writes from interleaving their results now?
>>
>> page locks...ish, we at least won't have results interleaved in a single
>> page.  For btrfs it'll actually be multiple pages since we try to do more
>> than one at a time.
> 
> I think you are going to break just about every assumption people
> have that any single write is going to be atomic vs another write.
> 
> E.g. this comes from the posix read definition reference by the
> write definition:
> 
> "I/O is intended to be atomic to ordinary files and pipes and FIFOs.
> Atomic means that all the bytes from a single operation that started out
> together end up together, without interleaving from other I/O
> operations. It is a known attribute of terminals that this is not
> honored, and terminals are explicitly (and implicitly permanently)
> excepted, making the behavior unspecified. The behavior for other device
> types is also left unspecified, but the wording is intended to imply
> that future standards might choose to specify atomicity (or not).
> "
> 
> Without taking the inode lock (or some sort of range lock) you can
> easily interleave data from two write requests.
> 
>> But we're not avoiding the inode lock completely, we're just dropping it for
>> the expensive parts of writing to the file.  A quick guess about what the
>> expensive parts are:
> 
> The way I read the patch it basically 'avoids' the inode lock for almost
> the whole write call, just minus some setup.

You are right, this drops the inode_lock for some rather crucial ops:
prepare_pages - this one allocates pages in the page cache mapping for
this inode and locks them

lock_and_cleanup_extent_if_need - this one completes any previous writes
for the range currenlty being written and locks the range of extents.

Looking at the code I *think* the locking provided by
prepare_pages/lock_and_cleanup_extent_if_need *should* provide the
necessary exclusivity to guarantee atomicity w.r.t to different writes.

So Robbie,

This reliance on btrfs-internal locks to provide exclusivity *must* be
explicitly documented in the commit log.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

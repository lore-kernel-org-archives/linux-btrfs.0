Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54174 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933004AbeEWSB2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 14:01:28 -0400
From: Chris Mason <clm@fb.com>
To: Christoph Hellwig <hch@infradead.org>
CC: robbieko <robbieko@synology.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: implement unlocked buffered write
Date: Wed, 23 May 2018 14:01:01 -0400
Message-ID: <8865E1CB-559D-4193-B549-98CEEE9AD055@fb.com>
In-Reply-To: <20180523063713.GA18285@infradead.org>
References: <1526442757-7167-1-git-send-email-robbieko@synology.com>
 <20180522180828.GA8340@infradead.org>
 <D87124BA-3EEC-480F-8520-EBD3B5A33C04@fb.com>
 <20180523063713.GA18285@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23 May 2018, at 2:37, Christoph Hellwig wrote:

> On Tue, May 22, 2018 at 02:31:36PM -0400, Chris Mason wrote:
>>> And what protects two writes from interleaving their results now?
>>
>> page locks...ish, we at least won't have results interleaved in a 
>> single
>> page.  For btrfs it'll actually be multiple pages since we try to do 
>> more
>> than one at a time.
>
> I think you are going to break just about every assumption people
> have that any single write is going to be atomic vs another write.
>
> E.g. this comes from the posix read definition reference by the
> write definition:
>
> "I/O is intended to be atomic to ordinary files and pipes and FIFOs.
> Atomic means that all the bytes from a single operation that started 
> out
> together end up together, without interleaving from other I/O
> operations. It is a known attribute of terminals that this is not
> honored, and terminals are explicitly (and implicitly permanently)
> excepted, making the behavior unspecified. The behavior for other 
> device
> types is also left unspecified, but the wording is intended to imply
> that future standards might choose to specify atomicity (or not).
> "
>
> Without taking the inode lock (or some sort of range lock) you can
> easily interleave data from two write requests.

"This volume of IEEE Std 1003.1-2001 does not specify behavior of 
concurrent writes to a file from multiple processes. Applications should 
use some form of concurrency control."

I'm always more worried about truncate than standards ;)  But just to be 
clear, I'm not disagreeing with you at all.  Interleaved writes just 
wasn't the first thing that jumped to my mind.

>
>> But we're not avoiding the inode lock completely, we're just dropping 
>> it for
>> the expensive parts of writing to the file.  A quick guess about what 
>> the
>> expensive parts are:
>
> The way I read the patch it basically 'avoids' the inode lock for 
> almost
> the whole write call, just minus some setup.

Yeah, if we can get 90% of the way there by pushing some 
balance_dirty_pages() outside the lock (or whatever other expensive 
setup we're doing), I'd by much happier.

-chris

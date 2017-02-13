Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:35062 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751604AbdBMM46 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 07:56:58 -0500
Received: by mail-it0-f66.google.com with SMTP id 203so13291661ith.2
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 04:56:58 -0800 (PST)
Subject: Re: Help understanding autodefrag details
To: Peter Zaitsev <pz@percona.com>, linux-btrfs@vger.kernel.org
References: <CA+RUij0XsPsnCMTj4esnpJpmP9D+HCD6uD+r-pUH=eYPwuowrA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <76c3da9f-92f5-6ceb-26ed-70044a48cd00@gmail.com>
Date: Mon, 13 Feb 2017 07:56:53 -0500
MIME-Version: 1.0
In-Reply-To: <CA+RUij0XsPsnCMTj4esnpJpmP9D+HCD6uD+r-pUH=eYPwuowrA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-10 09:21, Peter Zaitsev wrote:
> Hi,
>
> As I have been reading btrfs whitepaper  it speaks about autodefrag in very
> generic terms - once random write in the file is detected it is put in the
> queue to be defragmented.   Yet I could not find any specifics about this
> process described anywhere.
>
> My use case is databases and as such large files (100GB+)    so my
> questions are
>
> - is my understanding what defrag queue is based on files not parts of
> files which got fragmented correct ?
Autodefrag is location based within the file, not for the whole file.  I 
forget the exact size of the area around the write it will try to 
defrag, and the maximum size the write can be to trigger it, but the 
selection amounts to the following:
1. Is this write not likely to be followed by a write to the next 
logical address in the file? (I'm not certain exactly what heuristic is 
used to determine this).
2. Is this write small enough to likely cause fragmentation?  (This one 
is a simple threshold test, but I forget the threshold).
3. If both 1 and 2 are true, schedule the area containing the write to 
be defragmented.
>
> - Is single random write is enough to schedule file for defrag or is there
> some more elaborate math to consider file fragmented and needing
> optimization  ?
I'm not sure.  It depends on whether or not the random write detection 
heuristic that is used has some handling for the first few writes, or 
needs some data from their position to determine the 'randomness' of 
future writes.
>
> - Is this queue FIFO or is it priority queue where files in more need of
> fragmentation jump in front (or is there some other mechanics ?
I think it's a FIFO queue, but there may be multiple threads servicing 
it, and I think it's smart enough to merge areas that overlap into a 
single operation.
>
> - Will file to be attempted to be defragmented completely or does defrag
> focuses on the most fragmented areas of the file first ?
AFAIK, autodefrag only defrags the region around where the write happened.
>
> - Is there any way to view this defrag queue ?
Not that I know of, but in most cases it should be mostly empty, since 
the areas being handled are usually small enough that items get 
processed pretty quick.
>
> - How are resources allocated to background autodefrag vs resources serving
> foreground user load are controlled
AFAIK, there is no way to manually control this.  It would be kind of 
nice though if autodefrag ran as it's own thread.
>
> - What are space requirements for defrag ? is it required for the space to
> be available for complete file copy or is it not required ?
Pretty minimal space requirements.  Even regular defrag technically 
doesn't need enough space for the whole file.  Both work with whatever 
amount of space they have, but you obviously get better results with 
more free space.
>
> - Can defrag handle file which is being constantly written to or is it
> based on the concept what file should be idle for some time and when it is
> going to be defragmented
In my experience, it handles files seeing constant writes just fine, 
even if you're saturating the disk bandwidth (it will just reduce your 
effective bandwidth a small amount).

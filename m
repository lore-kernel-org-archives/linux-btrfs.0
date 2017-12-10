Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:48964 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751452AbdLJL1k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Dec 2017 06:27:40 -0500
Date: Sun, 10 Dec 2017 12:27:39 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: exclusive subvolume space missing
Message-ID: <20171210112738.GA24090@polanet.pl>
References: <20171201161555.GA11892@polanet.pl>
 <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
 <20171202012324.GB20205@polanet.pl>
 <0d3cd6f5-04ad-b080-6e62-7f25824860f1@gmx.com>
 <20171202022153.GA7727@polanet.pl>
 <af4ba078-8dc9-3f5d-b28c-7d72e0390294@gmx.com>
 <20171202093301.GA28256@polanet.pl>
 <65f1545c-7fc5-ee26-ed6b-cf1ed6e4f226@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <65f1545c-7fc5-ee26-ed6b-cf1ed6e4f226@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 04, 2017 at 08:34:28 +0800, Qu Wenruo wrote:

>> 1. is there any switch resulting in 'defrag only exclusive data'?
> 
> IIRC, no.

I have found a directory - pam_abl databases, which occupy 10 MB (yes,
TEN MEGAbytes) and released ...8.7 GB (almost NINE GIGAbytes) after
defrag. After defragging files were not snapshotted again and I've lost
3.6 GB again, so I got this fully reproducible.
There are 7 files, one of which is 99% of the space (10 MB). None of
them has nocow set, so they're riding all-btrfs.

I could debug something before I'll clean this up, is there anything you
want to me to check/know about the files?

The fragmentation impact is HUGE here, 1000-ratio is almost a DoS
condition which could be triggered by malicious user during a few hours
or faster - I've lost 3.6 GB during the night with reasonably small
amount of writes, I guess it might be possible to trash entire
filesystem within 10 minutes if doing this on purpose.

>> 3. I guess there aren't, so how could I accomplish my target, i.e.
>>    reclaiming space that was lost due to fragmentation, without breaking
>>    spanshoted CoW where it would be not only pointless, but actually harmful?
> 
> What about using old kernel, like v4.13?

Unfortunately (I guess you had 3.13 on mind), I need the new ones and
will be pushing towards 4.14.

>> 4. How can I prevent this from happening again? All the files, that are
>>    written constantly (stats collector here, PostgreSQL database and
>>    logs on other machines), are marked with nocow (+C); maybe some new
>>    attribute to mark file as autodefrag? +t?
> 
> Unfortunately, nocow only works if there is no other subvolume/inode
> referring to it.

This shouldn't be my case anymore after defrag (==breaking links).
I guess no easy way to check refcounts of the blocks?

> But in my understanding, btrfs is not suitable for such conflicting
> situation, where you want to have snapshots of frequent partial updates.
> 
> IIRC, btrfs is better for use case where either update is less frequent,
> or update is replacing the whole file, not just part of it.
> 
> So btrfs is good for root filesystem like /etc /usr (and /bin /lib which
> is pointing to /usr/bin and /usr/lib) , but not for /var or /run.

That is something coherent with my conclusions after 2 years on btrfs,
however I didn't expect a single file to eat 1000 times more space than it
should...


I wonder how many other filesystems were trashed like this - I'm short
of ~10 GB on other system, many other users might be affected by that
(telling the Internet stories about btrfs running out of space).

It is not a problem that I need to defrag a file, the problem is I don't know:
1. whether I need to defrag,
2. *what* should I defrag
nor have a tool that would defrag smart - only the exclusive data or, in
general, the block that are worth defragging if space released from
extents is greater than space lost on inter-snapshot duplication.

I can't just defrag entire filesystem since it breaks links with snapshots.
This change was a real deal-breaker here...

Any way to fed the deduplication code with snapshots maybe? There are
directories and files in the same layout, this could be fast-tracked to
check and deduplicate.

-- 
Tomasz Pala <gotar@pld-linux.org>

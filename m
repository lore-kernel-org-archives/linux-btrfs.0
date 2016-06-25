Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:33964 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbcFYRZG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jun 2016 13:25:06 -0400
Received: by mail-oi0-f44.google.com with SMTP id s66so153776400oif.1
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jun 2016 10:25:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 25 Jun 2016 11:25:05 -0600
Message-ID: <CAJCQCtTXJhgKsmQGUXrppntYj8u6vk3jzP9Q4UMBomJ255QTQw@mail.gmail.com>
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
To: kreijack@inwind.it
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 25, 2016 at 6:21 AM, Goffredo Baroncelli <kreijack@inwind.it> wrote:

> 5) I check the disks at the offsets above, to verify that the data/parity is correct
>
> However I found that:
> 1) if I corrupt the parity disk (/dev/loop2), scrub don't find any corruption, but recomputed the parity (always correctly);

This is mostly good news, that it is fixing bad parity during scrub.
What's not clear due to the lack of any message is if the scrub is
always writing out new parity, or only writes it if there's a
mismatch.


> 2) when I corrupted the other disks (/dev/loop[01]) btrfs was able to find the corruption. But I found two main behaviors:
>
> 2.a) the kernel repaired the damage, but compute the wrong parity. Where it was the parity, the kernel copied the data of the second disk on the parity disk

Wow. So it sees the data strip corruption, uses good parity on disk to
fix it, writes the fix to disk, recomputes parity for some reason but
does it wrongly, and then overwrites good parity with bad parity?
That's fucked. So in other words, if there are any errors fixed up
during a scrub, you should do a 2nd scrub. The first scrub should make
sure data is correct, and the 2nd scrub should make sure the bug is
papered over by computing correct parity and replacing the bad parity.

I wonder if the same problem happens with balance or if this is just a
bug in scrub code?


> but these seem to be UNrelated to the kernel behavior 2.a) or 2.b)
>
> Another strangeness is that SCRUB sometime reports
>  ERROR: there are uncorrectable errors
> and sometime reports
>  WARNING: errors detected during scrubbing, corrected
>
> but also these seems UNrelated to the behavior 2.a) or 2.b) or msg1 or msg2

I've seen this also, errors in user space but no kernel messages.


-- 
Chris Murphy

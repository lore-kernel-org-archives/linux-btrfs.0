Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:37209 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab3LPXW4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 18:22:56 -0500
Received: by mail-lb0-f181.google.com with SMTP id q8so1131707lbi.40
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 15:22:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$138cb$448d68e$2d9dcb10$fc6a898a@cox.net>
References: <CAAeznTpG6A7ygKg1AUx_pAMs_SNwG4a4C5gHPeT+HcKRsD+TWA@mail.gmail.com>
	<20131215202456.GA11281@carfax.org.uk>
	<CAAeznTryb7kyuvEyBFniv-UtGCQwdNtZMhpxm=-2MtKZSOj9Tw@mail.gmail.com>
	<pan$138cb$448d68e$2d9dcb10$fc6a898a@cox.net>
Date: Mon, 16 Dec 2013 23:22:54 +0000
Message-ID: <CAAeznTrY21CTSsXf=jXVRneCcntqAkd+QiToNq3=0nT6O_e=Sw@mail.gmail.com>
Subject: Re: btrfs balance on single device
From: Leonidas Spyropoulos <artafinde@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 15, 2013 at 11:28 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Leonidas Spyropoulos posted on Sun, 15 Dec 2013 20:28:05 +0000 as
> excerpted:
>
>> Oh, so the df report from btrfs doesn't show the total as 'free'! But it
>> means how much space the filesystem allocated so far.
>
> Yes.
>
> Btrfs allocates in chunks, 256 MiB at a time for metadata (but on a
> single device, metadata chunks are DUP by default, so two are created at
> once, thus half a gig), 1 GiB at at a time for data (single device
> values, when there's plenty of unallocated space left in ordered to do
> so).  As these chunks are filled up new ones are allocated as necessary
> (assuming there's enough unallocated space left to do so).
>
> But normal usage including deleting old files and rewriting parts of
> existing files (to new locations due to btrfs' copy-on-write/COW
> semantics) will often leave several partially filled chunks around, and a
> balance rewrites chunks, consolidating into fewer new chunks when
> possible as it does so.
>
> That's what the btrfs fi df reports showed, many partially filled chunks
> before the balance, fewer but full chunks afterward, with the freed chunk
> space returned to the unallocated pool.
>
> While btrfs fi df could report unallocated space as well, given the
> possibility of it being allocated differently (DUP vs SINGLE, and on
> multi-device filesystems, the various raid modes), it can't reliably
> predict how that unallocated space will be used and thus how much
> /effective/ free space you have.
>
> But btrfs fi show gives the total filesystem size, as well as the total
> allocated.  So between df and show, plus a little math if necessary, you
> get a better picture.

But on the time that someone invokes the "btrfs fi df" command all the
informations are available on the underlying driver to determine the
type of allocation (DUP or SINGLE) and if the volume is single or multi
device. So is there a reason not to do the maths for the user and
present her/him with the correct information, saving her/his braincells
from maths? :)

I assume there's performance degragation from having all the chunks
allocated in a volume. Is there a recomendation on how often once should
run the balance operation? If on the other hand no performance is
decreased from having all the chunks allocated why not allocate them on
the start (creation of filesystem / mount - not sure which is
appropriate).

>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Leonidas
-- 
Caution: breathing may be hazardous to your health.

#include <stdio.h>
int main(){printf("%s","\x4c\x65\x6f\x6e\x69\x64\x61\x73");}

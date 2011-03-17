From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: How to implement raid1 repair
Date: Thu, 17 Mar 2011 18:37:54 +0100
Message-ID: <4D8246F2.8080104@jan-o-sch.net>
References: <4D821ED3.5050605@jan-o-sch.net> <AANLkTi=ckrr4BNSPxkMCveLAY7NyQ6SF6OzYHMnxC-rD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=ckrr4BNSPxkMCveLAY7NyQ6SF6OzYHMnxC-rD@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/17/2011 06:09 PM, Andrey Kuzmin wrote:
> On Thu, Mar 17, 2011 at 5:46 PM, Jan Schmidt <list.btrfs@jan-o-sch.net
> <mailto:list.btrfs@jan-o-sch.net>> wrote:
>     - Is it acceptable to retry reading a block immediately after the disk
>     said it won't work? Or in case of a successful read followed by a
>     checksum error? (Which is already being done right now in btrfs.)
> 
> 
> These are two pretty different cases. When disk firmware fails read, it
> means it has retried number of times but gave up (suggesting media
> error), so an upper layer retry would hardly make sense. Checksum error
> catches on-disk EDC fault, so retry is on the contrary quite reasonable.

Agreed.

>     - Is it acceptable to always write both mirrors if one is found to be
>     bad (also consider ssds)?
> 
> 
> Writing on read path bypassing file-system transaction mechanism doesn't
> seem a good idea to me. Just imaging loosing power while overwriting
> last good copy.

Okay, sounds reasonable to me. Let's say we're bypassing transaction
mechanism in the same rude manner, but only write the bad mirror. Does
that seem reasonable?

Thanks,
Jan

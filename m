Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.lqfe.com ([72.14.186.34]:34027 "EHLO mail.lqfe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbbEHVtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 May 2015 17:49:22 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Subject: Re: Kernel Dump scanning directory
From: Anthony Plack <anthony@plack.net>
In-Reply-To: <20150508211850.GN18480@carfax.org.uk>
Date: Fri, 8 May 2015 16:49:19 -0500
Cc: linux-btrfs@vger.kernel.org
Message-Id: <A54EAF29-BF4C-4CCA-BFBF-FEDFF2A01C73@plack.net>
References: <C42E48E9-4DA9-442D-8FAC-B1982EA5DF4B@plack.net> <4B045A3B-60E2-4151-86E7-029E79585886@plack.net> <60DA4BA3-C4FE-4A61-9D5C-399122FA2B96@plack.net> <EAC2F414-3D41-4458-9AF4-8533B1925C96@plack.net> <20150508211850.GN18480@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On May 8, 2015, at 4:18 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> On Fri, May 08, 2015 at 11:44:39AM -0500, Anthony Plack wrote:
>> I am close to zeroing the log at this point.  It is sad that we cannot fix the transaction log instead of just flushing it.
> 
>   That's not likely to make any difference here. If the FS mounts OK
> with -o ro, then zeroing the log might be useful. Otherwise, it won't
> e (a read-only mount won't replay the log; if it mounts without
> replaying the log, the problem is in the log, and it should be
> dropped; if not, then the problem is nothing to do with the log).

The FS mounts okay no matter what, it is trying to read the inodes where it crashes.  Thanks for the advise.

>   Dropping the log is *not* a panacea to all btrfs problems. It's
> there for a very limited class of issues, which rarely show up these
> days. I wish there were some way of editing the internet(*) to remove the
> idea that btrfs-zero-log will magically fix everything. It won't.

Good to know.

> (*) https://www.xkcd.com/386/ is probably appropriate here.
> 
>> Once again btrfsck --repair /dev/sdm ended with
>> 
>> parent transid verify failed on 94238015488 wanted 150690 found 150691
>> Ignoring transid failure
>> 
>> no attempt to actually repair the volume.  No indication from the tools why.
> 
>   A transid failure means that the superblock has been written out to
> disk *before* a part of the metadata that forms that transaction, and
> then the machine has crashed in some way that prevented the
> late-arriving metadata from hitting the disk. There are two ways that
> this can happen: it's a bug in the kernel, or the hardware lies about
> having written data. Both are possible, but the former is more likely.

Also good to know.  I agree to the bug in the kernel.  I think you just hit on the issue here.  Since this COW, we should be able to assume that the superblock is then still "empty."  Or do I misunderstand?

> 
>   Once this failure has happened, the FS is corrupt in a way that's
> hard to repair reliably. I did raise this question with Chris a while
> ago, and my understanding from the conversation was that he didn't
> think that it was possible to fix transid failures in btrfsck.

I guess I don't understand how that could be designed that way.

>   Once again: zeroing the log won't help. It doesn't fix everything.
> In fact, it rarely fixes anything.

>   The reason there's no documentation on fixing transid failures is
> because there's no good fix for them.

Then what is the point of the transactions?  Why do we care about transid mismatch?  Why keep something, that if it fails, breaks the whole thing?

Thanks for the thoughts.
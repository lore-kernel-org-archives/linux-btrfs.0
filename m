Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53756 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbbC2Ln0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Mar 2015 07:43:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YcBcf-00018B-4b
	for linux-btrfs@vger.kernel.org; Sun, 29 Mar 2015 13:43:21 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2015 13:43:21 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2015 13:43:21 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs dedup - available or experimental? Or yet to be?
Date: Sun, 29 Mar 2015 13:43:08 +0200
Message-ID: <d35lub-tec.ln1@hurikhan77.spdns.de>
References: <meq6hm$lbh$1@ger.gmane.org> <20150323232212.GL31762@carfax.org.uk> <CAGfcS_=6iHH+4T6CH8ag6MSf2N5n37pE6USSOjDTv=BMmFHQaw@mail.gmail.com> <mf2701$d5k$1@ger.gmane.org> <CAGfcS_k=__EfJssYt9Ra77uAtW6PfqV1fqAX03VfJiPi_T5TBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rich Freeman <r-btrfs@thefreemanclan.net> schrieb:

> On Thu, Mar 26, 2015 at 8:07 PM, Martin <m_btrfs@ml1.co.uk> wrote:
>>
>> Anyone with any comments on how well duperemove performs for TB-sized
>> volumes?
> 
> Took many hours but less than a day for a few TB - I'm not sure
> whether it is smart enough to take less time on subsequent scans like
> bedup.
> 
>>
>> Does it work across subvolumes? (Presumably not...)
> 
> As far as I can tell, yes.  Unless you pass a command-line option it
> crosses filesystem boundaries and even scans non-btrfs filesystems
> (like /proc, /dev, etc).  Obviously you'll want to avoid that since it
> only wastes time and I can just imagine it trying to hash kcore and
> such.
> 
> Other than being less-than-ideal intelligence-wise, it seemed
> effective.  I can live with that in an early release like this.

This is mainly in there to support deduping across different subvolumes 
within the same device pool. So I think the idea was neither less-than-
ideal, nor unintelligent, and it has nothing to do with performance.

But your warning is still valid: One should take care not to "dedupe" 
special filesystems (but that is the same with every other tool out there, 
like rsync, cp, essentially everything that supports recursion), nor is it 
very effective for the deduplication process to cross a boundary to a non-
btrfs device - for one or more exceptions: You may want duperemove to write 
hashes for a non-btrfs device and use the result for other purposes outside 
of duperemoves scope, or you are nesting btrfs into non-btrfs into btrfs 
mounts, or...

Concluding that: duperemove should probably not try to become smart about 
filesystem boundaries. It should either cross them or not as it is now - the 
option is left to the user (as is the task to supply proper cmdline 
arguments with that).

With the planned performance improvements, I'm guessing the best way will 
become mounting the root subvolume (subvolid 0) and letting duperemove work 
on that as a whole - including crossing all fs boundaries.

-- 
Replies to list only preferred.


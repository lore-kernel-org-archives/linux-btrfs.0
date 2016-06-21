Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:59530 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbcFUPjc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 11:39:32 -0400
Subject: Re: Is "btrfs balance start" truly asynchronous?
To: Graham Cobb <g.btrfs@cobb.uk.net>, linux-btrfs@vger.kernel.org
References: <f68639e5a41343c04fa4d76f3fb14370@www.centurion.link>
 <pan$7df97$9174e96e$7848d28b$295d4358@cox.net>
 <bc9cdbdf-060b-e903-0c74-c2b6f1f92077@gmail.com>
 <20160621113339.GA3325@carfax.org.uk>
 <176a9733-ade2-d3a6-a9aa-1476d6afb3e1@gmail.com>
 <57693E72.1090706@cobb.uk.net>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <576944B0.6030606@bouton.name>
Date: Tue, 21 Jun 2016 15:44:16 +0200
MIME-Version: 1.0
In-Reply-To: <57693E72.1090706@cobb.uk.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 21/06/2016 15:17, Graham Cobb a écrit :
> On 21/06/16 12:51, Austin S. Hemmelgarn wrote:
>> The scrub design works, but the whole state file thing has some rather
>> irritating side effects and other implications, and developed out of
>> requirements that aren't present for balance (it might be nice to check
>> how many chunks actually got balanced after the fact, but it's not
>> absolutely necessary).
> Actually, that would be **really** useful.  I have been experimenting
> with cancelling balances after a certain time (as part of my
> "balance-slowly" script).  I have got it working, just using bash
> scripting, but it means my script does not know whether any work has
> actually been done by the balance run which was cancelled (if no work
> was done, but it timed out anyway, there is probably no point trying
> again with the same timeout later!).

I have the exact same use case.

We trigger balances when we detect that the free space is mostly
allocated but unused to prevent possible ENOSPC events. A balance on
busy disks can slow other I/Os so we try to limit them in time (in our
use case 15 to 30 min max is mostly OK).
Trying to emulate this by using [d|v]range was a possibility too but I
thought it could be hard to get right. We actually inspect the allocated
space before and after to report the difference but we don't know if
this difference is caused by the aborted balance or other activity (we
have to read the kernel logs to find out).

Lionel

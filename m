Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:53552 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaL0QBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 11:01:16 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Robert White <rwhite@pobox.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Sat, 27 Dec 2014 17:01:14 +0100
Message-ID: <1694920.QVWA5EcL6C@merkaba>
In-Reply-To: <549ECCD8.6090307@pobox.com>
References: <3738341.y7uRQFcLJH@merkaba> <34633403.WlleJmkifE@merkaba> <549ECCD8.6090307@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 27. Dezember 2014, 07:14:32 schrieb Robert White:
> But yes, if you open a file and scribble all over it when your disk is 
> full to within the same order of magnitude as the size of the file you 
> are scribbling on, you will get into a condition where the _application_ 
> will aggressively retry the IO. Particularly if that application is a 
> "test program" or a virtual machine doing asynchronous IO.
> 
> That's what those sorts of systems do when they crash against a limit in 
> the underlying system.
> 
> So yea... out of space plus agressive writer equals spinning CPU
> 
> Before you can assign blame you need to strace your application to see 
> what call its making over and over again to see if its just being stupid.

Robert, I am pretty sure that fio does not retry the I/O. If the I/O returns
an error it exists immediately.

I don´t think BTRFS fails an I/O – there is nothing of that in kern.log or
dmesg. But it just needs a very long time for it.

And yet, with BTRFS *is* *full* testcase I still can´t reproduce the <300
IOPS case. I consistently get about 4800 IOPS which is just about okay IMHO.

fio just does random I/O. Aggressively, yes. But it would stop on the *first*
*failed* I/O request. I am pretty sure of that.

fio is flexible I/O tester. It has been written mostly by Jens Axboe. Jens
is the block maintainer of the Linux kernel. So I kindly ask that
before you assume I use crap tools, you have a look at it.

>From how you write I get the impression that you think everyone else
beside you is just silly and dumb. Please stop this assumption. I may not
always get terms right, and I may make a mistake as with the wrong df
figure. But I also highly dislike to feel treated like someone who doesn´t
know a thing.

I made my case.

I tried to reproduce it in a test case.

Now I suggest we wait till someone had an actual log at the sysrq-t triggers
of the 25 MiB kern.log I provided in the bug report.

I will now wait for BTRFS developers to comment on this.

I think Chris and Josef and other BTRFS developers actually know what fio
is, so… either they are interested in that <300 IOPS case I cannot yet
reproduce with a fresh filesystem or not.


Even when it is as almost full as it can get and the fio *barely* completes
without a "no space left on device" error, I still get those 4800 IOPS.
I tested it and took the first run where it actually completed again after
deleting partially copies /usr/bin directory from the test filesystem.

As I have shown it in my test case (see my other mail with altered subject
line)

So for at least a *small* full filesystem, the filesystem full or BTRFS has
to search for free space aggressively case *does not* explain what I see
with my /home. So either I need a fuller filesystem for the test case,
maybe one which carries a million of files or more, or one that at least
has more chunks to allocate from, or there is more to it and there is
something with my /home that makes it even worse.

So it isn´t just the filesystem full case, and the all free space allocated
for chunks condition also does not suffice as my test case shows (where
BTRFS just won´t allocate another data chunk it seems).

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

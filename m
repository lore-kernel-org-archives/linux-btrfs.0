Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56853 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaL1LFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Dec 2014 06:05:47 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Robert White <rwhite@pobox.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Sun, 28 Dec 2014 12:05:44 +0100
Message-ID: <1897314.R0rqgEAzOq@merkaba>
In-Reply-To: <549F4975.7060009@pobox.com>
References: <3738341.y7uRQFcLJH@merkaba> <20141227162642.GK25267@carfax.org.uk> <549F4975.7060009@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 27. Dezember 2014, 16:06:13 schrieb Robert White:
> >
> >> I also don't know what kind of tool you are using, but it might be
> >> repeatedly trying and failing to fallocate the file as a single
> >> extent or something equally dumb.
> >
> >     Userspace doesn't as far as I know, get to make that decision. I've
> > just read the fallocate(2) man page, and it says nothing at all about
> > the contiguity of the extent(s) storage allocated by the call.
> 
> Yep, my bad. But as soon as I saw that "fio" was starting two threads, 
> one doing random read/write and another doing sequential read/write, 
> both on the same file, it set off my "not just creating a file" mindset. 
> Given the delayed write into/through the cache normally done by casual 
> file io, It seemed likely that fio would be doing something more 
> aggressive (like using O_DIRECT or repeated fdatasync() which could get 
> very tit-for-tat).

Robert, please get to know about fio or *ask* before jumping to conclusions.

I used this:

[global]
bs=4k
#ioengine=libaio
#iodepth=4
size=4g
#direct=1
runtime=120
filename=ssd.test.file

#[seq-write]
#rw=write
#stonewall

[rand-write]
rw=randwrite
stonewall


At the first test I still tested seq-write, but do you note the "stonewall"
param? It *separates* both jobs from one another. I.e. fio may be starting
two threads as it I think prepares all threads in advance, yet it did
execute only *one* at a time.

>From the manpage of fio:

       stonewall , wait_for_previous
              Wait  for  preceding  jobs  in the job file to exit before
              starting this one.  stonewall implies new_group.

(that said the first stonewall isn´t even needed, but I removed the read
jobs from the ssd-test.fio example fio I used for this job and I didn´t
remember to remove the statement)


Thank you a lot for your input. I learned some from it. For example that
the trees for the data handling are in the metadata section. And now
I am very clear the btrfs fi df does not display any trees but the chunk
reservation and usage. I think I knew this before, but I thought somehow
that was combined with the tree, but it isn´t, at least not in place, but
the trees are stored in the metadata chunks. I´d still not call these
extents tough, cause thats a file-based thing to all I know.

I skip theoretizing about algorithms here. I prefer to let measurements
speak and try to understand these. Best approach to understand the ones
I made, I think, is what Hugo suggested: A developer looks at the sysrq-t
outputs. So I personally won´t speculate any further about given or not
given algorithmic limitations of BTRFS.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

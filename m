From: Avi Kivity <avi@redhat.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 15:16:32 +0200
Message-ID: <48FF27B0.4020000@redhat.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	<87vdvmdu36.fsf@basil.nowhere.org>	<20081021162249.30a25bcb.skraw@ithnet.com>	<48FDF67C.6080205@hp.com> <20081022133615.68b66b0e.skraw@ithnet.com> <48FF1976.1050202@redhat.com> <48FF24A4.4040108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Stephan von Krawczynski <skraw@ithnet.com>,
	jim owens <jowens@hp.com>, linux-btrfs@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF24A4.4040108@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ric Wheeler wrote:
> Scrubbing is key for many scenarios since errors can "grow" even in 
> places where previous IO has been completed without flagging an error.
>
> Some neat tricks are:
>
>    (1) use block level scrubbing to detect any media errors. If you 
> can map that sector level error into a file system object (meta data, 
> file data or unallocated space), tools can recover (fsck, get another 
> copy of the file or just ignore it!). There is a special command 
> called "READ_VERIFY" that can be used to validate the sectors without 
> actually moving data from the target to the host, so you can scrub 
> without consuming page cache, etc.
>

This has the disadvantage of not catching errors that were introduced 
while writing; the very errors that btrfs checksums can catch.

>    (2) sign and validate the object at the file level, say by 
> validating a digital signature. This can catch high level errors (say 
> the app messed up).

Btrfs extent-level checksums can be used for this.  This is just below 
the application level, but good enough IMO.

> Note that this scrubbing needs to be carefully tuned to not interfere 
> with the foreground workload, using something like IO nice or the 
> other IO controllers being kicked about might help :-)

Right.  Further, reading the disk by logical block order will help 
reduce seeks.  Btrfs's back references, if cached properly, will help 
with this as well.

-- 
error compiling committee.c: too many arguments to function


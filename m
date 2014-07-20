Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lb1.pop2.wanet.net ([65.244.248.2]:45413 "EHLO
	serv004.pop2.wanet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751401AbaGTRZD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 13:25:03 -0400
Message-ID: <9781519da9ccf1c860a49d3b7954d00d.squirrel@webmail.wanet.net>
In-Reply-To: <20140720140044.GB7469@mother.pipebreaker.pl>
References: <loom.20140720T102642-239@post.gmane.org>
    <pan$67ea$f06610e9$914a341d$b38b0b32@cox.net>
    <20140720140044.GB7469@mother.pipebreaker.pl>
Date: Sun, 20 Jul 2014 10:15:43 -0700
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
From: ashford@whisperpc.com
To: "Tomasz Torcz" <tomek@pipebreaker.pl>
Cc: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz,

> On Sun, Jul 20, 2014 at 01:53:34PM +0000, Duncan wrote:
>> TM posted on Sun, 20 Jul 2014 08:45:51 +0000 as excerpted:
>>
>>> One week for a raid10 rebuild 4x3TB drives is a very long time.
>>> Any thoughts?
>>> Can you share any statistics from your RAID10 rebuilds?
>>
>> At a week, that's nearly 5 MiB per second, which isn't great, but isn't
>> entirely out of the realm of reason either, given all the processing
>> it's
>> doing.  A day would be 33.11+, reasonable thruput for a straight copy,
>> and a raid rebuild is rather more complex than a straight copy, so...
>
>   Uhm, sorry, but 5MBps is _entirely_ unreasonable.  It is
> order-of-magnitude
> unreasonable.  And "all the processing" shouldn't even show as a blip
> on modern CPUs.
>   This "speed" is undefendable.

Maybe and maybe not.  It's already been discussed that BTRFS serializes
its disk I/O, instead of performing it in parallel.  That can have a
significant impact on overall throughput.

In addition, depending on how BTRFS does a reconstruct, it's possible that
there's another problem.  Most low-level RAID implementations (MD driver
and RAID controller cards) reconstruct a segment at a time (or possibly
multiple segments), and reconstruct the entire disk, even the unused
portions.

ZFS is different, in that it reconstructs only the used sections.  This
behavior will read/write less to the disk, but it will have more random
I/O.  The random I/O can result in more seeks (depending on how busy the
system is), which could slow down the reconstruction, especially on an
idle system.  As ZFS was designed for high usage environments, where it's
likely that a seek would be needed to get the head back to the data being
reconstructed, the randomness of the reconstruct would have no significant
impact on a reconstruct.

The question implied above is which method of reconstruction BTRFS uses. 
Could someone please inform us?

As BTRFS is verifying the checksum on the read, and possibly generating a
new checksum on write, the CPU time used will be significantly greater
than for a "dumb" RAID-10 array.  If it's not a sequential segment
reconstruction, the CPU time needed would be greater still.  WRT CPU
performance, we should remember that TM's system is far from a speed
demon.

Finally, TM didn't mention anything about other I/O activity on the array,
which, regardless of the method of reconstruction, could have a
significant impact on the speed of a reconstruction.

There are a LOT of parameters here that could impact throughput.  Some are
designed in (the checksum computations), some are "temporary" (the single
I/O path) and some are end-user issues (slow CPU and other activity on the
array).  I'm sure that there are other parameters, possibly including soft
read errors on the other disks, that could be impacting the overall
throughput.

As all the information that could affect performance hasn’t been provided
yet, it is premature to make a blanket statement that the performance of a
reconstruction is "unreasonable".  For the circumstances, it's possible
that the performance is just fine.  We have not yet been provided with
enough data to verify this, one way or another.

Peter Ashford


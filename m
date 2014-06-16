Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1041 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932173AbaFPQG0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 12:06:26 -0400
Message-ID: <539F15DC.4010600@fb.com>
Date: Mon, 16 Jun 2014 09:05:48 -0700
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Lennart Poettering <lennart@poettering.net>,
        Russell Coker <russell@coker.com.au>
CC: <kreijack@inwind.it>, Duncan <1i5t5.duncan@cox.net>,
        <linux-btrfs@vger.kernel.org>, <systemd-devel@lists.freedesktop.org>
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost> <539BFF47.8060006@libero.it> <20140615221307.GE24386@tango.0pointer.de> <1709025.rRUgx5gMp1@xev> <20140616101448.GB18016@tango.0pointer.de>
In-Reply-To: <20140616101448.GB18016@tango.0pointer.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/16/2014 03:14 AM, Lennart Poettering wrote:
> On Mon, 16.06.14 10:17, Russell Coker (russell@coker.com.au) wrote:
>
>>> I am not really following though why this trips up btrfs though. I am
>>> not sure I understand why this breaks btrfs COW behaviour. I mean,
>>> fallocate() isn't necessarily supposed to write anything really, it's
>>> mostly about allocating disk space in advance. I would claim that
>>> journald's usage of it is very much within the entire reason why it
>>> exists...
>>
>> I don't believe that fallocate() makes any difference to fragmentation on
>> BTRFS.  Blocks will be allocated when writes occur so regardless of an
>> fallocate() call the usage pattern in systemd-journald will cause
>> fragmentation.
>
> journald's write pattern looks something like this: append something to
> the end, make sure it is written, then update a few offsets stored at
> the beginning of the file to point to the newly appended data. This is
> of course not easy to handle for COW file systems. But then again, it's
> probably not too different from access patterns of other database or
> database-like engines...

Was waiting for you to show up before I said anything since most systemd 
related emails always devolve into how evil you are rather than what is 
actually happening.

So you are doing all the right things from what I can tell, I'm just a 
little confused about when you guys run fsync.  From what I can tell 
it's only when you open the journal file and when you switch it to 
"offline."  I didn't look too much past this point so I don't know how 
often these things happen.  Are you taking an individual message, 
writing it, updating the head of the file and then fsync'ing?  Or are 
you getting a good bit of dirty log data and fsyncing occasionally?

What would cause btrfs problems is if you fallocate(), write a small 
chunk, fsync, write a small chunk again, fsync again etc.  Fallocate 
saves you the first write around, but if the next write is within the 
same block as the previous write we'll end up triggering cow and enter 
fragmented territory.  If this is what is what journald is doing then 
that would be good to know, if not I'd like to know what is happening 
since we shouldn't be fragmenting this badly.

Like I said what you guys are doing is fine, if btrfs falls on it's face 
then its not your fault.  I'd just like an exact idea of when you guys 
are fsync'ing so I can replicate in a smaller way.  Thanks,

Josef

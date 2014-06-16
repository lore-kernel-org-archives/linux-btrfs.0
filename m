Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39818 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaFPTwW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 15:52:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wwcx2-0002xJ-Li
	for linux-btrfs@vger.kernel.org; Mon, 16 Jun 2014 21:52:20 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 21:52:20 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 21:52:20 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
Date: Mon, 16 Jun 2014 20:52:07 +0100
Message-ID: <lnnht8$f3j$1@ger.gmane.org>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost> <539BFF47.8060006@libero.it> <20140615221307.GE24386@tango.0pointer.de> <1709025.rRUgx5gMp1@xev> <20140616101448.GB18016@tango.0pointer.de> <539F15DC.4010600@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <539F15DC.4010600@fb.com>
Cc: systemd-devel@lists.freedesktop.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16/06/14 17:05, Josef Bacik wrote:
> 
> On 06/16/2014 03:14 AM, Lennart Poettering wrote:
>> On Mon, 16.06.14 10:17, Russell Coker (russell@coker.com.au) wrote:
>>
>>>> I am not really following though why this trips up btrfs though. I am
>>>> not sure I understand why this breaks btrfs COW behaviour. I mean,

>>> I don't believe that fallocate() makes any difference to
>>> fragmentation on
>>> BTRFS.  Blocks will be allocated when writes occur so regardless of an
>>> fallocate() call the usage pattern in systemd-journald will cause
>>> fragmentation.
>>
>> journald's write pattern looks something like this: append something to
>> the end, make sure it is written, then update a few offsets stored at
>> the beginning of the file to point to the newly appended data. This is
>> of course not easy to handle for COW file systems. But then again, it's
>> probably not too different from access patterns of other database or
>> database-like engines...

Even though this appears to be a problem case for btrfs/COW, is there a
more favourable write/access sequence possible that is easily
implemented that is favourable for both ext4-like fs /and/ COW fs?

Database-like writing is known 'difficult' for filesystems: Can a data
log can be a simpler case?


> Was waiting for you to show up before I said anything since most systemd
> related emails always devolve into how evil you are rather than what is
> actually happening.

Ouch! Hope you two know each other!! :-P :-)


[...]
> since we shouldn't be fragmenting this badly.
> 
> Like I said what you guys are doing is fine, if btrfs falls on it's face
> then its not your fault.  I'd just like an exact idea of when you guys
> are fsync'ing so I can replicate in a smaller way.  Thanks,

Good if COW can be so resilient. I have about 2GBytes of data logging
files and I must defrag those as part of my backups to stop the system
fragmenting to a stop (I use "cp -a" to defrag the files to a new area
and restart the data software logger on that).


Random thoughts:

Would using a second small file just for the mmap-ed pointers help avoid
repeated rewriting of random offsets in the log file causing excessive
fragmentation?

Align the data writes to 16kByte or 64kByte boundaries/chunks?

Are mmap-ed files a similar problem to using a swap file and so should
the same "btrfs file swap" code be used for both?


Not looked over the code so all random guesses...

Regards,
Martin





Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-02v.sys.comcast.net ([69.252.207.34]:40180 "EHLO
	resqmta-ch2-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbaK2Qds (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 11:33:48 -0500
Message-ID: <5479F567.4020408@pobox.com>
Date: Sat, 29 Nov 2014 08:33:43 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS messes up snapshot LV with origin
References: <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>	<546B68F8.6080008@ubuntu.com>	<FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>	<546BA96D.4050805@ubuntu.com>	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>	<546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org>	<5470C92E.1070607@inwind.it> <20141123001927.GO17380@hungrycats.org>	<5474AF87.6090702@inwind.it> <20141125202948.GP17380@hungrycats.org>	<5474FBD9.5070709@inwind.it>	<pan$8a1fe$cae59052$c5e19c35$9858d5fc@cox.net> <54764F4E.80405@pobox.com>	<pan$7d8df$684921c0$5b1accb1$bf431820@cox.net>	<CAJCQCtSGT_CCYZ5WBo_xqw5xWgFbovoWca0-yBEk5WiR7PYQwg@mail.gmail.com>	<pan$40148$39c282ee$365818$9e1ebdba@cox.net> <547981BB.7030206@pobox.com> <pan$f2170$a5a6540f$18f67307$e9d84fab@cox.net>
In-Reply-To: <pan$f2170$a5a6540f$18f67307$e9d84fab@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/29/2014 01:41 AM, Duncan wrote:
> Robert White posted on Sat, 29 Nov 2014 00:20:11 -0800 as excerpted:
> l	Display a summary of partition types. GPT uses a GUID to
> 	identify partition types for particular OSes and purposes. For
> 	ease of data entry, gdisk compresses these into two-byte
> 	(four-digit hexadecimal) values that are related to their
> 		equivalent MBR codes.  Specifically, the MBR code is multiplied
> 	by hexadecimal 0x0100.

That EFI uses GUIDs is one thing. That the standard allows these to be 
selected based on type codes originally derived from ms-dos partition 
type codes ("compressed" is the wrong word) is something else. If they 
were "compressed" then it would be a relationship that could represent 
any GUID at all. It's marginally hashed, in that there is a table 
lookup, but its not properly a hashed as the "hash function" is 
undefined for virtually all possible input values.


The other partition GUID is acutally more interesting.


> So as I said, gdisk uses a 4-hexit short code based on the legacy MBR
> type-code as an easy entry and display form referencing the longer and
> much less human readable GUIDs, just like I said, and such usage is gdisk
> specific, just like I said I thought it was.

Which is not what you said. None of the above was mentioned in the email 
to which I responded.

What you actually said ::

[QUOTE]
Since I can't/won't run pretty much anything proprietary, there's little 
chance of it being taken as anything but Linux, here.  (Tho I actually 
use (c)gdisk for partitioning here and it appears to use a different 
GUID. (0700 in its short form which AFAIK is gdisk specific, for MS 
basic data, while it uses 8300 for general Linux filesystems.  I could 
look up the long form GUIDs, but meh...)
[/QUOTE]

None of which is "gdisk specific", and all of which is based on EFI and 
the GUID partition table.

What I mistakenly attributed to you and was key to my initial response 
was your extension of Chris Murphy:
 >>> Chris Murphy posted on Fri, 28 Nov 2014 00:10:40 -0700 as excerpted:
 >>>> A very good example of WTF reusage of a UUID that irks me to no end is
 >>>> GNU parted devs decided to recycle the Microsoft Windows Basic Data
 >>>> partition type GUID for Linux partitions. It's like watching 
someone get
 >>>> run over by a zamboni with 50 feet of advance notice...

[So my bad there on the quoting...]

The irking there being dumb because the universally used "type GUID" has 
nothing to do with the second GUID that universally identifies the 
partition regardless of type.

But here is the thing... for all the screed about open and closed 
source... (and I am an open source guy myself) The actual EFI standard 
dictates these partition numbers and whatnot so if you used the 
microsoft tools you'd get the same results.

http://en.wikipedia.org/wiki/GUID_Partition_Table#Partition_type_GUIDs

AND microsoft was one of several principle players in the EFI and its 
GUID partition subparts.

So his being "irked to no end" and your agreement and "that's why I used 
gdisk" response are both completely misplaced, and potentially 
misleading to others.

I just went a little off the rails while trying to explain. /D'oh.


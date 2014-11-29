Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:58859 "EHLO
	resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334AbaK2QvA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 11:51:00 -0500
Message-ID: <5479F971.3030607@pobox.com>
Date: Sat, 29 Nov 2014 08:50:57 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS messes up snapshot LV with origin
References: <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>	<546B68F8.6080008@ubuntu.com>	<FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>	<546BA96D.4050805@ubuntu.com>	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>	<546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org>	<5470C92E.1070607@inwind.it> <20141123001927.GO17380@hungrycats.org>	<5474AF87.6090702@inwind.it> <20141125202948.GP17380@hungrycats.org>	<5474FBD9.5070709@inwind.it>	<pan$8a1fe$cae59052$c5e19c35$9858d5fc@cox.net> <54764F4E.80405@pobox.com>	<pan$7d8df$684921c0$5b1accb1$bf431820@cox.net>	<CAJCQCtSGT_CCYZ5WBo_xqw5xWgFbovoWca0-yBEk5WiR7PYQwg@mail.gmail.com> <pan$40148$39c282ee$365818$9e1ebdba@cox.net> <547981BB.7030206@pobox.com>
In-Reply-To: <547981BB.7030206@pobox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To those reading along who don't already know. My explanation below is 
factually inadequate or wrong in various places...

The "type codes" as presented in the various EFI/GUID disk partitioning 
tools as 0700, 8200, 8300, EF02, and so on are never written to disk as 
such. They are short-hand values (chosen to be deliberately similar to 
the MS-DOS partitioning type codes of 07, 82, 83, etc) to select 
standardized GUIDs for the partition type field.

So there is the two-digit code from the ms-dos partitoning scheme, then 
there are the four-digit codes that let you select which type GUID will 
be written in an EFI partition scheme.

The question of "reuse" is still improper as the type codes were 
assigned by the EFI standard for specific use as type codes. The EFI 
tool used (gdisk, or windows disk partitioning tool, etc) is immaterial 
as the result codes are selected by standard.

I could have, and should have, been _way_ more clear, and/or less wrong. 8-)

http://en.wikipedia.org/wiki/GUID_Partition_Table#Partition_type_GUIDs


On 11/29/2014 12:20 AM, Robert White wrote:
> On 11/28/2014 11:29 PM, Duncan wrote:
>> Since I can't/won't run pretty much anything proprietary, there's little
>> chance of it being taken as anything but Linux, here.  (Tho I actually
>> use (c)gdisk for partitioning here and it appears to use a different
>> GUID.
>> (0700 in its short form which AFAIK is gdisk specific, for MS basic data,
>> while it uses 8300 for general Linux filesystems.  I could look up the
>> long form GUIDs, but meh...)
>
> Partition type codes (e.g. 0700, 8300, EF00, etc) have _nothing_ to do
> with UUIDs. They are type codes. They aren't "short form" of anything
> else at all. In fact 0700 is the _long_ _form_ of the original code of
> "7", but in big-endian order now that it went from one byte to two.
>
> Microsoft started using pre-assigned UUIDs as "classes", e.g. type codes
> they could cram into their various registry files. If you actually read
> the registry you'll find a lot of places where "rational word" is
> defined as {some_uuid_here} and then eslwere {some_uuid_here} has a
> bunch of data items attached to it.
>
> So gpartd didn;t "reuse" microsoft UUIDs.
>
> In some/many of the older formats there was a code for "operating system
> data" (which I think is what 7 was originally). Others came by and said
> "since we're going to put in a type code for "linux swap" (82) then lets
> put in a code for linux data as well (83), and all this before the whole
> byte expansion to turn these things from bytes into two-byte words.
>
> Once everybody else picked their own type codes for their data
> partitions, everybody just started calling "7" microsoft data. And linux
> doesn't care at all since it's noise since every partition just ends up
> as /dev/[sh]d? anyway.
>
> All this stuff has historical reasons. GNU/Linux attempts to be an
> egalitarian actor so it adapts to whatever you do.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


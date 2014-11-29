Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60955 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbaK2Jl2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 04:41:28 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XueWs-0004C2-AP
	for linux-btrfs@vger.kernel.org; Sat, 29 Nov 2014 10:41:26 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 10:41:26 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 10:41:26 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS messes up snapshot LV with origin
Date: Sat, 29 Nov 2014 09:41:16 +0000 (UTC)
Message-ID: <pan$f2170$a5a6540f$18f67307$e9d84fab@cox.net>
References: <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
	<546B68F8.6080008@ubuntu.com>
	<FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
	<546BA96D.4050805@ubuntu.com>
	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
	<546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org>
	<5470C92E.1070607@inwind.it> <20141123001927.GO17380@hungrycats.org>
	<5474AF87.6090702@inwind.it> <20141125202948.GP17380@hungrycats.org>
	<5474FBD9.5070709@inwind.it>
	<pan$8a1fe$cae59052$c5e19c35$9858d5fc@cox.net> <54764F4E.80405@pobox.com>
	<pan$7d8df$684921c0$5b1accb1$bf431820@cox.net>
	<CAJCQCtSGT_CCYZ5WBo_xqw5xWgFbovoWca0-yBEk5WiR7PYQwg@mail.gmail.com>
	<pan$40148$39c282ee$365818$9e1ebdba@cox.net> <547981BB.7030206@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Sat, 29 Nov 2014 00:20:11 -0800 as excerpted:

> On 11/28/2014 11:29 PM, Duncan wrote:
>> (Tho I actually use (c)gdisk for partitioning here and it appears to
>> use a different GUID. (0700 in its short form which AFAIK is gdisk
>> specific, for MS basic data, while it uses 8300 for general Linux
>> filesystems.  I could look up the long form GUIDs, but meh...)
> 
> Partition type codes (e.g. 0700, 8300, EF00, etc) have _nothing_ to do
> with UUIDs. They are type codes. They aren't "short form" of anything
> else at all. In fact 0700 is the _long_ _form_ of the original code of
> "7", but in big-endian order now that it went from one byte to two.

You obviously know where the short forms originated (MBR type codes), but 
you haven't the foggiest what you're talking about in relation to gdisk, 
where they're used as 4-hex-char entry shortcuts for the similar GPT/EFI 
GUIDs.  Now that's what I expected with the mention of a different 
partition editor, thus my mention that they were shortcuts for GUIDs, 
apparently gdisk specific, but in gdisk they certainly ARE shortcuts to 
the various GUIDs and you certainly do *NOT* know what you're talking 
about saying they are not even related.

>From the gdisk (8) manpage entry for the l/list action:

l	Display a summary of partition types. GPT uses a GUID to
	identify partition types for particular OSes and purposes. For
	ease of data entry, gdisk compresses these into two-byte
	(four-digit hexadecimal) values that are related to their 
		equivalent MBR codes.  Specifically, the MBR code is multiplied
	by hexadecimal 0x0100. For instance, the code for Linux swap
	space in MBR is 0x82, and it's 0x8200 in gdisk. A one-to-one
	correspondence is impossible, though. Most notably, the codes
	for all varieties of FAT and NTFS partition correspond to a
	single GPT code (entered as 0x0700 in sgdisk).  Some OSes use a
	single MBR code but employ many more codes in GPT. For these,
	gdisk adds code numbers sequentially, such as 0xa500 for a
	FreeBSD disklabel, 0xa501 for FreeBSD boot, 0xa502 for FreeBSD
	swap, and so on. Note that these two-byte codes are unique to
	gdisk.

See also the gdisk home page:

http://www.rodsbooks.com/gdisk/

In particular, see the gdisk walkthru here:

http://www.rodsbooks.com/gdisk/walkthrough.html

... and the gdisk manpage I quoted above here:

http://www.rodsbooks.com/gdisk/gdisk.html


So as I said, gdisk uses a 4-hexit short code based on the legacy MBR 
type-code as an easy entry and display form referencing the longer and 
much less human readable GUIDs, just like I said, and such usage is gdisk 
specific, just like I said I thought it was.

And you might have known the legacy MBR type-codes from which they were 
derived, but obviously you had no idea what I was talking about here, and 
despite my saying it was gdisk specific you decided to simply claim I 
didn't know what I was talking about without actually checking the 
situation, despite my telling you exactly what app I was referring to and 
that I thought those references were app-specific, giving you plenty of 
chance to actually look it up yourself if you decided to, or simply not 
argue that point if you weren't interested in checking out the app-
specific stuff.

=:^(

> Microsoft started using pre-assigned UUIDs as "classes", e.g. type codes
> they could cram into their various registry files. If you actually read
> the registry you'll find a lot of places where "rational word" is
> defined as {some_uuid_here} and then eslwere {some_uuid_here} has a
> bunch of data items attached to it.

FWIW I know about the MS registry stuff from actually doing MS-registry 
and API related programming (hobbiest/VB level but using the regular API 
not just the VB exposed stuff) back before the turn of the century.  I've 
not touched it in nearing a decade and a half now and my knowledge is 
consequently dated 9x vintage, but it obviously had the registry and I 
used to be /quite/ familiar with it, including of course the UUIDs.

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

This part I have no disagreement with...


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


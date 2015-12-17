Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43411 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbbLQCn4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 21:43:56 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a9OXp-00029V-Df
	for linux-btrfs@vger.kernel.org; Thu, 17 Dec 2015 03:43:53 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Dec 2015 03:43:53 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Dec 2015 03:43:53 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: attacking btrfs filesystems via UUID collisions?
Date: Thu, 17 Dec 2015 02:43:37 +0000 (UTC)
Message-ID: <pan$c8b37$59d24eb8$384ca522$74292a27@cox.net>
References: <20151204120529.37E47D5A28@emkei.cz>
	<20151204130758.GR8775@carfax.org.uk>
	<1449286104.18841.14.camel@scientia.net>
	<pan$7e229$ce87d3b$b8d75c44$337e15c7@cox.net>
	<1449366680.3183.37.camel@scientia.net> <56644785.4090702@gmx.com>
	<1449639588.7835.2.camel@scientia.net> <5668A1CB.1020007@anonym.com>
	<CAJCQCtQCoi52o2REWZGObq-19EpgCv+7QmKvP=Gvk1myVq-+_g@mail.gmail.com>
	<1449872498.31388.74.camel@fo>
	<CAJCQCtSXkXs0jQ=zaP6FJvRZS0yvz5CrjP8a06K0+htG5H8LTg@mail.gmail.com>
	<1450052868.30943.27.camel@scientia.net> <566EC2D7.3000101@gmail.com>
	<CAJCQCtTuETCh_n3dnhPbVBx6_0dcAmNgNWN_bpsTE8goH8byKg@mail.gmail.com>
	<56701B79.8030105@gmail.com> <1450267404.6259.10.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Wed, 16 Dec 2015 13:03:24 +0100 as
excerpted:

> Human readable lables are basically guaranteed to collide,

Heh, not here, tho one could argue that my labels aren't "human 
readable", I suppose.

grep LABEL= /etc/fstab | cut -f1
LABEL=bt0238gcn1+35l0
LABEL=bt0238gcn0+35l0
LABEL=bt0465gsg0+47f0
LABEL=rt0238gcnx+35l0
LABEL=rt0238gcnx+35l1
LABEL=rt0465gsg0+47f0
LABEL=hm0238gcnx+35l0
LABEL=pk0238gcnx+35l0
LABEL=nr0238gcnx+35l0
LABEL=hm0238gcnx+35l1
LABEL=pk0238gcnx+35l1
LABEL=nr0238gcnx+35l1
LABEL=hm0465gsg0+47f0
LABEL=pk0465gsg0+47f0
LABEL=nr0465gsg0+47f0
LABEL=lg0238gcnx+35l0
LABEL=lg0465gsg0+47f0
LABEL=mm0465gsg0+2550
LABEL=mm0465gsg0+2551
#LABEL=sw0465gsg0+47f0

The scheme was originally designed with reiserfs' 15-char limited labels 
in mind, so it's 15-char.  These days I use it for both fs labels and gpt 
partition names/labels, with the two generally matched except for the 
device sequential, which is x in the multi-device case.

* function:	2 chars	bt=boot, hm=home, etc

* device-id:	8	uniq-in-scope device id
** size: 	5	0238g=238 GiB
** brand:	2	sg=seagate, cn=corsair neutron, etc
** dev-seq:	1	can be more than one 465 GiB seagate

* target:	1	+=home workstation, . for the netbook, etc

* date:		3	date of original partition creation
** year:	1	last digit of year, gives decade scope
** month	1	1-9abc
** day		1	1-9a-v (2char would be nice here, but...)

* func-seq	1	0=working, backup-N

2+8+1+3+1=15 chars =:^)

So for example rt0238gcnx+35l0 is root, on 238 GiB Corsair Neutron (multi-
devices), targeted at the workstation, with the partitions originally 
setup on 2013, June (something, whatever l is), working copy.

(Hmm...  Only apropos to this thread due to the tangential btrfs angle, 
but that's two and a half years ago.  Which since that's when I first 
deployed btrfs permanently, I've been running btrfs for two and a half 
years now. ... =:^)

The function tells me at a glance what it's intended to be used for.

The target (which also functions as a visual separator) tells me at a 
glance where the device is intended to be used.

The func-seq tells me at a glance whether I'm dealing with the working 
copy or what level of backup, and taken together with the function and 
target, uniquely ID the partition/filesystem "software device".

The dev-id is uniq-in-scope, easily IDing size, brand, and number of 
"hardware device", and size is ridiculously scalable from bytes to PiB 
and beyond.  For multi-device btrfs, dev-seq is "x", while the individual 
device partitions composing it still have their sequence numbers in their 
gpt labels.

The date (along with size, of course) provides some idea of the age of 
the device, or at least the partitioning scheme on it, as well as 
providing more bits of "software device" and overall unique-id.

Both sequence numbers can easily and intuitively scale to 61 (1-9a-zA-Z) 
if needed, and less intuitively a bit higher if it's really necessary.  
Target would lose its separator status if it scaled too far, but 
certainly gives me as an individual /reasonable/ number of machines 
flexibility.

This scheme self-evidently and easily scales to a library well into the 
multi-hundreds if not thousands of physical devices, portable or 
permanently installed, partitioned up as needed.  I haven't yet found the 
need as my "device library" is small enough, but were I to need to, I 
could reasonably easily put together a database tracking where various 
files (and even various versions of those files) are located.  With the 
"software device" and "hardware device" IDed separately, I can easily 
substitute out or add/remove hardware devices from software devices, or 
the reverse, as necessary.

The biggest problem is the 15-char limit; I had to pack the fields rather 
tighter and more cryptically than I'd have liked, so it's not as easily 
human readable as I'd have liked.  And of course it'd need adapted for 
deployment scales on the level of facebook/google/nsa, where 60-some 
device-scaling in the sequence numbers, and the target scaling as well, 
is pitifully laughable, but it's certainly reasonable on an individual 
scale, and with a couple revisions for mdraid and btrfs (basically, md 
for brand when I was doing partitioned mdraid, and substituting x for 
individual sequence number for multi-device), the scheme has served me 
surprisingly well over the years since I came up with it, and should 
continue to do so, I suppose, until I no longer have the need (death, or 
near-vegetable in a nursing home or whatever).  Tho if HP's "the machine" 
were to ever take off in my lifetime, it could prove somewhat... 
challenging to the mental and nomenclature model, but that pretty much 
applies to the entire computer field, both hardware and software, as we 
know it, so I'm far from alone, there.

But, despite the debatable human-readability, it's a h*** of a lot more 
readable than UUIDs, and works very well indeed in LABEL= usage in fstab, 
being a h*** of a lot easier to work with there than UUIDs! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49612 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab2J1LQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 07:16:45 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org, kreijack@inwind.it
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
Date: Sun, 28 Oct 2012 12:16:43 +0100
Cc: cwillu <cwillu@cwillu.com>, Chris Murphy <lists@colorremedies.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Michael =?iso-8859-1?q?Kj=F6rling?= <michael@kjorling.se>
References: <50899151.1070503@inwind.it> <201210281133.10571.Martin@lichtvoll.de> <508D0FC5.1020404@inwind.it> (sfid-20121028_115841_603788_B8F3E1BA)
In-Reply-To: <508D0FC5.1020404@inwind.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210281216.43983.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 28. Oktober 2012 schrieb Goffredo Baroncelli:
> > What was your reasoning for not using options to btrfs filesystem df?
> > That  df doesn´t show more than "disk free" as well?
> 
> My feel is that a switch should change "a bit" a command. In this case
> there are very different outputs, for different purposes (how is used a
> disk ? where are the chunks ? how many free space I have ? ).

Hmm.

The question whether how these are all related to the question on how much 
space is free?

Are they related? Then a single command makes sense. Are they completely 
different outputs? Then separate commands make sense.


I think, before continuing to argue over the details of the output and 
options, it would be good to get the use cases clear.

My first and most important use case would be:

How much space is used and more importantly how much space is still free?

A further use case would be:

Is a some disk on my BTRFS RAID limiting the usable space by being too 
small in compared to other disks?

And then:

Is there a imbalance in disk allocation that prevents me from using all 
space and that I can have fixed by doing a balance operation?

Maybe also:

What would be a good way to extend the usable space in my BTRFS given the 
current disks, their sizes and the current allocation strategies? Could 
even be a simulation. btrfs filesystem df -a /dev/sdi1 and then it shows 
how usable size would change if /dev/sdi1 was added to the fs.

And then subvolume related questions like:

Which subvolumes are using up all this disk space?


Anything else?


With the use cases in mind we can work out what a good output would be by 
asking ourselves: Does the output(s) answer the questions from the use 
cases?


Given above use cases, I think its most important to get the summary view 
into btrfs filesystem df and then go from there for additional details 
provided by options or different commands.

Given that the summary view IMHO was quite uncontroversial I think it can 
go in already while we discuss the other stuff, can´t it?


IMHO it would then be good to also fix regular df to provide a free space 
like in the summary view. Maybe by being conservative and using the 
smallest estimation. But mabye its just me who never really understood why 
a 100 GB BTRFS RAID1 shows 200GB of free space and a 100 MB file on it 
occupies 200MB.

Currently the regular df output, while technically somewhat correct, IMHO 
is just of no good use for anyone using a BTRFS raid. Especially with 
applications that use df value to determine how much data to place on a 
volume like fscache or other caches. Hmmm, however these will work if 
using a percentage, cause that would still be correct, cause 180 GB of 200 
GB is still 90% like 90 GB of 100GB. But they would over-allocate if being 
told to leave 10 GB free or so.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:45374 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855Ab2JLJzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Oct 2012 05:55:04 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH][BTRFS-PROGS][V1] btrfs filesystem df
Date: Fri, 12 Oct 2012 11:55:02 +0200
Cc: Ilya Dryomov <idryomov@gmail.com>,
        Goffredo Baroncelli <kreijack@gmail.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
References: <1349264596-9383-1-git-send-email-kreijack@inwind.it> <20121003150117.GA1978@zambezi.lan> (sfid-20121003_220039_939865_34137DD2)
In-Reply-To: <20121003150117.GA1978@zambezi.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210121155.03108.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 3. Oktober 2012 schrieb Ilya Dryomov:
> > $ ./btrfs filesystem df /
> > Path: /
> >
> > Summary:
> >   Disk_size:                 72.57GB
> >   Disk_allocated:            25.10GB
> >   Disk_unallocated:          47.48GB
> >   Logical_size:              23.06GB
> >   Used:                      11.01GB
> >   Free_(Estimated):          55.66GB    (Max: 59.52GB, Min: 35.78GB)
> >   Data_to_disk_ratio:           92 %
> > 
> >
> > Details:

How about calling this "Chunks:"?

Its actually what is being displayed.

> >   Chunk-type  Mode      Chunk-size Logical-size        Used
> 
> "Type" for the first column is probably enough.

Then Chunk-type can become "Type"...

> Why is the third column called Chunk-size?  If my understanding is
> correct, it's just a break down of Disk_allocated from the summary
> section.  If so, why not call it Disk_allocated to avoid confusion?

... and "Chunk-size" just "Size".

> Also, why do you use dashes instead of underbars for table headers?

I prefer dashes, or even spaces, but spaces are more difficult to parse.

So or so I think scripts better do not parse a user formatted output – it 
sets the output format thats intended for the users viewing pleasure in 
stone. Then its better to provide an option to get all of this in 
parseable format. fio 2.0.10 has a JSON outputter for easy parsing, maybe 
some of that can be used – in a different patch set.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:49603 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528AbaCLIVN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 04:21:13 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel BUG: btrfs send - Incremental backup
Date: Wed, 12 Mar 2014 09:20:09 +0100
Message-ID: <1534308.rS2sq7rkIX@tethys>
In-Reply-To: <531F4419.8010109@fb.com>
References: <2853810.EcqZt5vpol@tethys> <531F4419.8010109@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

I'm afraid I will not have the time to perform the kernel compilations and 
tests you request in the coming days. I'm sorry but I will really be 120% 
overloaded already...

Kind regards.

Le mardi 11 mars 2014 13:12:57 Josef Bacik a écrit :
> Well that's odd, I can't think of how this would happen.  Can pull
> down btrfs-next and run that and verify you still hit the BUG_ON?  If
> you do please apply this patch and re-run and reply with the dmesg.
> 
> http://paste.fedoraproject.org/84393/55775013
> 
> This will spit out something like this
> 
> cur_ino=<NUMBER>, cmp_key objectid=<OTHER NUMBER>
> 
> then I need you to unmount your fs and run
> 
> btrfs-debug-tree /dev/whatever > blah.txt
> 
> You have about 1.5 gig of metadata so that is going to take a while.
> Once that is done you want to go through blah.txt and look for
> 
> item <number> key (<OTHER NUMBER FROM ABOVE> EXTENT_DATA <number>)
> 
> You need to find all of these entries and copy them down, an example
> output looks like this
> 
> item 1 key (286 EXTENT_DATA 577536) itemoff 3889 itemsize 53
>         extent data disk byte 12763136 nr 4096
>         extent data offset 0 nr 4096 ram 4096
>         extent compression 0
> 
> That is what I'm looking for, you will have multiple of these.  Thanks,
> 
> Josef

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E


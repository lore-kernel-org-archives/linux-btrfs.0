Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1207.opentransfer.com ([98.130.1.227]:46052 "EHLO
	mail1207.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab3GBJ4T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jul 2013 05:56:19 -0400
Message-ID: <1372758978.7295.17.camel@miguel-MacBookPro>
Subject: Re: btrfs send /receive : having problems sending a snapshot back
 to the original partition
From: Miguel =?ISO-8859-1?Q?Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: btrfs list <linux-btrfs@vger.kernel.org>
Date: Tue, 02 Jul 2013 10:56:18 +0100
In-Reply-To: <51D1A529.4040109@giantdisaster.de>
References: <1372612472.13762.18.camel@miguel-MacBookPro>
	 <51D1A529.4040109@giantdisaster.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Seg, 2013-07-01 às 17:50 +0200, Stefan Behrens escreveu:
What you are trying to do is not possible, it is not supported.
> 
> Btrfs send/receive can be used to create backups. The use case to
> restore from backups is not addressed.
> 
Ok, I see, but then I think I don't understand how btrfs send receive is
working. Is it the case that the parent 'a' in 'btrfs send -p a b' has
to be an "older" version of 'b' and never the other way around, perhaps
in the sense of a having a lower transid as returned by sudo btrfs
subvolume find-new a 999999999999999 ? 

I tried doing  'btrfs send -p original a' then 'btrfs send -p a b', then
deleting 'a' in the second disk and then doing 'btrfs send -p b a' but
that also fails [1], the error happening on the receive side.

best,
-- 
Miguel Negrão
http://www.friendlyvirus.org/miguelnegrao


[1]
 1999  touch /tmp/aaa.txt
 2003  sudo btrfs subvolume snapshot -r /mnt/@ @-1
 2004  touch /tmp/bbb.txt
 2005  sudo btrfs subvolume snapshot -r /mnt/@ @-2
 2007  sudo btrfs send -p @-2013-07-02-08\:03 @-1 | pv | sudo btrfs
receive /media/miguel/huge/backups/@
 2008  sudo btrfs send -p @-1 @-2 | pv | sudo btrfs
receive /media/miguel/huge/backups/@
 2010  btrdelete /media/miguel/huge/backups/@/@-1
 2011  sudo btrfs send -p @-2 @-1 | pv | sudo btrfs
receive /media/miguel/huge/backups/@

error:

At subvol @-1
3,91kB 0:00:00 [ 345kB/s] [<=>
]
At snapshot @-1
ERROR: failed to clone extents to var/log/syslog
Invalid argument



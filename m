From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: read error: how to fix?
Date: Sat, 15 Oct 2011 20:47:33 +0200
Message-ID: <201110152047.34228.Martin@lichtvoll.de>
References: <Bv$GAecT1uB@helmut.hullen.de> (sfid-20111010_211707_841954_66272E57)
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org, helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bv$GAecT1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Helmut,

Am Montag, 10. Oktober 2011 schrieb Helmut Hullen:
> > The thing is that marking sectors bad is a
> > (pretty poor) band-aid for a much bigger problem: If you're hitting
> > persistent read errors and re-writing the blocks doesn't fix it, your
> > disk is already close to being completely kaput and no amount of
> > software is going to help with that.
> 
> The next steps could be:
> 
> - adding a new 2-TByte disk (now there are 3 2-TByte disks)
> - balancing
> - removing the bad 2-TByte disk
> 
> But I'm afraid when I run balancing then the bad sectors damage big  
> parts of the contents. I've had such bad luck about 1 year ago,
> losing   about 2 TByte of data (ok - I had a kind of backup in a
> neighbout town). I don't like to reproduce this experience.
> 
> I'm afraid I have to buy 3 (or 4) 2-TByte disks, building them as a
> new   raid0-data cluster and copy the complete contents from the old
> cluster to the new one. Doesn't sound good.

RAID-0 and valuable (?) data does not match together. So if you go 4 
disks, consider a RAID 10 ;). Then you could set the disk faulty, put in a 
new one and let BTRFS resync/balance the RAID. But if everything is only 
stored on one disk thats not possible.

A RAID 5 might also be an alternative, but I am not sure, whether RAID-5 
is already working with BTRFS. I heard about plans to borrow some SoftRAID 
code for that.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Tue, 8 May 2012 00:07:51 +0200
Message-ID: <201205080007.51704.Martin@lichtvoll.de>
References: <C8PDRKGPCXB@helmut.hullen.de> (sfid-20120507_234447_689949_257B2EC7)
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org, helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8PDRKGPCXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 7. Mai 2012 schrieb Helmut Hullen:
> > If you want to survive losing a single disk without the (absolute)
> > fear of the whole filesystem breaking you have to have some sort of
> > redundancy either by separating filesystems or using some version of
> > raid other than raid0.
> 
> No - since some years I use a kind of outsourced backup. A copy of
> all   data is on a bundle of disks somewhere in the neighbourhood. As
> mentionend: the data isn't business critical, it's just "nice to
> have". It's not worth something like raid1 or so (with twice the costs
> of a non raid solution).

Thats not true when you use BTRFS RAID1 with three disks. BTRFS will only 
store each chunk on two different drives then, not on all three. Such it is 
not twice the cost, but given all three drives have the same capacity 
about one and a half times the cost.

Consider the time to recover the files from the outsourced backup. Maybe it 
does make up the money you would have to spend for one additional 
harddisk.

Anyway, I agree with the others responding to your post that this one 
harddisk died and I do not see a kernel version related issue. Any striped 
RAID 0 would have failed in that case.

And you can use three BTRFS filesystems the same way as three Ext4 
filesystems if you prefer such a setup if the time spent for restoring the 
backup does not make up the cost for one additional disk for you.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

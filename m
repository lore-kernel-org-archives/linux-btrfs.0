From: Stephane CHAZELAS <stephane_chazelas@yahoo.fr>
Subject: Re: stripe alignment consideration for btrfs on RAID5
Date: Wed, 23 Nov 2011 17:55:19 +0000 (UTC)
Message-ID: <slrnjcqcs7.b3r.stephane.chazelas@spam.is.invalid>
References: <slrnjcq9sh.b3r.stephane.chazelas@spam.is.invalid>
 <94D5143C-1E94-4F12-995B-BCCDEC7108C1@orcaware.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

2011-11-23, 09:08(-08), Blair Zajac:
>
> On Nov 23, 2011, at 9:04 AM, Stephane CHAZELAS wrote:
>
>> Hiya,
>> 
>> is there any recommendation out there to setup a btrfs FS on top
>> of hardware or software raid5 or raid6 wrt stripe/stride alignment?
>
> Isn't the advantage of having btrfs do all the raiding itself
> so one gets the checksums?  If one puts btrfs on top of
> software or hardware raid, then if there is a checksum error,
> you don't have another copy of the data to fall back to.  If
> one uses btrfs' raid1 or above for data and metadata, then you
> can suffer a checksum failure and get a good copy from another
> drive?
[...]

Yes, but btrfs doesn't support raid5 yet and I have a limited
number of drives I can connect to that system, and storage
capacity is more important for me than the odd chance of
corruptions of odd sectors (which can be mitigated by running
regular RAID checks).

Also, my tests of btrfs raid10 didn't indicate it was reliable
enough yet (when a drive disappears and reappears, btrfs seems
to get quite confused).

-- 
Stephane


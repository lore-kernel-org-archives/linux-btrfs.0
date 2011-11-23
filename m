From: Blair Zajac <blair@orcaware.com>
Subject: Re: stripe alignment consideration for btrfs on RAID5
Date: Wed, 23 Nov 2011 09:08:33 -0800
Message-ID: <94D5143C-1E94-4F12-995B-BCCDEC7108C1@orcaware.com>
References: <slrnjcq9sh.b3r.stephane.chazelas@spam.is.invalid>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Stephane CHAZELAS <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <slrnjcq9sh.b3r.stephane.chazelas@spam.is.invalid>
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 23, 2011, at 9:04 AM, Stephane CHAZELAS wrote:

> Hiya,
> 
> is there any recommendation out there to setup a btrfs FS on top
> of hardware or software raid5 or raid6 wrt stripe/stride alignment?

Isn't the advantage of having btrfs do all the raiding itself so one gets the checksums?  If one puts btrfs on top of software or hardware raid, then if there is a checksum error, you don't have another copy of the data to fall back to.  If one uses btrfs' raid1 or above for data and metadata, then you can suffer a checksum failure and get a good copy from another drive?

Blair


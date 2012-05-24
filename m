Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:60044 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753899Ab2EXKUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 May 2012 06:20:13 -0400
From: "Bjoern Wuest" <bjoern.wuest@gmx.net>
To: "'Hugo Mills'" <hugo@carfax.org.uk>
Cc: <linux-btrfs@vger.kernel.org>
References: <5A83377DACA90F4896A338250D088E8F14B35F09@HMEXMBCLUS01.ci04.de> <20120524084058.GD31037@carfax.org.uk>
In-Reply-To: <20120524084058.GD31037@carfax.org.uk>
Subject: RE: Preparing single-disk setup for future multi-disk usage
Date: Thu, 24 May 2012 12:20:11 +0200
Message-ID: <007501cd3996$cf26da40$6d748ec0$@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,


Thank you very much for the information.


Regards
  Bjoern


-----Original Message-----
From: Hugo Mills [mailto:hugo@carfax.org.uk] 
Sent: Thursday, May 24, 2012 10:41 AM
To: Björn Wüst
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Preparing single-disk setup for future multi-disk usage

On Thu, May 24, 2012 at 08:05:23AM +0200, Björn Wüst wrote:
> Good morning,
> 
> 
> I currently have a single-disk setup where I want to use btrfs filesystem.
Yet, I expect to add additional disks to this system in the future. Those
disks shall be visible to the OS like a single disk, i.e. using multi-disk
feature in btrfs. While data shall be striped among those disks in the
future, meta data shall be mirrored for better fault tolerance (loss of some
data is acceptable, while loss of all data is not acceptable).
> 
> btrfs supports multi-disk setups and even adding additional devices at a
later point of time. Thus, it is my preferred choice. However, I am puzzled
how the mkfs.btrfs command must be parametrized to have RAID1 for meta data
and RAID0 for data with just a single disk / partition. Could I simply do
mkfs.btrfs -m raid1 -d raid0 /dev/sdaX (where X is the partition number) ?

   No, this will fail to work, as RAID-1 and -0 both require at least two
disks. What you need to do is use the default settings (mkfs.btrfs
/dev/sdaX) for now, which will give you DUP metadata (two copies of each
block, in different places on the disk), and "single" data (one copy of the
data).

   When you add a new disk, you can convert the replication to something
else, using the balance command:

# btrfs dev add /dev/sdY /mountpoint
# btrfs balance start -dconvert=raid0 /mountpoint

(Note that you don't need to specify -m raid1 to convert the metadata, as
the DUP->RAID-1 conversion is implicit where it's possible).

> Unfortunately, I do not have a disk to test it right now. The disk I am
planning to use is with the post service still :) . Searching the Web could
not reveal a similar scenario. All multi-disk examples assume that you
already have multiple disks and not that you are going to have them.

   The conversion code is quite new, so there's few examples out there right
now.

   Hugo.

--
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- There are three things you should never see being made: laws, ---  
                        standards,  and sausages.                        


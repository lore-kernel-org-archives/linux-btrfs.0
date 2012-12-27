Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo103.cox.net ([68.230.241.215]:40899 "EHLO
	eastrmfepo103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab2L0T1Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 14:27:25 -0500
Received: from eastrmimpo110 ([68.230.241.223]) by eastrmfepo103.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20121227192725.ZKBD8874.eastrmfepo103.cox.net@eastrmimpo110>
          for <linux-btrfs@vger.kernel.org>;
          Thu, 27 Dec 2012 14:27:25 -0500
Message-ID: <50DCA11C.2050501@czarc.net>
Date: Thu, 27 Dec 2012 14:27:24 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Another novice question & comment
References: <50DC5B51.9060506@czarc.net> <20121227150328.GV19051@carfax.org.uk> <50DC7BA0.2080401@petaramesh.org> <95393023-B40D-4331-A429-3D488B9D0576@colorremedies.com>
In-Reply-To: <95393023-B40D-4331-A429-3D488B9D0576@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/27/2012 11:55 AM, Chris Murphy wrote:
> On Dec 27, 2012, at 9:47 AM, Swâmi Petaramesh <swami@petaramesh.org> wrote:
>
>> Le 27/12/2012 16:03, Hugo Mills a écrit :
>>>    Right now, no, there isn't any way of telling which subvolume is
>>> mounted at a given location.
>> Er... Check "subvol=" here...
>>
>> root@tethys:/# mount | grep btrfs
>> /dev/mapper/VG1-BTR_POOL on / type btrfs
>> (rw,relatime,subvol=UBUNTU/@,autodefrag,compress=lzo)
>> /dev/mapper/VG1-BTR_POOL on /tmp type btrfs
>> (rw,relatime,subvol=UBUNTU/@tmp,compress=lzo)
>> /dev/sda2 on /boot type btrfs (rw,relatime,subvol=UBUNTU/@boot,autodefrag)
>> /dev/mapper/VG1-BTR_POOL on /home type btrfs
>> (rw,relatime,subvol=UBUNTU/@home,autodefrag,compress=lzo)
>> /dev/mapper/VG1-BTR_POOL on /storage type btrfs
>> (rw,relatime,subvol=STORAGE,autodefrag,compress=lzo)
>> /dev/mapper/VG1-BTR_POOL on /data/BIG type btrfs
>> (rw,noatime,subvol=DATA/BIG,compress=lzo)
>
> That would only seem to work with btrfs on LVM which I'd think is uncommon and complicated.
>
Oh thanks for that little reminder that you can put btrfs on an LV.

I am trying to see if I can get grub2 and os-prober to handle btrfs.  
There are a couple of patches out there but they do little if anything.  
The btrfs volumes and subvolumes are "not your father's filesystem" 8-)

I have a little of what is needed working but, the more I look at 
things, the more it looks like some real kludgy hack is going to be 
needed to have something which works with /dev/<whatever> to now use 
UUID=xxx,subvol=name

Gene

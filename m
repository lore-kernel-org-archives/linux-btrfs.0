Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:60784 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757462Ab2JWWQR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 18:16:17 -0400
Message-ID: <5087174A.2060405@inwind.it>
Date: Wed, 24 Oct 2012 00:16:42 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: device delete, error removing device
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com> <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com> <20121022091904.GY25498@carfax.org.uk> <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com> <20121022171809.GA25498@carfax.org.uk> <20121023075721.GB391@yeono.kjorling.se> <5086DDAE.3050708@gmail.com> <442D159A-4A4E-4A50-B1DB-0E6E12FA6F5C@colorremedies.com> <5086E9D6.4070201@inwind.it> <3443D67F-6CCE-48BF-A1DB-12473BE95EE8@colorremedies.com>
In-Reply-To: <3443D67F-6CCE-48BF-A1DB-12473BE95EE8@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

I was able to reproduce (partially) your behaviour.

First I created 3 disk of 3GB. I formatted them, then I filled them with

$ dd if=/dev/zero of=/mnt/btrfs1/bigfile bs=1M count=$((7*1024))

Then I got

$ sudo /mnt/home-ghigo/btrfs/btrfs-progs/btrfs fi sh
Label: 'test1'  uuid: 7ba72d6f-d226-4e8c-9a9c-92a7fd89cd99
	Total devices 3 FS bytes used 7.01GB
	devid    3 size 3.00GB used 3.00GB path /dev/vdd
	devid    2 size 3.00GB used 2.55GB path /dev/vdc
	devid    1 size 3.00GB used 3.00GB path /dev/vdb

Then I added a 12GB devices, and then I did

$ sudo btrfs device del /dev/vdb /mnt/btrfs1

After a bit of time I *succeeded* to remove the disk. Then I did:

$ sudo /mnt/home-ghigo/btrfs/btrfs-progs/btrfs fi sh
 Label: 'test1'  uuid: 7ba72d6f-d226-4e8c-9a9c-92a7fd89cd99
	Total devices 4 FS bytes used 7.01GB
	devid    4 size 12.00GB used 3.21GB path /dev/vdf
	devid    3 size 3.00GB used 2.53GB path /dev/vdd
	devid    2 size 3.00GB used 2.95GB path /dev/vdc
	*** Some devices missing

Which is what you are reporting.

Further analysis revealed that:
1) The /dev/sdb superblock signatures is really zeroed by btrfs after
removing. In fact the disk /dev/vdb disappeared from the list above as
considered not valid.
2) The other superblocks aren't reset to the new setup after removing.
Every superblock still stores as number of disk the (old) value of 4.
3) *If I don't touch* the filesystem the situation above doesn't change.
4) If I touch the filesystem (eg creating a file or unmount the
filesystem) then the superblocks are update and the I get

$ sudo /mnt/home-ghigo/btrfs/btrfs-progs/btrfs fi show
Label: 'test1'  uuid: 7ba72d6f-d226-4e8c-9a9c-92a7fd89cd99
	Total devices 3 FS bytes used 7.01GB
	devid    4 size 12.00GB used 3.21GB path /dev/vdf
	devid    3 size 3.00GB used 2.53GB path /dev/vdd
	devid    2 size 3.00GB used 2.95GB path /dev/vdc



Conclusion:
- I was not able to reproduce your problem about removing the device. I
was able to remove the device after filling the filesystem and adding a
new device.
- After removing a device, its superblock is zeroed. However the other
superblock aren't updated
- To update the other superblocks, it is needed to a) make some writing
to the filesystem [and wait the 30s timeout] or b) unmount the
filesystem. If you don't do that the superblocks still contain the old
value.

If this will be confirmed, this my be considered a bug because in case
of power supply shortage the filesystem stores an incorrect information
about the number of disks which compose the filesystem.

BR
G.Baroncelli

On 2012-10-23 22:28, Chris Murphy wrote:
> 
> On Oct 23, 2012, at 1:02 PM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
> 
>> On 2012-10-23 20:17, Chris Murphy wrote:
>>>
>>> btrfs-progs-0.20.rc1.20121017git91d9eec-1.fc18.x86_64
>>
>> Definitely this version contains my patch.
>>
>> Are you able to reproduce this bug (the missing device warning)?
> 
> Yes. 100%. It's there hours later.
> 
>> If so,
>> please could you be so kindly to test the Stefan's tool [*] to dump the
>> super-blocks of the involved disks ?
> 
> I would but haven't the first clue what to do with this:
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg19572.html
> 
> This happens even with no data, so I can dd the entire missing device into a sparse file: dd to img, cp --sparse, tar with -Sj. The 80GB /dev/sdb becomes 2.5K. It's here now:
> https://dl.dropbox.com/u/3253801/devsdb_image_sparse.img.tar.bz2
> 
> And by the time I've done all that, the "*** Some devices missing" message is still present with 'btrfs fi show'
> 
> Or since it's a VM that I don't care about at all, I can give you login info.
> 
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

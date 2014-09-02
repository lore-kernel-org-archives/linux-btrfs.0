Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:40746 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751850AbaIBTRM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 15:17:12 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49257 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XOtZj-003qic-Dc
	for linux-btrfs@vger.kernel.org; Tue, 02 Sep 2014 13:17:09 -0600
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Large files, nodatacow and fragmentation
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CADw2B2N4T_XWOWt++8wGhXk5WJmKgQGqhbt=m2JbQCO_ekfhxA@mail.gmail.com>
Date: Tue, 2 Sep 2014 13:17:05 -0600
Message-Id: <F9C10FF2-81CD-4017-B76D-BDD1E947B75F@colorremedies.com>
References: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com> <20140812011401.568c16e6@natsu> <AC90CAC7-A8F5-4C74-8295-4360A6A8FE45@colorremedies.com> <CADw2B2NnWFY=rOvArTDtnw2jkRe-HqNCcqeB0r80et60euEy3g@mail.gmail.com> <9EB33BE3-FAC0-4AE8-BB95-ABE68C578D47@colorremedies.com> <CADw2B2MGyDAvAxrZOML0kX_shdFD6QSyMV9XWxKfJAoZpLXsSQ@mail.gmail.com> <08770CD2-AA55-4BC1-B92C-E7D3360399F8@colorremedies.com> <CADw2B2NJQYn_xkrAebmdu_c-7z7yFNZ1aDFS=jYmQcHfco2d+g@mail.gmail.com> <5CE63712-2C3E-4BF3-B971-C6F17AE10E3D@colorremedies.com> <CADw2B2N4T_XWOWt++8wGhXk5WJmKgQGqhbt=m2JbQCO_ekfhxA@mail.gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 2, 2014, at 12:31 PM, G. Richard Bellamy <rbellamy@pteradigm.com> wrote:

> I thought I'd follow-up and give everyone an update, in case anyone
> had further interest.
> 
> I've rebuilt the RAID10 volume in question with a Samsung 840 Pro for
> bcache front device.
> 
> It's 5x600GB SAS 15k RPM drives RAID10, with the 512MB SSD bcache.
> 
> 2014-09-02 11:23:16
> root@eanna i /var/lib/libvirt/images # lsblk
> NAME      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
> sda         8:0    0 558.9G  0 disk
> └─bcache3 254:3    0 558.9G  0 disk /var/lib/btrfs/data
> sdb         8:16   0 558.9G  0 disk
> └─bcache2 254:2    0 558.9G  0 disk
> sdc         8:32   0 558.9G  0 disk
> └─bcache1 254:1    0 558.9G  0 disk
> sdd         8:48   0 558.9G  0 disk
> └─bcache0 254:0    0 558.9G  0 disk
> sde         8:64   0 558.9G  0 disk
> └─bcache4 254:4    0 558.9G  0 disk
> sdf         8:80   0   1.8T  0 disk
> └─sdf1      8:81   0   1.8T  0 part
> sdg         8:96   0   477G  0 disk /var/lib/btrfs/system
> sdh         8:112  0   477G  0 disk
> sdi         8:128  0   477G  0 disk
> ├─bcache0 254:0    0 558.9G  0 disk
> ├─bcache1 254:1    0 558.9G  0 disk
> ├─bcache2 254:2    0 558.9G  0 disk
> ├─bcache3 254:3    0 558.9G  0 disk /var/lib/btrfs/data
> └─bcache4 254:4    0 558.9G  0 disk
> sr0        11:0    1  1024M  0 rom
> 
> I further split the system and data drives of the VM Win7 guest. It's
> very interesting to see the huge level of fragmentation I'm seeing,
> even with the help of ordered writes offered by bcache - in other
> words while bcache seems to be offering me stability and better
> behavior to the guest, the underlying the filesystem is still seeing a
> level of fragmentation that has me scratching my head.
> 
> That being said, I don't know what would be normal fragmentation of a
> VM Win7 guest system drive, so could be I'm just operating in my zone
> of ignorance again.
> 
> 2014-09-01 14:41:19
> root@eanna i /var/lib/libvirt/images # filefrag atlas-*
> atlas-data.qcow2: 7 extents found
> atlas-system.qcow2: 154 extents found
> 2014-09-01 18:12:27
> root@eanna i /var/lib/libvirt/images # filefrag atlas-*
> atlas-data.qcow2: 564 extents found
> atlas-system.qcow2: 28171 extents found
> 2014-09-02 08:22:00
> root@eanna i /var/lib/libvirt/images # filefrag atlas-*
> atlas-data.qcow2: 564 extents found
> atlas-system.qcow2: 35281 extents found
> 2014-09-02 08:44:43
> root@eanna i /var/lib/libvirt/images # filefrag atlas-*
> atlas-data.qcow2: 564 extents found
> atlas-system.qcow2: 37203 extents found
> 2014-09-02 10:14:32
> root@eanna i /var/lib/libvirt/images # filefrag atlas-*
> atlas-data.qcow2: 564 extents found
> atlas-system.qcow2: 40903 extents found

Hmm interesting. What is happening to atlas-data.qcow2 this whole time? It goes from 7 extents to 564 within 3.5 hours and stays there, implying either no writes, or only overwrites are happening, not new writes (writes to previously unwritten LBA's as far as the VM guest is concerned). The file atlas-system.qcow2 meanwhile has a huge spike of fragments in the first 3.5 hours as it's being populated by some activity, and then it looks like it tapers off quite a bit, either indicate less writes, or more overwrites, but still with quite a bit of new writes.

Most of my experience with qcow2 on btrfs with +C xattr has been a lot of new writes, and then mostly overwrites. The pattern I see there is a lot of initial fragmentation, and then much less which makes sense in my case because a bulk of subsequent writes are overwrites. But I also noticed despite the fragmentation, it didn't seem to negatively impact performance.


Chris Murphy
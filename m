Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33906 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbbFANDo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Jun 2015 09:03:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YzPNT-0004q4-Kg
	for linux-btrfs@vger.kernel.org; Mon, 01 Jun 2015 15:03:39 +0200
Received: from exa2-in-fw-01-epn.hns.com ([139.85.223.11])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2015 15:03:39 +0200
Received: from ndbecker2 by exa2-in-fw-01-epn.hns.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2015 15:03:39 +0200
To: linux-btrfs@vger.kernel.org
From: Neal Becker <ndbecker2@gmail.com>
Subject: Re: [newb] move /home to subvolume
Date: Mon, 01 Jun 2015 09:03:27 -0400
Message-ID: <mkhl70$fnu$1@ger.gmane.org>
References: <mkhjkp$hgl$1@ger.gmane.org> <CAO5K3OfGP6SxK0Ch9XSu1dGZgjEx8G7-b19+2m0tGHzpjY++Zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I think what I need to do is:

1. boot off some rescue media
2. mount the target btrfs volume (e.g., /mnt/sysimage/root)
3. mv exising home (mv /mnt/sysimage/home /mnt/sysimage/oldhome)
4. create new subvolume (btrfs subvolume create /mnt/sysimage/home)
5. move all the files from /mnt/sysimage/oldhome /mnt/sysimage/home - not 
sure easiest way to do this step
6. edit /mnt/sysimage/etc/fstab to mount new /home

I have another machine, setup more or less this way:
UUID=7246327b-1905-4fe2-9b6b-b9376017264f /                       btrfs   
subvolid=5,subvol=root00 0 0
UUID=2c04be93-34c1-4016-ba41-60fd9fd90616 /boot                   ext4    
defaults        1 2
UUID=7246327b-1905-4fe2-9b6b-b9376017264f /home                   btrfs   
subvol=home     0 0



Vytautas D wrote:

> as far as I know, you can't do this, you need to temporary move /home
> somewhere else, create /home subvolume and copy everything back.
> 
> -
> Vytas
> 
> On Mon, Jun 1, 2015 at 1:36 PM, Neal Becker <ndbecker2@gmail.com> wrote:
>> I have everything under /:
>>
>> sudo btrfs subvolume list /
>> ID 257 gen 65795 top level 5 path root
>>
>> I want to move /home onto it's own subvolume.  I hope I can do this while
>> the root device is mounted.
>>
>> What is the procedure?
>>
>> I tried first to create a subvolume for /home at the top-level, but
>> couldn't figure out the syntax:
>>
>> [nbecker@nbecker2 ~]$ sudo btrfs subvolume create /home
>> [sudo] password for nbecker:
>> ERROR: '/home' exists
>>
>> --
>> Those who fail to understand recursion are doomed to repeat it
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Those who fail to understand recursion are doomed to repeat it


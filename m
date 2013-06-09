Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v1167.vcdns.de ([88.80.200.92]:43599 "EHLO delorus.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab3FIRFZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Jun 2013 13:05:25 -0400
Message-ID: <51B4B5D1.7040406@delorus.de>
Date: Sun, 09 Jun 2013 19:05:21 +0200
From: =?ISO-8859-1?Q?Andr=E9_Schlichting?= <andre@delorus.de>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Moved partition via dd
References: <51B327C4.3000304@delorus.de> <E3D849EC-DDAC-4E05-9571-303B869F7A8D@colorremedies.com> <51B3B339.4030108@delorus.de> <8E5CABA3-602A-4D2F-AAEF-74F007F3C2FF@colorremedies.com> <51B45C87.2040308@delorus.de> <20130609111156.GA4174@carfax.org.uk>
In-Reply-To: <20130609111156.GA4174@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> I actually think that the move of the partition was no problem. I
>> guess that btrfs has some absolute references which have to be
>> adjusted and now has some problems with sectors not at the right
>> place.
>
>     No, it doesn't. All the position values in the FS are either
> relative to the containing block device (i.e. the partition, in this
> case), or are based on an internal virtual address space -- which is
> itself mapped in terms of the containing block device(s).
Thank you for the clarification and background.

>
>> The following error from btrfsck
>>> Check tree block failed, want=959572647936, have=13587293097915834379
>> suggests that 959572647936 is a way off...
>
>     That just says to me that you've got garbage metadata -- usually a
> good indication that there's some file data where there should be
> metadata, which would further suggest that you've somehow moved the
> wrong data (or the right data into the wrong place).
>
Seems like, that this happened and I actually also know how/when. I 
started moving the partition with my Laptop. But after the first 
projection of the time needed to move 2TB on USB2 speed, I decided to 
move the partition with a PC. So I stopped dd and tried to get the last 
sector position and continued on the Desktop with this position as 
"skip" value. I'm pretty sure, that there I did some mistake. That is 
also the reason, why the Luks-Header was intact.

>> Maybe first, the principal question: Can one just move a
>> btrfs-partition to the left by
>> * delete partition
>> * create partition moved
>> * dd data from old to new partition
>> Or does one have to adjust some references inside the btrfs filesystem?
>
>     In theory, that process should be safe. In fact, I'm not aware of
> *any* filesystem which is dependent on the position of the partition
> within a larger device.
>
I will try this in practice again on a spare disk with some smaller 
partition.

>     I think at this point, you should try testdisk to see if it can
> identify your FS's superblock. If that doesn't work, then restore from
> backup is likely to be your fastest route to recovery.
>
Actually, this disk will become my new backup drive. So everything save 
and I reformatted it already.

André

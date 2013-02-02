Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64112 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab3BBRgZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Feb 2013 12:36:25 -0500
Received: by mail-wi0-f181.google.com with SMTP id hm6so368548wib.8
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Feb 2013 09:36:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOeZVicJEMg6OmDdkV5_Ti8==527bsH+VDbKkrgQe+Myyg4_gg@mail.gmail.com>
References: <CAOeZVicqqcrBrL6EiVBgsUzc5uTSTzwghktS2ebtP09Gdg2miw@mail.gmail.com>
	<20130202161959.GS16285@carfax.org.uk>
	<CAOeZVicJEMg6OmDdkV5_Ti8==527bsH+VDbKkrgQe+Myyg4_gg@mail.gmail.com>
Date: Sat, 2 Feb 2013 23:06:23 +0530
Message-ID: <CAOeZVicg6FNj_+nyQZzrrRs3CBmKaYbb5+fgCGdVf0U=M=49wQ@mail.gmail.com>
Subject: Re: Newbie help-- Making BTRFS partition
From: Atri Sharma <atri.jiit@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Atri Sharma <atri.jiit@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

Thanks for the earlier help.

I needed some more help please.

I created a BTRFS partition on /dev/sda3. To verify, the output of df
-T command:

e
/dev/sda1                         fuseblk     102396   25180     77216
 25% /run/media/atri/System Reserved
/dev/sda3                         btrfs    331637760     120 317977536
  1% /run/media/atri/02fad498-f636-410e-a4bf-4d91428b9106


After this, I am trying to create a folder on the partition. How do I do that?

I tried :

[atri@AtriServer ~]$ sudo btrfs subvolume create /dev/sda3/
Create subvolume '/dev/sda3'
ERROR: cannot create subvolume - Inappropriate ioctl for device


Please help.

Atri

On Sat, Feb 2, 2013 at 9:56 PM, Atri Sharma <atri.jiit@gmail.com> wrote:
> Hi Hugo,
>
> Thanks.
>  I was having some issues with my priviledges, and sorting them out has worked.
>
> Thanks a ton,
>
> Atri
>
> On Sat, Feb 2, 2013 at 9:50 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> On Sat, Feb 02, 2013 at 08:56:20PM +0530, Atri Sharma wrote:
>>> Hi all,
>>>
>>> I am running a Fedora 17 system. I am trying to set up a new partition
>>> of 2 GB size which has BTRFS as file system.
>>>
>>> When I am trying to do mkfs.btrfs on a partition, I get:
>>>
>>> [atri@AtriServer ~]$ mkfs.btrfs /dev/sda3
>>>
>>> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
>>> WARNING! - see http://btrfs.wiki.kernel.org before using
>>>
>>> check_mounted(): Could not open /dev/sda3
>>> error checking /dev/sda3 mount status
>>
>>    You need to be root, or (typically) to be in the "disk" group in
>> order to write to a block device.
>>
>>    Hugo.
>>
>> --
>> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>>   --- "What's so bad about being drunk?" "You ask a glass of water" ---
>>
>
>
>
> --
> Regards,
>
> Atri
> l'apprenant



-- 
Regards,

Atri
l'apprenant

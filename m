Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:52961 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760059Ab3IDNvu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 09:51:50 -0400
Received: by mail-pa0-f52.google.com with SMTP id kq13so452556pab.39
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 06:51:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130904133207.GC6389@carfax.org.uk>
References: <CAN3gubkkb5jKPddRcDVBqr=r7c6_jFP6-hMaiWQ4mie6Fk90pA@mail.gmail.com>
	<20130904133207.GC6389@carfax.org.uk>
Date: Wed, 4 Sep 2013 15:51:50 +0200
Message-ID: <CAN3gubnrbEWaiJf1VFATgAX+p9btGTDX916BLEmJZG5yt_HA-Q@mail.gmail.com>
Subject: Re: Btrfs prog
From: Giuseppe Fierro <giuseppe@fierro.org>
To: Hugo Mills <hugo@carfax.org.uk>, Giuseppe Fierro <giuseppe@fierro.org>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks,
as I can see I misunderstood the meaning of "btrfs filesystem df" I
was expecting that the 'df' has been to display free space remaining.

The -a option works

Giuseppe Fierro

On 4 September 2013 15:32, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Wed, Sep 04, 2013 at 01:57:42PM +0200, Giuseppe Fierro wrote:
>> I'm using btrfs on ubuntu 13.04 with btrfs prog v0.20-rc1
>> This is my configuration using 2 disks in raid1 mode:
>>
>> > gspe@jura:/mnt$ sudo btrfs f show
>> > Label: 'UbuntuDSK'  uuid: f4a3c832-f6ab-4b1d-9eb7-f9ba7d1cba01
>> > Total devices 2 FS bytes used 205.41GB
>> > devid    1 size 2.70TB used 214.03GB path /dev/sdb2
>> > devid    2 size 2.70TB used 214.01GB path /dev/sda2
>> > Btrfs v0.20-rc1
>>
>>
>> Some btrfs command behave strange:
>> If i want to check free space using df, i get:
>>
>> > gspe@jura:/mnt$ sudo btrfs filesystem df /
>> > Data, RAID1: total=212.00GB, used=204.42GB
>> > Data: total=8.00MB, used=0.00
>> > System, RAID1: total=8.00MB, used=36.00KB
>> > System: total=4.00MB, used=0.00
>> > Metadata, RAID1: total=2.00GB, used=1010.04MB
>> > Metadata: total=8.00MB, used=0.00
>
>    What do you think is wrong with this output? It looks OK to me:
>
>    From the btrfs fi show at the top, you have 214 GB allocated on
> each device. The btrfs fi df shows you how that allocation is used:
> 212 GB (*2, because it's RAID-1) is allocated to data, with 204 GB
> holding useful data. The remaining 2 GB (*2) is allocated to metadata,
> and 1 GB of that is actually used.
>
>> If I would like to show the subvolume, i get
>>
>> > gspe@jura:/mnt$ sudo btrfs subvolume list /
>> > gspe@jura:/mnt$
>>
>> nothing is shown!!!
>
>    Try using the -a option. It got added a while ago, and has been a
> complete pain in the neck ever since...
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>    --- The English language has the mot juste for every occasion. ---



-- 
This email and any attachments to it may be confidential and are
intended solely for the use of the individual to whom it is addressed.
Any views or opinions expressed are solely those of the author and do
not necessarily represent those of fierro.org.

If you are not the intended recipient of this email, you must neither
take any action based upon its contents, nor copy or show it to
anyone.

Please contact the sender if you believe you have received this email in error.

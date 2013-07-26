Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:38335 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454Ab3GZOgA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jul 2013 10:36:00 -0400
Received: by mail-oa0-f43.google.com with SMTP id i10so2477132oag.30
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jul 2013 07:36:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130726074508.GJ20517@carfax.org.uk>
References: <CANKzOHASE9pB6TjJ4JbqY1PE6cRsbCsY=KU3NVRjwcb74tikVQ@mail.gmail.com>
	<20130726074508.GJ20517@carfax.org.uk>
Date: Fri, 26 Jul 2013 16:35:59 +0200
Message-ID: <CANKzOHCJY29__R-5vsjNTrmQ82HgrYqrSgX2AZ7mbF2T1h=eTQ@mail.gmail.com>
Subject: Re: Adding 500G disk to btrfs volume... but I don't get 500G more of
 available space (raid0)
From: Axelle <aafortinet@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,
Thanks for your answer, but I'm afraid I still don't get it.

>RAID-0 requires at least two devices.

Well, I have three devices, so that's more than enough isn't it?
Or do you mean I should be adding two devices at a time?

> If you balance this
>configuration, you'll use up the first 93.13 GiB of each device
>striping across all three devices, for a total of 3*93.13 = 279.39

why 93.13? I guess you meant 84.53 which is the size I am using on
sdc1 and sdc6.

># btrfs balance start -dconvert=single,soft /samples

Nice command but I wasn't thinking of stopping RAID0 striping. I was
expecting my data to be stripped evenly on all 3 devices.

Well - evenly - until the smallest one /dev/sdc1 is filled, then,
it'll use only the last two, when /dev/sdc6 is filled, it will used
/dev/sdb only.
Is that possible/correct?


But basically, what does not make sense to me is what df reports as
available size.
Look.
Before, I had ~165G used on a total of 194G.
I added a new disk of 465G. Now, df reports I have a total of 660G
(that's right) with 165G used (that's correct too) but only 43G
available!

I was expecting to have ~495G available! Where are my 465G gone?


$ df -h
Filesystem      Size  Used Avail Use% Mounted on
...
/dev/sdc1       660G  165G   43G  80% /samples



Thanks
Axelle.

On Fri, Jul 26, 2013 at 9:45 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Jul 26, 2013 at 09:05:03AM +0200, Axelle wrote:
>> Hi btrfs folks,
>>
>> I'm afraid I have a newbie question... but I can't sort it out? It's
>> just about adding a disk to a btrfs volume and not getting the correct
>> amount of GB in the end...
>>
>> I have a btrfs volume which already consists of two different devices
>> and which is mounted on /samples. Its total size is 194G.
>>
>> $ df -h
>> Filesystem Size Used Avail Use% Mounted on ... /dev/sdc1 194G 165G 20G
>> 90% /samples
>>
>> Now, I would like to add another 500G to that volume, from another device. I did
>>
>> $ sudo mkfs.btrfs -m raid0 -d raid0 /dev/sdb
>> $ sudo btrfs device add /dev/sdb /samples
>> My filesystem now correctly reports:
>>
>> $ sudo btrfs filesystem show
>> Label: none  uuid: 545e95c6-d347-4a8c-8a49-38b9f9cb9add
>>     Total devices 3 FS bytes used 161.98GB
>>     devid    3 size 465.76GB used 0.00 path /dev/sdb
>>     devid    2 size 93.13GB used 84.51GB path /dev/sdc1
>>     devid    1 size 100.61GB used 84.53GB path /dev/sdc6
>> But I miss some space when I do:
>
>    RAID-0 requires at least two devices. If you balance this
> configuration, you'll use up the first 93.13 GiB of each device
> striping across all three devices, for a total of 3*93.13 = 279.39
> GiB. Then /dev/sdc1 becomes full, leaving you with two devices which
> have 7.48 GiB and 372.63 GiB respectively. After another 7.48 GiB on
> each device (for a total of 2*7.48 = 14.96 GiB), you have filled
> /dev/sdc1, leaving only /dev/sdb to work with. Since there's only one
> device, it can't be used by RAID-0.
>
>    If you want to use the full space available, you should rebalance
> to single usage, which stops the RAID-0 striping, and allocates
> linearly:
>
> # btrfs balance start -dconvert=single,soft /samples
>
>    Hugo.
>
>> $ df -h
>> Filesystem      Size  Used Avail Use% Mounted on
>> ...
>> /dev/sdc1       660G  165G   43G  80% /samples
>> I added 500G! Why haven't I got more available??
>>
>> To debug, I ran this command:
>>
>> $ sudo btrfs filesystem df /samples
>> Data, RAID0: total=162.00GB, used=159.79GB
>> Data: total=8.00MB, used=7.48MB
>> System, RAID1: total=8.00MB, used=24.00KB
>> System: total=4.00MB, used=0.00
>> Metadata, RAID1: total=3.50GB, used=2.19GB
>> Metadata: total=8.00MB, used=0.00
>> My data is in RAID0, that's ok. So where have my 500G gone, and how
>> can I fix this?
>>
>> Thanks
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>            --- Sometimes, when I'm alone, I Google myself. ---

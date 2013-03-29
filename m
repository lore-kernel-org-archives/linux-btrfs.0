Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:37241 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab3C2Obh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 10:31:37 -0400
Received: by mail-la0-f43.google.com with SMTP id ek20so586071lab.2
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2013 07:31:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130329142708.GB16159@carfax.org.uk>
References: <CAFWF=an6K-qa0krj_PKA-QvBV-Wv21Na0C1Pc3r4eP1_9-MNCg@mail.gmail.com>
 <20130329141222.GF1876@localhost.localdomain> <CAFWF=am_x20N1wy_awEq3fXNPB+7_En670c+a-hnMexvkPqv1g@mail.gmail.com>
 <20130329142708.GB16159@carfax.org.uk>
From: Harald Glatt <mail@hachre.de>
Date: Fri, 29 Mar 2013 15:31:15 +0100
Message-ID: <CAFWF=anAN38ri_VKEB2g6aPF-Oppx7Qhr1-pPqKm+sq7YUJA0Q@mail.gmail.com>
Subject: Re: Space usage metering
To: Hugo Mills <hugo@carfax.org.uk>, Harald Glatt <mail@hachre.de>,
        Josef Bacik <jbacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ahhhhh, now it makes sense!! Thanks!

On Fri, Mar 29, 2013 at 3:27 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Mar 29, 2013 at 03:18:03PM +0100, Harald Glatt wrote:
>> Sorry I forgot to post that,
>>
>> -> btrfs fi show
>> Label: none  uuid: 2feccf06-5af8-4d8a-ad8d-a090cf4ef69a
>> Total devices 2 FS bytes used 16.54GB
>> devid    1 size 40.90GB used 14.04GB path /dev/sda7
>> devid    2 size 17.75GB used 14.03GB path /dev/sda6
>>
>> The array is more of a for-fun and testing thing than a real world
>> example. I've simply combined two differently sized partitions on the
>> same disk together.
>>
>> So how much space is actually used now?
>>
>> On Fri, Mar 29, 2013 at 3:12 PM, Josef Bacik <jbacik@fusionio.com> wrote:
>> > On Fri, Mar 29, 2013 at 07:58:40AM -0600, Harald Glatt wrote:
>> >> I've run a balance before taking these meassurements:
>> >>
>> >> -> df -h reports 59G total space, 18G used, 7G free.
>> >> -> btrfs fi df / reports the following:
>> >> Data, RAID0: total=16.00GB, used=15.58GB
>> >> System, RAID1: total=32.00MB, used=4.00KB
>> >> System: total=4.00MB, used=0.00
>> >> Metadata, RAID1: total=6.00GB, used=974.36MB
>
>    OK, so you have 14.04+14.03 = 28.07 GiB allocated for immediate use
> on the disk.
>
>    Of that 28.07 GiB,
>
> - 16.00 GiB is assigned for RAID-0, and 15.58 GiB of that is actually
>   occupied by useful data.
>
> - 6.00*2 = 12.00 GiB is assigned for use by RAID-1 metadata, giving
>   6.00 GiB of usable metadata. 974.36 MiB of that contains actual
>   metadata.
>
> - 68.00 MiB (2*32.00 + 4.00) is the remainder, assigned to the system
>   chunks (actually the chunk tree), of which 4 KiB is actually useful
>   data.
>
>   Now, since you have RAID-0 data, the FS requires at least two
> devices to stripe across. So the best it can manage is to add a
> further 3.75 GiB of data chunks on each device (because /dev/sda6 has
> 3.75 GiB not allocated). 3.75 GiB on two deivces for RAID-0 is 2*3.75
> = 7.5 GiB reported free by df.
>
>    HTH,
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>      --- Gentlemen!  You can't fight here! This is the War Room! ---

From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: 800 GByte free, but "no space left"
Date: 07 Dec 2010 18:05:00 +0100
Message-ID: <BbRUmsly1uB@helmut.hullen.de>
References: <20101206182917.GF4273@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101206182917.GF4273@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 06.12.10:

>> Kernel 2.6.37-rc4:
>>
>> # btrfs filesystem df /srv/MM
>> Data, RAID0: total=2.39TB, used=2.37TB
>> System, RAID1: total=8.00MB, used=188.00KB
>> System: total=4.00MB, used=0.00
>> Metadata, RAID1: total=4.25GB, used=3.51GB
>> Metadata, DUP: total=1.00GB, used=2.33MB
>>
>> Hope it helps!

>    Yup. You've got what I've got(*). You have two different RAID
> types for metadata, which shouldn't happen (but does, due to a bug).

Fear I right that "balancing" tries to reduce the system to something  
like RAID1?

Viele Gruesse!
Helmut

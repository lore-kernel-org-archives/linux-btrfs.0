From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Mon, 07 May 2012 19:13:38 +0200
Message-ID: <4FA802C2.6010909@gmail.com>
References: <C8PCnlO9CXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8PCnlO9CXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 5/7/12 6:36 PM, Helmut Hullen wrote:
> Hallo, Hugo,
>
> Du meintest am 07.05.12:
>
>>> It's dead - R.I.P.
>
>>     Sorry to be the bearer of bad news. I don't think we can point the
>> finger at btrfs here.
>
> a) you know what to do with the bearer?
> b) I like such errors - completely independent, but simultaneously.
>
>>     It looks like you've lost most of your data -- losing a RAID-0
>> stripe across the whole FS isn't likely to have left much of it
>> intact.
>
> I'm just going back to ext4 - then one broken disk doesn't disturb the
> contents of the other disks.

?! If you use raid0 one broken disk will allways disturb the contents of 
the other disks, that is what raid0 does, no matter what filesystem you 
use. You could easly use btrfs with the "normal" or raid1 mode. Btrfs is 
still in development and often times you can blaim it for a corrupt 
filesystem, but in this case it's simply "raid0 -> 1 disc dies -> data 
are gone".

>
> The data is not very valuable - DVB video mpegs. Most of the files are
> repeated on and on.
>
>> If you've got the space (or the money to get it), mkfs.btrfs
>> -m raid1 -d raid1 would have saved you here.
>
> About 400 ... 500 Euro for backing up videos? Not necessary.
>
> (No: I don't count the minutes and hours working with the system ...)

>
>> [ Incidentally, thinking about it, the failure coming at a kernel
>>     upgrade could well be down to the additional stress of the
>>     power-down/reboot finally pushing a bad drive over the edge. ]
>
> Just now it's again an "open system"; I had to wobble the cables too ...
>
> Maybe the SATA-PCI-controller needs to be replaced too ...
>
> Viele Gruesse!
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

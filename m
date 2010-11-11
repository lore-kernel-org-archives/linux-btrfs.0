From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: labelling
Date: Thu, 11 Nov 2010 17:37:38 +0900
Message-ID: <4CDBAB52.60903@jp.fujitsu.com>
References: <B$fJyztT1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <B$fJyztT1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

(2010/11/11 16:48), Helmut Hullen wrote:
> Hallo, Hugo,
>
> Du meintest am 10.11.10:
>
>>>          findfs LABEL=MM2
>>>
>>> shows "/dev/sdd2" (the first partition)
>>>
>>>          file -s /dev/sdd2
>>>          file -s /dev/sdc3
>>>
>>> shows "LABEL=MM2" for both partitions
>
>>>          mount LABEL=MM2 /srv/MM
>>>
>>> doesn't work now, it tries to mount /dev/sdd2 and mourns.
>>>
>>>          mount /dev/sdd2 /srv/MM
>>>
>>> shows the same error message,
>
> # mount LABEL=MM2
> mount: wrong fs type, bad option, bad superblock on /dev/sdd2,
>         missing codepage or helper program, or other error
>         In some cases useful info is found in syslog - try
>         dmesg | tail  or so
>
> # mount /dev/sdd2
> mount: wrong fs type, bad option, bad superblock on /dev/sdd2,
>         missing codepage or helper program, or other error
>         In some cases useful info is found in syslog - try
>         dmesg | tail  or so
>
>>     What's the error message? What do you get in your kernel logs when
>> you do this? This should work, so there's something wrong, but it's
>> (probably) not to do with disk labels.
>
>>>          mount /dev/sdc3 /srv/MM
>>>
>>> (mounting the added partition) works fine, the whole space is
>>> available.
>
> That's the behaviour after a cold boot.
>
>          umount /srv/MM
>          mount LABEL=MM2 /srv/MM
>
> then works.
> Only the first try with LABEL or with "the other" device seems to fail.

I encountered the same problem, too.
Please try 'btrfsctl -a' before mounting.

Thanks.
Itoh



Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65408 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab2FERMV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 13:12:21 -0400
Received: by yhmm54 with SMTP id m54so4077767yhm.19
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jun 2012 10:12:20 -0700 (PDT)
Message-ID: <4FCE3DF1.2050106@webstarts.com>
Date: Tue, 05 Jun 2012 13:12:17 -0400
From: Jim <jim@webstarts.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, helmut@hullen.de,
        linux-btrfs@vger.kernel.org
Subject: Re: delete disk proceedure
References: <4FCE19D3.4090908@webstarts.com> <CAIin7n9CXB@helmut.hullen.de> <20120605170420.GJ15986@carfax.org.uk>
In-Reply-To: <20120605170420.GJ15986@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[sorry for the resend, signature again]
I am waiting for a window (later tonight) when I can try mounting the 
btrfs export.  Am I reading you guys correctly, that you think I should 
be deleting drives from the array?  Or is this a just in case?  Thanks.
Jim Maloney

On 06/05/2012 01:04 PM, Hugo Mills wrote:
> On Tue, Jun 05, 2012 at 06:19:00PM +0200, Helmut Hullen wrote:
>> Hallo, Jim,
>>
>> Du meintest am 05.06.12:
>>
>>> /dev/sda               11T  4.9T  6.0T  46% /btrfs
>>> [root@advanced ~]# btrfs fi show
>>> failed to read /dev/sr0
>>> Label: none  uuid: c21f1221-a224-4ba4-92e5-cdea0fa6d0f9
>>>           Total devices 12 FS bytes used 4.76TB
>>>           devid    6 size 930.99GB used 429.32GB path /dev/sdf
>>>           devid    5 size 930.99GB used 429.32GB path /dev/sde
>>>           devid    8 size 930.99GB used 429.32GB path /dev/sdh
>>>           devid    9 size 930.99GB used 429.32GB path /dev/sdi
>>>           devid    4 size 930.99GB used 429.32GB path /dev/sdd
>>>           devid    3 size 930.99GB used 429.32GB path /dev/sdc
>>>           devid   11 size 930.99GB used 429.08GB path /dev/sdk
>>>           devid    2 size 930.99GB used 429.32GB path /dev/sdb
>>>           devid   10 size 930.99GB used 429.32GB path /dev/sdj
>>>           devid   12 size 930.99GB used 429.33GB path /dev/sdl
>>>           devid    7 size 930.99GB used 429.32GB path /dev/sdg
>>>           devid    1 size 930.99GB used 429.09GB path /dev/sda
>>> Btrfs v0.19-35-g1b444cd
>>> df -h and btrfs fi show seem to be in good size agreement.  Btrfs was
>>> created as raid1 metadata and raid0 data.  I would like to delete the
>>> last 4 drives leaving 7T of space to hold 4.9T of data.  My plan
>>> would be to remove /dev/sdi, j, k, l one at a time.  After all are
>>> deleted run "btrfs fi balance /btrfs".
>> I'd prefer
>>
>>          btrfs device delete /dev/sdi
>>          btrfs filesystem balance /btrfs
>>          btrfs device delete /dev/sdj
>>          btrfs filesystem balance /btrfs
>>
>> etc. - after every "delete" its "balance" run.
>     That's not necessary. Delete will move the blocks from the device
> being removed into spare space on the other devices. The balance is
> unnecessary. (In fact, delete and balance share quite a lot of code)
>
>> That may take a lot of hours - I use the last lines of "dmesg" to
>> extrapolate the needed time (btrfs produces a message about every
>> minute).
>>
>> And you can't use the console from where you have started the "balance"
>> command. Therefore I wrap this command:
>>
>>        echo 'btrfs filesystem balance /btrfs' | at now
>     ... or just put it into the background with "btrfs bal start
> /mountpoint&". You know, like everyone else does. :)
>
>     Hugo.
>

-- 


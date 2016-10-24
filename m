Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:36102 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756858AbcJXLrY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 07:47:24 -0400
Received: by mail-qk0-f174.google.com with SMTP id o68so233034434qkf.3
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Oct 2016 04:47:23 -0700 (PDT)
Subject: Re: Drive Replacement
To: Peter Becker <floyd.net@gmail.com>, Hugo Mills <hugo@carfax.org.uk>,
        Gareth Pye <gareth@cerberos.id.au>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CA+WRLO-XY2aai7z8436yna14cjbRsPrWgHwxbcf5Kq_-7RENCQ@mail.gmail.com>
 <20161021220726.GC16645@carfax.org.uk>
 <CAEtw4r3H52Uazt_eq+wA4bLzW88mX4=7SgKoMrOTBOJV9etE-w@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b592dac3-9560-4b53-bb5d-0ee7cd241ece@gmail.com>
Date: Mon, 24 Oct 2016 07:47:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAEtw4r3H52Uazt_eq+wA4bLzW88mX4=7SgKoMrOTBOJV9etE-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-10-21 18:13, Peter Becker wrote:
> if you have >750 GB free you can simply remove one of the drives.
>
> btrfs device delete /dev/sd[x] /mnt
> #power off, replace device
> btrfs device add /dev/sd[y] /mnt
Make sure to balance afterwards if you do this, the new disk will be 
pretty much unused until you do.
>
> if not you can use an USB-SATA adapter or an eSata-Port and make the following:
>
> btrfs device add /dev/sd[y] /mnt
> btrfs device delete /dev/sd[x] /mnt
> #power off, replace device
I will comment that eSATA is vastly preferred to USB in this case (even 
a USB3.0 UAS device) as it is generally significantly more reliable 
(even if you are just using a eSATA to SATA cable and a power adapter 
for the drive).
>
> i avoid "btrfs device replace" because it's slower then add+delete
In my experience, this is only true if you add then delete (delete then 
add then re-balance will move a lot of data twice), and even then only 
if the device is more than about half full.  Device replace also has a 
couple of specific advantages:
* It lets you get an exact percentage completion, unlike add+delete. 
This is only updated every few seconds, and doesn't show an estimate of 
time remaining, but is still better than nothing.
* Device ID's remain the same.  This can be an advantage or a 
disadvantage, but it's usually a good thing in a case like this, because 
the mapping between device number and device node (and therefore 
specific disks) will remain constant, which makes tracking which 
physical device is failing a bit easier if you have consistent device 
enumeration for storage devices (which you almost certainly do if you're 
using SATA).
* It doesn't write any data on any other device except for superblocks 
and the basic metadata that describes the device layout.  This is 
important because it means that it's safer for data that isn't on the 
device being replaced, and it has less impact on other operations when 
doing a live replacement.
>
> and don't forget to update fstab !
Assuming that he doesn't change which SATA ports the devices are 
connected to, he shouldn't have to change anything in /etc/fstab.  Mount 
by UUID or LABEL will just work regardless, and mount by device node 
will continue to work as long as the same device nodes are used (which 
will be the case if he doesn't change anything else in the storage stack).
>
> 2016-10-22 0:07 GMT+02:00 Hugo Mills <hugo@carfax.org.uk>:
>> On Sat, Oct 22, 2016 at 09:03:16AM +1100, Gareth Pye wrote:
>>> I've got a BTRFS array that is of mixed size disks:
>>> 2x750G
>>> 3x1.5T
>>> 3x3T
>>> And it's getting fuller than I'd like. The problem is that adding
>>> disks is harder than one would like as the computer only has 8 sata
>>> ports. Is it viable to do the following to upgrade one of the disks?
>>>
>>> A) Take array offline
>>> B) DD the contents of one of the 750G drives to a new 3T drive
>>> C) Remove the 750G from the system
>>> D) btrfs scan
>>> E) Mount array
>>> F) Run a balance
>>>
>>> I know that not physically removing the old copy of the drive will
>>> cause massive issues, but if I do that everything should be fine
>>> right?
>>
>>    Yes. The one thing missing here is running
>>
>> # btrfs dev resize <devid>:max /mountpoint
>>
>> on the new device between steps E and F to allow the FS to use the
>> full amount of the device. Otherwise, it'll still be the same size as
>> the original.
>>
>>    Hugo.
>>
>> --
>> Hugo Mills             | Great films about cricket: Batsman Begins
>> hugo@... carfax.org.uk | starring Christian Bail
>> http://carfax.org.uk/  |
>> PGP: E2AB1DE4          |
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:36990 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751384AbdIKPLT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 11:11:19 -0400
Received: by mail-it0-f46.google.com with SMTP id o200so19639285itg.0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 08:11:19 -0700 (PDT)
Subject: Re: Please help with exact actions for raid1 hot-swap
To: Marat Khalili <mkh@rqc.ru>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Patrik Lundquist <patrik.lundquist@gmail.com>,
        Duncan <1i5t5.duncan@cox.net>
References: <01258ddc-1d34-4cc9-d668-21cbe88ab1d0@rqc.ru>
 <9D2B6B65-7DE9-4922-82DC-08BF3A3A2E09@rqc.ru>
 <CAA7pwKMuv69dsXZGXEASN=qarSv3tCYU=-k1sHquL_tm4FU0kw@mail.gmail.com>
 <bfaeaf8d-609d-924b-7389-b6c8733745a9@rqc.ru>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <9f53f866-bb99-72dd-7419-0728147732b0@gmail.com>
Date: Mon, 11 Sep 2017 11:11:01 -0400
MIME-Version: 1.0
In-Reply-To: <bfaeaf8d-609d-924b-7389-b6c8733745a9@rqc.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-11 09:16, Marat Khalili wrote:
> Patrik, Duncan, thank you for the help. The `btrfs replace start 
> /dev/sdb7 /dev/sdd7 /mnt/data` worked without a hitch (though I didn't 
> try to reboot yet, still have grub/efi/several mdadm partitions to copy).
> 
> It also worked much faster than mdadm would take, apparently only moving 
> 126GB used, not 2.71TB total.
This is why replace is preferred over add/remove.  The replace operation 
only copies exactly the data that is needed off of the old device, 
instead of copying the whole device like LVM and MD need to, or 
rewriting the whole filesystem (like add/remove does).

For what it's worth, if you can't use replace for some reason and have 
to use add and remove, it is more efficient to add the new device and 
then remove the old one, because it will require less data movement to 
get a properly balanced filesystem (removing a device is actually a 
balance operation that prevents writes to the device being removed).
> Interestingly, according to HDD lights it 
> mostly read from the remaining /dev/sda, not from replaced /dev/sdb 
> (which must be completely readable now according to smartctl -- 
> problematic sector got finally remapped after ~1day).
This is odd.  I was under the impression that replace preferentially 
reads from the device being replaced unless you tell it to avoid reading 
from said device.
> 
> It now looks like follows:
> 
>> $ sudo blkid /dev/sda7 /dev/sdb7 /dev/sdd7
>> /dev/sda7: LABEL="data" UUID="37d3313a-e2ad-4b7f-98fc-a01d815952e0" 
>> UUID_SUB="db644855-2334-4d61-a27b-9a591255aa39" TYPE="btrfs" 
>> PARTUUID="c5ceab7e-e5f8-47c8-b922-c5fa0678831f"
>> /dev/sdb7: PARTUUID="493923cd-9ecb-4ee8-988b-5d0bfa8991b3"
>> /dev/sdd7: LABEL="data" UUID="37d3313a-e2ad-4b7f-98fc-a01d815952e0" 
>> UUID_SUB="9c2f05e9-5996-479f-89ad-f94f7ce130e6" TYPE="btrfs" 
>> PARTUUID="178cd274-7251-4d25-9116-ce0732d2410b"
>> $ sudo btrfs fi show /dev/sdb7
>> ERROR: no btrfs on /dev/sdb7
>> $ sudo btrfs fi show /dev/sdd7
>> Label: 'data'  uuid: 37d3313a-e2ad-4b7f-98fc-a01d815952e0
>>     Total devices 2 FS bytes used 108.05GiB
>>     devid    1 size 2.71TiB used 131.03GiB path /dev/sda7
>>     devid    2 size 2.71TiB used 131.03GiB path /dev/sdd7
> Does this mean:
> * I should not be afraid to reboot and find /dev/sdb7 mounted again?
> * I will not be able to easily mount /dev/sdb7 on a different computer 
> to do some tests?
This depends.  I don't remember if the replace command wipes the 
super-block on the old device after the replace completes or not.  If it 
does not, then you can't safely mount the filesystem while that device 
is still in the system, but can transfer it to another system and mount 
it degraded (probably, not a certainty).  if it does, then you can 
safely keep the device in the system, but won't be able to move it to 
another computer and get data off of it.  Regardless of which is the 
case, you won't see /dev/sdb7 mounted as a separate filesystem when you 
reboot.
> 
> Also, although /dev/sdd7 is much larger than /dev/sdb7 was, `btrfs fi 
> show` still displays it as 2.71TiB, why?
`btrfs replace` is functionally equivalent to using dd to copy the 
contents of the device being replaced to the new device, albeit a bit 
smarter (as mentioned above).  This means in particular that it does not 
resize the filesystem (although i think I saw some discussion and 
possibly patches to handle that with a command-line option).

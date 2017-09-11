Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:36537 "EHLO
        smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751253AbdIKNRD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 09:17:03 -0400
Received: from smtp7.relay.ord1c.emailsrvr.com (localhost [127.0.0.1])
        by smtp7.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id 31512A022A
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 09:17:03 -0400 (EDT)
Received: from smtp97.ord1d.emailsrvr.com (relay.ord1c.rsapps.net [172.28.255.120])
        by smtp7.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTPS id 2AD51A0217
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 09:17:03 -0400 (EDT)
Subject: Re: Please help with exact actions for raid1 hot-swap
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Patrik Lundquist <patrik.lundquist@gmail.com>,
        Duncan <1i5t5.duncan@cox.net>
References: <01258ddc-1d34-4cc9-d668-21cbe88ab1d0@rqc.ru>
 <9D2B6B65-7DE9-4922-82DC-08BF3A3A2E09@rqc.ru>
 <CAA7pwKMuv69dsXZGXEASN=qarSv3tCYU=-k1sHquL_tm4FU0kw@mail.gmail.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <bfaeaf8d-609d-924b-7389-b6c8733745a9@rqc.ru>
Date: Mon, 11 Sep 2017 16:16:50 +0300
MIME-Version: 1.0
In-Reply-To: <CAA7pwKMuv69dsXZGXEASN=qarSv3tCYU=-k1sHquL_tm4FU0kw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patrik, Duncan, thank you for the help. The `btrfs replace start 
/dev/sdb7 /dev/sdd7 /mnt/data` worked without a hitch (though I didn't 
try to reboot yet, still have grub/efi/several mdadm partitions to copy).

It also worked much faster than mdadm would take, apparently only moving 
126GB used, not 2.71TB total. Interestingly, according to HDD lights it 
mostly read from the remaining /dev/sda, not from replaced /dev/sdb 
(which must be completely readable now according to smartctl -- 
problematic sector got finally remapped after ~1day).

It now looks like follows:

> $ sudo blkid /dev/sda7 /dev/sdb7 /dev/sdd7
> /dev/sda7: LABEL="data" UUID="37d3313a-e2ad-4b7f-98fc-a01d815952e0" 
> UUID_SUB="db644855-2334-4d61-a27b-9a591255aa39" TYPE="btrfs" 
> PARTUUID="c5ceab7e-e5f8-47c8-b922-c5fa0678831f"
> /dev/sdb7: PARTUUID="493923cd-9ecb-4ee8-988b-5d0bfa8991b3"
> /dev/sdd7: LABEL="data" UUID="37d3313a-e2ad-4b7f-98fc-a01d815952e0" 
> UUID_SUB="9c2f05e9-5996-479f-89ad-f94f7ce130e6" TYPE="btrfs" 
> PARTUUID="178cd274-7251-4d25-9116-ce0732d2410b"
> $ sudo btrfs fi show /dev/sdb7
> ERROR: no btrfs on /dev/sdb7
> $ sudo btrfs fi show /dev/sdd7
> Label: 'data'  uuid: 37d3313a-e2ad-4b7f-98fc-a01d815952e0
>     Total devices 2 FS bytes used 108.05GiB
>     devid    1 size 2.71TiB used 131.03GiB path /dev/sda7
>     devid    2 size 2.71TiB used 131.03GiB path /dev/sdd7
Does this mean:
* I should not be afraid to reboot and find /dev/sdb7 mounted again?
* I will not be able to easily mount /dev/sdb7 on a different computer 
to do some tests?

Also, although /dev/sdd7 is much larger than /dev/sdb7 was, `btrfs fi 
show` still displays it as 2.71TiB, why?

--

With Best Regards,
Marat Khalili


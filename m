Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:52752 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaLRRcq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 12:32:46 -0500
Received: by mail-la0-f41.google.com with SMTP id hv19so1397671lab.14
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 09:32:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141218153544.GB25267@carfax.org.uk>
References: <CAN6BF2LwtJkjt1qB6C-wcVxizGj4bufvojR29QX5e7JJ_h-xXA@mail.gmail.com>
	<20141218153544.GB25267@carfax.org.uk>
Date: Fri, 19 Dec 2014 01:32:44 +0800
Message-ID: <CAN6BF2+32GNsVqRSMvzfWyLDsPPZ1FZz0k5ef+ZL6XLbXnwWjQ@mail.gmail.com>
Subject: Re: Extra info
From: Daniele Testa <daniele.testa@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Daniele Testa <daniele.testa@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am running latest Debian stable. However, I used backports to update
the kernel to 3.16.

root@s4 /opt/drives/ssd # uname -a
Linux s4.podnix.com 3.16.0-0.bpo.4-amd64 #1 SMP Debian
3.16.7-ckt2-1~bpo70+1 (2014-12-08) x86_64 GNU/Linux

root@s4 /opt/drives/ssd # btrfs --version
Btrfs v3.14.1

It still reports over-use, so I am running a defrag on the file:

root@s4 /opt/drives/ssd # btrfs filesystem defragment
/opt/drives/ssd/disk_208.img

But I see it slowly eats even more disk space durring the defrag. I
had about 7GB before. When it went down close
to 1GB, I cancelled it as I'm afraid it will corrupt the file if it
runs out of space.

Do you know how btrfs behaves if it runs out of space durring a
defrag? Any other ideas how I can solve it?

Regards,
Daniele


2014-12-18 23:35 GMT+08:00 Hugo Mills <hugo@carfax.org.uk>:
> On Thu, Dec 18, 2014 at 11:02:34PM +0800, Daniele Testa wrote:
>> Sorry, did not read the guidelines correctly. Here comes more info:
>>
>> root@s4 /opt/drives/ssd # uname -a
>> Linux s4.podnix.com 3.2.0-4-amd64 #1 SMP Debian 3.2.46-1+deb7u1 x86_64 GNU/Linux
>
>    This is your problem. I think the difficulty is that writes into
> the middle of an extent didn't split the extent and allow the
> overwritten area to be reclaimed, so the whole extent still takes up
> space.
>
>    IIRC, josef fixed this about 18 months ago. You should upgrade your
> kernel to something that isn't written in cueniform (like 3.18, say),
> and defrag the file in question. I think that should fix the problem.
>
>> root@s4 /opt/drives/ssd # btrfs --version
>> Btrfs Btrfs v0.19
>
>    This is also an antique, and probably needs an upgrade too
> (although it's less critical than the kernel).
>
>    Hugo.
>
>> root@s4 /opt/drives/ssd # btrfs fi show
>> Label: none  uuid: 752ed11b-defc-4717-b4c9-a9e08ad64ba6
>>         Total devices 1 FS bytes used 404.74GB
>>         devid    1 size 410.50GB used 410.50GB path /dev/md3
>>
>> Regards,
>> Daniele
>
> --
> Hugo Mills             | Python is executable pseudocode; perl is executable
> hugo@... carfax.org.uk | line-noise.
> http://carfax.org.uk/  |
> PGP: 65E74AC0          |                                            Ben Burton

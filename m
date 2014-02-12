Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:58602 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaBLKp4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 05:45:56 -0500
Received: by mail-lb0-f172.google.com with SMTP id c11so7050760lbj.3
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Feb 2014 02:45:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140212102613.GN6490@carfax.org.uk>
References: <CAEhsiNw3hLSu8zPw44ndR1xQ-fjFrzaSCw3GDa=1vhCY3BypnA@mail.gmail.com>
 <20140212102613.GN6490@carfax.org.uk>
From: Jakob Truelsen <antialize@gmail.com>
Date: Wed, 12 Feb 2014 11:45:34 +0100
Message-ID: <CAEhsiNyLGFc0GWFH5Hh7hZ1c9WzX7JO7quuud9APB0k3=4yu6w@mail.gmail.com>
Subject: Re: No space left on device
To: Hugo Mills <hugo@carfax.org.uk>, Jakob Truelsen <antialize@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi and thanks for the quick reply. Have remounted the filesystem with
enospc_debug, and run the rebalance you suggested, with the trance
below. So perhaps the next step is for me to figure out how to take a
metadata image and send it to josef (perhaps with a box of tissues)

/Jakob


[jakobt@soda ~]$ mount
...
/dev/sda on /data type btrfs (rw,relatime,nospace_cache,enospc_debug)

[jakobt@soda ~]$ sudo  btrfs balance start -dusage=0 /data
ERROR: error during balancing '/data' - No space left on device
There may be more info in syslog - try dmesg | tail

[jakobt@soda ~]$ touch /data/jakobt/monkey
touch: cannot touch ‘/data/jakobt/monkey’: No space left on device

[jakobt@soda ~]$ dmesg | tail -n3
[1117530.870965] btrfs: device label Data devid 1 transid 47091 /dev/sda
[1117573.087580] btrfs: 426 enospc errors during balance
[1117642.002437] btrfs: 426 enospc errors during balance


On Wed, Feb 12, 2014 at 11:26 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Wed, Feb 12, 2014 at 10:51:12AM +0100, Jakob Truelsen wrote:
>> Hello. I am experiencing "No space left on device" with a btrfs file
>> system, yet I cannot seem to find any exhausted resource. Could some
>> resource I do not know about be exhausted, or is this caused by
>> something else. Below is a trace of information that might be usefull,
>> please let me know if there is anything I can do to resolve the issue.
>>
>> /Jakob
>>
>> [jakobt@soda ~]$ uname -a
>> Linux soda 3.12.8-1-ARCH #1 SMP PREEMPT Thu Jan 16 09:16:34 CET 2014
>> x86_64 GNU/Linux
>
>    Were you using this kernel when the problem happened?
>
>> [jakobt@soda ~]$ btrfs --version
>> Btrfs v3.12
>>
>> [jakobt@soda ~]$ mount
>> ...
>> /dev/sda on /data type btrfs (rw,relatime,nospace_cache)
>>
>> [jakobt@soda ~]$ df /data
>> Filesystem     1K-blocks     Used Available Use% Mounted on
>> /dev/sdb2       76594224 49247368  23433028  68% /
>>
>> [jakobt@soda ~]$ btrfs filesystem df /data
>> Data, single: total=1.82TiB, used=518.04GiB
>> System, DUP: total=8.00MiB, used=204.00KiB
>> System, single: total=4.00MiB, used=0.00
>> Metadata, DUP: total=1.00GiB, used=767.70MiB
>
>    ^^^ This is your problem, most likely in conjunction with all the
> space on the device being allocated. Being a copy-on-write filesystem,
> btrfs needs free space to make any update. If it doesn't have that
> free space, you get "No space left on device". You typically need
> somewhere around 0.5-1 GiB of headroom in metadata for normal
> operation, so I'm surprised you got this far. :)
>
>    The FS should normally allocate more metadata space as it needs it,
> but because (I think) your data allocation has taken up all the
> available space on the device, there's no way for it to add more.
>
>> Metadata, single: total=8.00MiB, used=0.00
>
>> [jakobt@soda ~]$ touch /data/jakobt/hat
>> touch: cannot touch ‘/data/jakobt/hat’: No space left on device
>>
>> [jakobt@soda ~]$ sudo btrfs fi balance start /data
>> ERROR: error during balancing '/data' - No space left on device
>> There may be more info in syslog - try dmesg | tail
>
>    Try:
>
> btrfs balance start -dusage=0 /data
>
> which should go looking for entirely unused block groups and reclaim
> those. (If you don't use the -dusage= parameter, it will try to
> balance everything, which takes a long time).
>
>> [jakobt@soda ~]$ dmesg | grep tail -n 2
>> [1113177.878157] btrfs: device label Data devid 1 transid 44784 /dev/sda
>> [1113507.641752] btrfs: 1866 enospc errors during balance
>
>    Although, that said... it looks like it's tried every block group
> and failed with each one, so my suggestion above may not work in this
> instance.
>
>    Let us know what happens with the balance command above anyway
> (dmesg output is useful information at this point). If that doesn't
> help, then we'll probably need to take a metadata image and throw it
> in josef's direction, where he will start crying at having to deal
> with enospc problems again. :)
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>          --- If you're not part of the solution, you're part ---
>                            of the precipiate.

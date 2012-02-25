From: Arne Jansen <sensille@gmx.net>
Subject: Re: 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
Date: Sat, 25 Feb 2012 09:14:37 +0100
Message-ID: <4F48986D.4090703@gmx.net>
References: <201112171833.34720.Martin@lichtvoll.de> <201201211149.53403.Martin@lichtvoll.de> <201201211219.40433.Martin@lichtvoll.de> (sfid-20120121_123006_768632_E7FD03DC) <201202241651.57233.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201202241651.57233.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Martin,

I just sent 2 patches to the list. Could you please test if these
fix your problem with scrub?

Thanks,
Arne


On 02/24/12 16:51, Martin Steigerwald wrote:
> Am Samstag, 21. Januar 2012 schrieb Martin Steigerwald:
>> Am Samstag, 21. Januar 2012 schrieb Martin Steigerwald:
>>> I still have this with 3.2.0-1-pae - which is a debian kernel based
>>> on 3.2.1.
>>>
>>> When I do btrfs scrub start / the machine locks immediately up hard=
=2E
>>>
>>> Then usually on next boot it stops on space_cache enabled message,
>>> but not  the one for /, but the one for /home which is mounted
>>> later.
>>>
>>> When I then boot with 3.1 it works. BTRFS redos the space_cache the=
n
>>> while  the machine takes ages to boot - I mean ages - 10 minutes ti=
ll
>>> KDM prompt is no problem there.
>>
>> I now tested scrubbing /home which is a different BTRFS filesystem o=
n
>> the same machine.
>>
>> Then the scrub is started, scrub status tells me so, but nothing
>> happens, no block in/out activity in vmstat, no CPU related activity
>> in top.
>>
>> btrfs scrub cancel then hangs, but not the complete machine, only th=
e
>> process.
>>
>> I had this once on my T520 with the internal Intel SSD 320 as well. =
The
>> other time it worked.
>>
>> Well maybe that is due to BTRFS doing something else on my T23 now:
>>
>> deepdance:~>  ps aux | grep ino-cache | grep -v grep
>> root      1992  5.5  0.0      0     0 ?        D    12:15   0:09
>> [btrfs- ino-cache]
>>
>> Hmmm, so I just let it sit for a while, maybe eventually it will scr=
ub
>> /home.
>>
>> At least it doesn=C2=B4t lock up hard, so there might really be some=
thing
>> strange with /.
>
> FWIW a btrfs filesystem balance / does work. After this a btrfs scrub=
 start
> / still locks the kernel.
>
> Anyway, I might be waiting for the new fsck and try it on the partiti=
on.
> Or redo the filesystem from scratch, cause I think trying to debug th=
is
> will take way more time.
>
> I might also as well redo /home as well. Two fresh 3.2 or 3.3 kernel =
BTRFS
> and see whether they work better.
>

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

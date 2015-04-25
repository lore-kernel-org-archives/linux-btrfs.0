Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fmxout02.freemail.hu ([195.228.245.72]:46945 "EHLO
	fmxout02.freemail.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbbDYD4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 23:56:54 -0400
Date: Sat, 25 Apr 2015 05:56:50 +0200 (CEST)
From: None None <whocares0101@freemail.hu>
Subject: Re: btrfs balance start -dconvert=raid5 on raid1 not converting to raid5
To: Omar Sandoval <osandov@osandov.com>
cc: linux-btrfs@vger.kernel.org
In-Reply-To: <20150425030040.GA4756@mew>
Message-ID: <freemail.20150425055650.78792.2@fmxmldata05.freemail.hu>
MIME-Version: 1.0
Content-Type: TEXT/plain; CHARSET=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 
Omar Sandoval <osandov@osandov.com> írta:
>On Sat, Apr 25, 2015 at 04:47:31AM +0200, None None wrote:
>> I tried to convert my btrfs from raid1 to raid5 but after the balance command it&#39;s still raid1.
>> Also for raid56 the wiki says "Parity may be inconsistent after a crash (the "write hole")"
>> does that mean if I convert metadata to raid5/6 and the parity becomes inconsistent my btrfs will be lost?
>> 
>> Kernel is v4.0 on debian/sid
>> The filesystem was created with nodesize 8k if I remember correctly
>> Mount options for /srv/ noatime,nodev,space_cache,subvol=@
>> No snapshots and only a few subvolumes
>> Free space is ~450GiB
>> 
>> To convert the data profile to raid5 (with btrfs-progs v3.17) I did
>> btrfs balance start -v -dconvert=raid5 /srv/
>> but after the the command was done (after 10 days)
>> btrfs fi sho /srv/
>> still shows data as raid1, free space is also what would be expected for raid1
>> no errors, no problems, no raid5
>> 
>> 
>> So I compiled the newer btrfs-progs v3.19.1 and did (I also tried raid6, same result still raid1)
>> btrfs balance start -v -dconvert=raid5 -dlimit=1 /srv/
>> Dumping filters: flags 0x1, state 0x0, force is off
>>   DATA (flags 0x120): converting, target=128, soft is off, limit=1
>> Done, had to relocate 1 out of 12071 chunks
>> 
>> dmesg shows only this, no errors
>> [170427.207107] BTRFS info (device sdj): relocating block group 65294058848256 flags 17
>> [170461.591056] BTRFS info (device sdj): found 129 extents
>> [170476.270765] BTRFS info (device sdj): found 129 extents
>> 
>> btrfs fi sho /srv/
>> shows all data as raid1
>> 
>> 
>> btrfs fi sho
>> Label: none  uuid: xxxxxxxx-xxxx-xxxx-xxxxxxxxxxxxxxxxx
>>         Total devices 9 FS bytes used 11.78TiB
>>         devid    1 size 2.73TiB used 2.62TiB path /dev/sdh
>>         devid    2 size 2.73TiB used 2.62TiB path /dev/sdj
>>         devid    3 size 2.73TiB used 2.62TiB path /dev/sdg
>>         devid    4 size 2.73TiB used 2.62TiB path /dev/sdi
>>         devid    5 size 2.73TiB used 2.62TiB path /dev/sdf
>>         devid    6 size 2.73TiB used 2.62TiB path /dev/sde
>>         devid    7 size 2.73TiB used 2.62TiB path /dev/sdc
>>         devid    9 size 2.73TiB used 2.62TiB path /dev/sdd
>>         devid   10 size 2.73TiB used 2.62TiB path /dev/sda
>> 
>> btrfs-progs v3.19.1
>> 
>> 
>> btrfs fi df /srv/
>> Data, RAID1: total=11.76TiB, used=11.76TiB
>> System, RAID1: total=32.00MiB, used=1.62MiB
>> Metadata, RAID1: total=17.06GiB, used=14.85GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>This is a known bug in v4.0. I sent in a patch [1] to revert the commit
>that caused the regression, but it didn&#39;t get any response. You could
>apply that or just revert 2f0810880f08 ("btrfs: delete chunk allocation
>attemp when setting block group ro") to fix your problem for now.
>
>[1]: https://patchwork.kernel.org/patch/6238111/
>
>-- 
>Omar

I'll give it a try, thanks for the fast reply.

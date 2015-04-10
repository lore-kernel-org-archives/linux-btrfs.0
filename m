Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35126 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbbDJHRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Apr 2015 03:17:13 -0400
Received: by widdi4 with SMTP id di4so117821320wid.0
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Apr 2015 00:17:12 -0700 (PDT)
Message-ID: <552778F6.8040604@lianse.eu>
Date: Fri, 10 Apr 2015 09:17:10 +0200
From: =?UTF-8?B?QW5kcsOpLVNlYmFzdGlhbiBMaWViZQ==?= <andre@lianse.eu>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [solved] Re: btrfs filesystem resize <ID>:max not working
References: <5526A2D0.2030103@lianse.eu> <CAJCQCtS24gzNgOuUgea5_eT-7UDP4fDNMGAxfR5fcy6btK2FQw@mail.gmail.com>
In-Reply-To: <CAJCQCtS24gzNgOuUgea5_eT-7UDP4fDNMGAxfR5fcy6btK2FQw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey all,


On 04/09/2015 09:49 PM, Chris Murphy wrote:
> On Thu, Apr 9, 2015 at 10:03 AM, André-Sebastian Liebe <andre@lianse.eu> wrote:
>> Hey list,
>>
>> I've got a problem with resizing a multi drive filesystem.
>> I had a 5 disk array of 4TB drives. Then I added a 5th (6TB) drive to
>> the array and replaced one of the 4TB ones with a 6TB drive.
> You did device add, device delete, then fi resize? It should work but
> it's better to use btrfs replace start for this sort of operation
> since it does all of that in one step.
I did a device replace.


>> As you can
>> see in my `btrfs fi sh` output below, my newly added drive (ID=6) has
>> the expected size of 5.46TiB, but my replaced drive (ID=4) won't show up
>> as 6TB as expected. Neither a `btrfs fi res max /data/pool0` nor a
>> `btrfs fi res 4:max /data/pool0` had any effect.
>>
>> Any suggestions how to reclaim the 2TB free space of drive 4?
> Not sure, this has always worked for me in the past, online. You could
> try unmounting and doing a btrfs dev scan, remounting, and then
> retrying the command. There's nothing in dmesg? There should be
> something there whether it succeeds or fails.
Okay, I did a scrub, unmounted it, scanned for devices, remounted it and
redid the resize for drive 4. This time I got a syslog entry showing the
start of the resize and  about 5 minutes later the command finished
without an error.

Konsole output
> Apr 10 08:58:39 apc01 kernel: BTRFS info (device sdd): resizing devid 4
> Apr 10 08:58:39 apc01 kernel: BTRFS: new size for /dev/sdg is
6001175126016

`btrfs fi sh` finally shows both of my 6TB drives

Konsole output
> # btrfs fi sh
> Label: 'apc01_pool0'  uuid: 066141c6-16ca-4a30-b55c-e606b90ad0fb
>        Total devices 6 FS bytes used 23.43TiB
>        devid    1 size 3.64TiB used 3.61TiB path /dev/sdd
>        devid    2 size 3.64TiB used 3.60TiB path /dev/sdc
>        devid    3 size 3.64TiB used 3.60TiB path /dev/sde
>        devid    4 size 5.46TiB used 3.60TiB path /dev/sdg
>        devid    5 size 3.64TiB used 3.61TiB path /dev/sdb
>        devid    6 size 5.46TiB used 5.43TiB path /dev/sdf



Thanks for the hint!

Cheers
André


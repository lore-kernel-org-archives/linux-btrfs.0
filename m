Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f50.google.com ([209.85.216.50]:46817 "EHLO
	mail-vn0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbbGNXUP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 19:20:15 -0400
Received: by vnbg190 with SMTP id g190so2710465vnb.13
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2015 16:20:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55A50DBF.1080602@gmail.com>
References: <55A4F74D.9000305@gmail.com>
	<55A50DBF.1080602@gmail.com>
Date: Tue, 14 Jul 2015 17:20:14 -0600
Message-ID: <CAJCQCtSEk3cfwWTyzzQft1+eHcUDm_zFiBpYZM15rhZBzF3U2A@mail.gmail.com>
Subject: Re: BTRFS raid6 unmountable after a couple of days of usage.
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 14, 2015 at 7:25 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-07-14 07:49, Austin S Hemmelgarn wrote:
>>
>> So, after experiencing this same issue multiple times (on almost a dozen
>> different kernel versions since 4.0) and ruling out the possibility of it
>> being caused by my hardware (or at least, the RAM, SATA controller and disk
>> drives themselves), I've decided to report it here.
>>
>> The general symptom is that raid6 profile filesystems that I have are
>> working fine for multiple weeks, until I either reboot or otherwise try to
>> remount them, at which point the system refuses to mount them.
>>
>> I'm currently using btrfs-progs v4.1 with kernel 4.1.2, although I've been
>> seeing this with versions of both since 4.0.
>>
>> Output of 'btrfs fi show' for the most recent fs that I had this issue
>> with:
>>          Label: 'altroot'  uuid: 86eef6b9-febe-4350-a316-4cb00c40bbc5
>>         Total devices 4 FS bytes used 9.70GiB
>>         devid    1 size 24.00GiB used 6.03GiB path
>> /dev/mapper/vg-altroot.0
>>         devid    2 size 24.00GiB used 6.01GiB path
>> /dev/mapper/vg-altroot.1
>>         devid    3 size 24.00GiB used 6.01GiB path
>> /dev/mapper/vg-altroot.2
>>         devid    4 size 24.00GiB used 6.01GiB path
>> /dev/mapper/vg-altroot.3
>>
>>          btrfs-progs v4.1
>>
>> Each of the individual LVS that are in the FS is just a flat chunk of
>> space on a separate disk from the others.
>>
>> The FS itself passes btrfs check just fine (no reported errors, exit value
>> of 0), but the kernel refuses to mount it with the message 'open_ctree
>> failed'.
>>
>> I've run btrfs chunk recover and attached the output from that.
>>
>> Here's a link to an image from 'btrfs image -c9 -w':
>> https://www.dropbox.com/s/pl7gs305ej65u9q/altroot.btrfs.img?dl=0
>> (That link will expire in 30 days, let me know if you need access to it
>> beyond that).
>>
>> The filesystems in question all see relatively light but consistent usage
>> as targets for receiving daily incremental snapshots for on-system backups
>> (and because I know someone will mention it, yes, I do have other backups of
>> the data, these are just my online backups).
>>
> Further updates, I just tried mounting the filesystem from the image above
> again, this time passing device= options for each device in the FS, and it
> seems to be working fine now.  I've tried this with the other filesystems
> however, and they still won't mount.
>

And it's the same message with the usual suspects: recovery,
ro,recovery ? How about degraded even though it's not degraded? And
what about 'btrfs rescue zero-log' ?

Of course it's weird that btrfs check doesn't complain, but mount
does. I don't understand that, so it's good you've got an image. If
either recovery or zero-log fix the problem, my understanding is this
suggests hardware did something Btrfs didn't expect.

What about 'btrfs check --check-data-csum" which should act similar to
a read-only scrub (different output though)? Hmm, nah. The thing is
the failure to mount is failing on some aspect of metadata, not data.
So the fact that check (on metadata) passes but mount fails is a bug
somewhere...

-- 
Chris Murphy

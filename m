Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:38418 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbbHKR4Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 13:56:24 -0400
Received: by igfj19 with SMTP id j19so77569549igf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2015 10:56:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ9kxpuQD3k-rO84O+0jRpiWbCJAUdog+2_Da6EK5yGsQ@mail.gmail.com>
References: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
	<CAJCQCtS=v+T-qGFLeaELn7Bt+Mb8ViK+8+YgontAE=1ucAnWZg@mail.gmail.com>
	<CAK7bmU_d3RTU4HZVHB9Z7ZAOpQ8C-wZn7WpvYsJaXiGDJki7fg@mail.gmail.com>
	<CAJCQCtQ9kxpuQD3k-rO84O+0jRpiWbCJAUdog+2_Da6EK5yGsQ@mail.gmail.com>
Date: Tue, 11 Aug 2015 13:56:23 -0400
Message-ID: <CAK7bmU9X8cvPs2sn3eZRaOowoT2H5jthpessWMQSVgvojjJ5EA@mail.gmail.com>
Subject: Re: Damaged filesystem, can read, can't repair, error says to contact devs
From: Timothy Normand Miller <theosib@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 11, 2015 at 12:21 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Mon, Aug 10, 2015 at 7:23 PM, Timothy Normand Miller
> <theosib@gmail.com> wrote:
>> On Mon, Aug 10, 2015 at 6:52 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
>>> - complete dmesg for the failed mount
>>
>> It really doesn't say much.  I have things like this:
>> [    8.643535] BTRFS info (device sdc): disk space caching is enabled
>> [    8.643789] BTRFS: failed to read the system array on sdc
>> [    8.706062] BTRFS: open_ctree failed
>> [    8.707124] BTRFS info (device sdc): disk space caching is enabled
>> [    8.710924] BTRFS: failed to read the system array on sdc
>> [    8.766080] BTRFS: open_ctree failed
>> [    8.766903] BTRFS info (device sdc): setting nodatacow, compression disabled
>> [    8.766905] BTRFS info (device sdc): disk space caching is enabled
>> [    8.767152] BTRFS: failed to read the system array on sdc
>> [    8.936019] BTRFS: open_ctree failed
>> [    8.936906] BTRFS info (device sdc): disk space caching is enabled
>> [    8.939922] BTRFS: failed to read the system array on sdc
>> [    8.995984] BTRFS: open_ctree failed
>> [    8.996796] BTRFS info (device sdc): disk space caching is enabled
>> [    8.997093] BTRFS: failed to read the system array on sdc
>> [    9.125936] BTRFS: open_ctree failed
>
> It looks like there's not enough redundancy remaining to mount and in
> such a case there's really not much to be done.
>
> I don't see nodatacow in your fstab, so I don't know why that's
> happening. That means no checksumming for data.

Sorry.  I was dumb.  I only showed you the entry for what I was trying
to mount manually.  I have subvolumes, and this is what is in my
fstab:

UUID=ecdff84d-b4a2-4286-a1c1-cd7e5396901c /home btrfs
compress=lzo,noatime,space_cache,subvol=home 0 2
UUID=ecdff84d-b4a2-4286-a1c1-cd7e5396901c /mnt/btrfs btrfs
compress=lzo,noatime,space_cache 0 2
UUID=ecdff84d-b4a2-4286-a1c1-cd7e5396901c /mnt/vms btrfs
noatime,nodatacow,space_cache,subvol=vms 0 2
UUID=ecdff84d-b4a2-4286-a1c1-cd7e5396901c /mnt/oldfiles btrfs
compress=lzo,noatime,space_cache,subvol=oldfiles 0 2
UUID=ecdff84d-b4a2-4286-a1c1-cd7e5396901c /mnt/backup btrfs
compress=lzo,noatime,space_cache,subvol=backup 0 2


>
>
>>
>> Also, when I manually try to mount, I get things like this:
>>
>> # mount /mnt/btrfs
>> mount: wrong fs type, bad option, bad superblock on /dev/sdc,
>>        missing codepage or helper program, or other error
>
> Have you tried to mount with -o degraded?

Ooh!  I can do that!

Mounting ro,degraded, I see this:

[94197.902443] BTRFS info (device sdc): allowing degraded mounts
[94197.902448] BTRFS info (device sdc): disk space caching is enabled
[94198.240621] BTRFS: bdev (null) errs: wr 1724, rd 305, flush 45,
corrupt 0, gen 2

Mounting rw,degraded, I see this:

[94312.091613] BTRFS info (device sdc): allowing degraded mounts
[94312.091618] BTRFS info (device sdc): disk space caching is enabled
[94312.194513] BTRFS: bdev (null) errs: wr 1724, rd 305, flush 45,
corrupt 0, gen 2
[94319.824563] BTRFS: checking UUID tree


>
>
>
>> Well, if I get something lengthy, I'll attach it to my bug report.
>> Did the information I reported help at all?
>
> The entire dmesg is still useful because it should show libata errors
> if these aren't fully failed drives. So you should file a bug and
> include, literally, the entire unedited dmesg.

Alright, I'll do that.  Thanks!

>
>
> --
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project

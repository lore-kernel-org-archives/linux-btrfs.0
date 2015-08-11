Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:36159 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbbHKTrZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 15:47:25 -0400
Received: by vkbf67 with SMTP id f67so17306177vkb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2015 12:47:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK7bmU9X8cvPs2sn3eZRaOowoT2H5jthpessWMQSVgvojjJ5EA@mail.gmail.com>
References: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
	<CAJCQCtS=v+T-qGFLeaELn7Bt+Mb8ViK+8+YgontAE=1ucAnWZg@mail.gmail.com>
	<CAK7bmU_d3RTU4HZVHB9Z7ZAOpQ8C-wZn7WpvYsJaXiGDJki7fg@mail.gmail.com>
	<CAJCQCtQ9kxpuQD3k-rO84O+0jRpiWbCJAUdog+2_Da6EK5yGsQ@mail.gmail.com>
	<CAK7bmU9X8cvPs2sn3eZRaOowoT2H5jthpessWMQSVgvojjJ5EA@mail.gmail.com>
Date: Tue, 11 Aug 2015 13:47:24 -0600
Message-ID: <CAJCQCtQvkOr0WSOa_hUTCY72esF1euc_qz_FAEVEZ4c4cc+_dQ@mail.gmail.com>
Subject: Re: Damaged filesystem, can read, can't repair, error says to contact devs
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 11, 2015 at 11:56 AM, Timothy Normand Miller
<theosib@gmail.com> wrote:
> On Tue, Aug 11, 2015 at 12:21 AM, Chris Murphy <lists@colorremedies.com> wrote:

>> I don't see nodatacow in your fstab, so I don't know why that's
>> happening. That means no checksumming for data.
>
> Sorry.  I was dumb.  I only showed you the entry for what I was trying
> to mount manually.  I have subvolumes, and this is what is in my
> fstab:
>
> UUID=ecdff84d-b4a2-4286-a1c1-cd7e5396901c /home btrfs
> compress=lzo,noatime,space_cache,subvol=home 0 2
> UUID=ecdff84d-b4a2-4286-a1c1-cd7e5396901c /mnt/btrfs btrfs
> compress=lzo,noatime,space_cache 0 2
> UUID=ecdff84d-b4a2-4286-a1c1-cd7e5396901c /mnt/vms btrfs
> noatime,nodatacow,space_cache,subvol=vms 0 2
> UUID=ecdff84d-b4a2-4286-a1c1-cd7e5396901c /mnt/oldfiles btrfs
> compress=lzo,noatime,space_cache,subvol=oldfiles 0 2
> UUID=ecdff84d-b4a2-4286-a1c1-cd7e5396901c /mnt/backup btrfs
> compress=lzo,noatime,space_cache,subvol=backup 0 2

Huh. I thought nodatacow applies to an entire volume only, not per
subvolume unless you use chattr +C (in which case it can be per
subvolume, directory or per file). I could be confused, but I think
you have mutually exclusive mount options.


>> Have you tried to mount with -o degraded?
>
> Ooh!  I can do that!
>
> Mounting ro,degraded, I see this:
>
> [94197.902443] BTRFS info (device sdc): allowing degraded mounts
> [94197.902448] BTRFS info (device sdc): disk space caching is enabled
> [94198.240621] BTRFS: bdev (null) errs: wr 1724, rd 305, flush 45,
> corrupt 0, gen 2
>
> Mounting rw,degraded, I see this:
>
> [94312.091613] BTRFS info (device sdc): allowing degraded mounts
> [94312.091618] BTRFS info (device sdc): disk space caching is enabled
> [94312.194513] BTRFS: bdev (null) errs: wr 1724, rd 305, flush 45,
> corrupt 0, gen 2
> [94319.824563] BTRFS: checking UUID tree

I don't see any mount failure message. It worked then?


-- 
Chris Murphy

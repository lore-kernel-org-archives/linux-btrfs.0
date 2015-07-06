Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:36591 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbbGFVt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2015 17:49:57 -0400
Received: by obdbs4 with SMTP id bs4so116452754obd.3
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jul 2015 14:49:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <559AEF3D.2070408@friedels.name>
References: <559AD4E5.2030107@friedels.name> <559ADAB5.3050804@friedels.name>
 <20150706194932.GE10539@carfax.org.uk> <CAC=t97D7p96+x_QQyAwa7c_2-TN0LvrBQ0TX_6B-2-b882JMWQ@mail.gmail.com>
 <559AEAAB.4070401@fb.com> <559AEF3D.2070408@friedels.name>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Mon, 6 Jul 2015 16:49:37 -0500
Message-ID: <CAC=t97DzzVz2HbWZtd_y4O5eNCDftJCeO-xn_bLWnByShz1oqw@mail.gmail.com>
Subject: Re: size 2.73TiB used 240.97GiB after balance
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Omar Sandoval <osandov@fb.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you can mount it RO, first thing to do is back up any data that you
care about.

According to the bug that Omar posted you should not try a device
replace and you should not try a scrub with a missing device.

You may be able to just do a device delete missing, then separately do
a device add of a new drive, or rebalance back in to raid1.

On Mon, Jul 6, 2015 at 4:12 PM, Hendrik Friedel <hendrik@friedels.name> wrote:
> Hello,
>
> oh dear, I fear I am in trouble:
> recovery-mounted, I tried to save some data, but the system hung.
> So I re-booted and sdc is now physically disconnected.
>
> Label: none  uuid: b4a6cce6-dc9c-4a13-80a4-ed6bc5b40bb8
>         Total devices 3 FS bytes used 4.67TiB
>         devid    1 size 2.73TiB used 2.67TiB path /dev/sdc
>         devid    2 size 2.73TiB used 2.67TiB path /dev/sdb
>         *** Some devices missing
>
> I try to mount the rest again:
> mount -o recovery,ro /dev/sdb /mnt/__Complete_Disk
> mount: wrong fs type, bad option, bad superblock on /dev/sdb,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
>
> root@homeserver:~# dmesg | tail
> [  447.059275] BTRFS info (device sdc): enabling auto recovery
> [  447.059280] BTRFS info (device sdc): disk space caching is enabled
> [  447.086844] BTRFS: failed to read chunk tree on sdc
> [  447.110588] BTRFS: open_ctree failed
> [  474.496778] BTRFS info (device sdc): enabling auto recovery
> [  474.496781] BTRFS info (device sdc): disk space caching is enabled
> [  474.519005] BTRFS: failed to read chunk tree on sdc
> [  474.540627] BTRFS: open_ctree failed
>
>
> mount -o degraded,ro /dev/sdb /mnt/__Complete_Disk
> Does work now though.
>
> So, how can I remove the reference to the failed disk and check the data for
> consistency (scrub I suppose, but is it safe?)?
>
> Regards,
> Hendrik
>
>
>
>
> On 06.07.2015 22:52, Omar Sandoval wrote:
>>
>> On 07/06/2015 01:01 PM, Donald Pearson wrote:
>>>
>>> Based on my experience Hugo's advice is critical, get the bad drive
>>> out of the pool when in raid56 and do not try to replace or delete it
>>> while it's still attached and recognized.
>>>
>>> If you add a new device, mount degraded and rebalance.  If you don't,
>>> mount degraded then device delete missing.
>>>
>>
>> Watch out, replacing a missing device in RAID 5/6 currently doesn't work
>> and will cause a kernel BUG(). See my patch series here:
>> http://www.spinics.net/lists/linux-btrfs/msg44874.html
>>
>
>
> --
> Hendrik Friedel
> Auf dem Brink 12
> 28844 Weyhe
> Tel. 04203 8394854
> Mobil 0178 1874363
>
>
> ---
> Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
> https://www.avast.com/antivirus
>

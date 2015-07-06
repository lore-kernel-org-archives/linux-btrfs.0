Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:55221 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbbGFVMq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2015 17:12:46 -0400
Message-ID: <559AEF3D.2070408@friedels.name>
Date: Mon, 06 Jul 2015 23:12:29 +0200
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Omar Sandoval <osandov@fb.com>, Donald Pearson <donaldwhpearson@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: size 2.73TiB used 240.97GiB after balance
References: <559AD4E5.2030107@friedels.name> <559ADAB5.3050804@friedels.name> <20150706194932.GE10539@carfax.org.uk> <CAC=t97D7p96+x_QQyAwa7c_2-TN0LvrBQ0TX_6B-2-b882JMWQ@mail.gmail.com> <559AEAAB.4070401@fb.com>
In-Reply-To: <559AEAAB.4070401@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

oh dear, I fear I am in trouble:
recovery-mounted, I tried to save some data, but the system hung.
So I re-booted and sdc is now physically disconnected.

Label: none  uuid: b4a6cce6-dc9c-4a13-80a4-ed6bc5b40bb8
         Total devices 3 FS bytes used 4.67TiB
         devid    1 size 2.73TiB used 2.67TiB path /dev/sdc
         devid    2 size 2.73TiB used 2.67TiB path /dev/sdb
         *** Some devices missing

I try to mount the rest again:
mount -o recovery,ro /dev/sdb /mnt/__Complete_Disk
mount: wrong fs type, bad option, bad superblock on /dev/sdb,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so

root@homeserver:~# dmesg | tail 

[  447.059275] BTRFS info (device sdc): enabling auto recovery
[  447.059280] BTRFS info (device sdc): disk space caching is enabled
[  447.086844] BTRFS: failed to read chunk tree on sdc
[  447.110588] BTRFS: open_ctree failed
[  474.496778] BTRFS info (device sdc): enabling auto recovery
[  474.496781] BTRFS info (device sdc): disk space caching is enabled
[  474.519005] BTRFS: failed to read chunk tree on sdc
[  474.540627] BTRFS: open_ctree failed


mount -o degraded,ro /dev/sdb /mnt/__Complete_Disk
Does work now though.

So, how can I remove the reference to the failed disk and check the data 
for consistency (scrub I suppose, but is it safe?)?

Regards,
Hendrik



On 06.07.2015 22:52, Omar Sandoval wrote:
> On 07/06/2015 01:01 PM, Donald Pearson wrote:
>> Based on my experience Hugo's advice is critical, get the bad drive
>> out of the pool when in raid56 and do not try to replace or delete it
>> while it's still attached and recognized.
>>
>> If you add a new device, mount degraded and rebalance.  If you don't,
>> mount degraded then device delete missing.
>>
>
> Watch out, replacing a missing device in RAID 5/6 currently doesn't work
> and will cause a kernel BUG(). See my patch series here:
> http://www.spinics.net/lists/linux-btrfs/msg44874.html
>


-- 
Hendrik Friedel
Auf dem Brink 12
28844 Weyhe
Tel. 04203 8394854
Mobil 0178 1874363

---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus


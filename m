Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:53421 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbbGHS4Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 14:56:25 -0400
Message-ID: <559D7245.9030204@friedels.name>
Date: Wed, 08 Jul 2015 20:56:05 +0200
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Donald Pearson <donaldwhpearson@gmail.com>
CC: Omar Sandoval <osandov@fb.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: size 2.73TiB used 240.97GiB after balance
References: <000f4242.05e425492a977c7b@friedels.name> <CAC=t97AcztZ9vKvMe8o70F3VsGR-_9TdFO4t=Rdt8q=9hDYm8A@mail.gmail.com> <559B66C9.6060606@friedels.name> <CAC=t97Cm8nAhwfS3vYc802Xi2tmGuvzRzOfXzSkUgaF5y0zQWQ@mail.gmail.com>
In-Reply-To: <CAC=t97Cm8nAhwfS3vYc802Xi2tmGuvzRzOfXzSkUgaF5y0zQWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

yes, I will check the cables, thanks for the hint.
Before trying to recover the data, I would like to save the status quo. 
I have two new drives? Is it advisable to dd-copy the data on the new 
drives and then to try to recover?

I am asking, because I suppose that dd will also copy the UUID, which 
might confuse BTRFS (two drives with same UUID attached)?

And then I have a technical question on btrfs balance when converting to 
raid5 (from raid1): does the balance create the parity information on 
the newly-added (empty) drive, so that the data on the two original 
disks is not touched at all?

Regards,
Hendrik


On 07.07.2015 15:14, Donald Pearson wrote:
> That's what it looks like.  You may want to try reseating cables, etc.
>
> Instead of mounting and file copy, btrfs restore might be worth a shot
> to recover what you can.
>
> On Tue, Jul 7, 2015 at 12:42 AM, Hendrik Friedel <hendrik@friedels.name> wrote:
>> Hello,
>>
>> while mounting works with the recovery option, the system locks after
>> reading.
>> dmesg shows:
>> [  684.258246] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>> [  684.258249] ata6.00: irq_stat 0x40000001
>> [  684.258252] ata6.00: failed command: DATA SET MANAGEMENT
>> [  684.258255] ata6.00: cmd 06/01:01:00:00:00/00:00:00:00:00/a0 tag 26 dma
>> 512 out
>> [  684.258255]          res 51/04:01:01:00:00/00:00:00:00:00/a0 Emask 0x1
>> (device error)
>> [  684.258256] ata6.00: status: { DRDY ERR }
>> [  684.258258] ata6.00: error: { ABRT }
>> [  684.258266] sd 5:0:0:0: [sdd] tag#26 FAILED Result: hostbyte=DID_OK
>> driverbyte=DRIVER_SENSE
>> [  684.258268] sd 5:0:0:0: [sdd] tag#26 Sense Key : Illegal Request
>> [current] [descriptor]
>> [  684.258270] sd 5:0:0:0: [sdd] tag#26 Add. Sense: Unaligned write command
>> [  684.258272] sd 5:0:0:0: [sdd] tag#26 CDB: Write same(16) 93 08 00 00 00
>> 00 00 01 d3 80 00 00 00 80 00 00
>>
>>
>> So, also this drive is failing?!
>>
>> Regards,
>> Hendrik
>>
>>
>> On 07.07.2015 00:59, Donald Pearson wrote:
>>>
>>> Anything in dmesg?
>>>
>>> On Mon, Jul 6, 2015 at 5:07 PM, hendrik@friedels.name
>>> <hendrik@friedels.name> wrote:
>>>>
>>>> Hallo,
>>>>
>>>> It seems, that mounting works, but the System locks completely soon after
>>>> I
>>>> backing up.
>>>>
>>>>
>>>> Greetings,
>>>>
>>>> Hendrik
>>>>
>>>>
>>>> ------ Originalnachricht------
>>>>
>>>> Von: Donald Pearson
>>>>
>>>> Datum: Mo., 6. Juli 2015 23:49
>>>>
>>>> An: Hendrik Friedel;
>>>>
>>>> Cc: Omar Sandoval;Hugo Mills;Btrfs BTRFS;
>>>>
>>>> Betreff:Re: size 2.73TiB used 240.97GiB after balance
>>>>
>>>>
>>>> If you can mount it RO, first thing to do is back up any data that
>>>> youcare
>>>> about.According to the bug that Omar posted you should not try a
>>>> devicereplace and you should not try a scrub with a missing device.You
>>>> may
>>>> be able to just do a device delete missing, then separately doa device
>>>> add
>>>> of a new drive, or rebalance back in to raid1.On Mon, Jul 6, 2015 at 4:12
>>>> PM, Hendrik Friedel  wrote:> Hello,>> oh dear, I fear I am in trouble:>
>>>> recovery-mounted, I tried to save some data, but the system hung.> So I
>>>> re-booted and sdc is now physically disconnected.>> Label: none  uuid:
>>>> b4a6cce6-dc9c-4a13-80a4-ed6bc5b40bb8>         Total devices 3 FS bytes
>>>> used
>>>> 4.67TiB>         devid    1 size 2.73TiB used 2.67TiB path /dev/sdc>
>>>> devid    2 size 2.73TiB used 2.67TiB path /dev/sdb>         *** Some
>>>> devices
>>>> missing>> I try to mount the rest again:> mount -o recovery,ro /dev/sdb
>>>> /mnt/__Complete_Disk> mount: wrong fs type, bad option, bad superblock on
>>>> /dev/sdb,>        missing codepage or helper program, or other error>
>>>> In some cases useful info is found in syslog - try>        dmesg | tail
>>>> or
>>>> so>> root@homeserver:~# dmesg | tail> [  447.059275] BTRFS info (device
>>>> sdc): enabling auto recovery> [  447.059280] BTRFS info (device sdc):
>>>> disk
>>>> space caching is enabled> [  447.086844] BTRFS: failed to read chunk tree
>>>> on
>>>> sdc> [  447.110588] BTRFS: open_ctree failed> [  474.496778] BTRFS info
>>>> (device sdc): enabling auto recovery> [  474.496781] BTRFS info (device
>>>> sdc): disk space caching is enabled> [  474.519005] BTRFS: failed to read
>>>> chunk tree on sdc> [  474.540627] BTRFS: open_ctree failed>>> mount -o
>>>> degraded,ro /dev/sdb /mnt/__Complete_Disk> Does work now though.>> So,
>>>> how
>>>> can I remove the reference to the failed disk and check the data for>
>>>> consistency (scrub I suppose, but is it safe?)?>> Regards,> Hendrik>>>>>
>>>> On
>>>> 06.07.2015 22:52, Omar Sandoval wrote:>>>> On 07/06/2015 01:01 PM, Donald
>>>> Pearson wrote:>>>>>> Based on my experience Hugo's advice is critical,
>>>> get
>>>> the bad drive>>> out of the pool when in raid56 and do not try to replace
>>>> or
>>>> delete it>>> while it's still attached and recognized.>>>>>> If you add a
>>>> new device, mount degraded and rebalance.  If you don't,>>> mount
>>>> degraded
>>>> then device delete missing.>>>>>>> Watch out, replacing a missing device
>>>> in
>>>> RAID 5/6 currently doesn't work>> and will cause a kernel BUG(). See my
>>>> patch series here:>>
>>>> http://www.spinics.net/lists/linux-btrfs/msg44874.html>>>>> --> Hendrik
>>>> Friedel> Auf dem Brink 12> 28844 Weyhe> Tel. 04203 8394854> Mobil 0178
>>>> 1874363>>> ---> Diese E-Mail wurde von Avast Antivirus-Software auf Viren
>>>> geprüft.> https://www.avast.com/antivirus>
>>
>>
>>
>> --
>> Hendrik Friedel
>> Auf dem Brink 12
>> 28844 Weyhe
>> Tel. 04203 8394854
>> Mobil 0178 1874363
>>
>> ---
>> Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
>> https://www.avast.com/antivirus
>>


-- 
Hendrik Friedel
Auf dem Brink 12
28844 Weyhe
Tel. 04203 8394854
Mobil 0178 1874363

---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus


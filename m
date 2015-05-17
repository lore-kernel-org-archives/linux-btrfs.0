Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f66.google.com ([74.125.82.66]:33201 "EHLO
	mail-wg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbbEQBxX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 May 2015 21:53:23 -0400
Received: by wggy19 with SMTP id y19so12253246wgg.0
        for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2015 18:53:22 -0700 (PDT)
Received: from [10.0.2.15] (p4FCB5052.dip0.t-ipconnect.de. [79.203.80.82])
        by mx.google.com with ESMTPSA id g8sm9768333wjn.18.2015.05.16.18.53.20
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 May 2015 18:53:21 -0700 (PDT)
From: Philip Seeger <p0h0i0l0i0p@gmail.com>
Message-ID: <5557F490.5000606@googlemail.com>
Date: Sun, 17 May 2015 03:53:20 +0200
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Got 10 csum errors according to dmesg but 0 errors according to dev
 stats
References: <554F6D43.2060806@googlemail.com> <554F7232.9080804@googlemail.com>
In-Reply-To: <554F7232.9080804@googlemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I deleted and restored the corrupted files again. One of those files 
(not a new one) got corrupted again.

I think I forgot to mention that this btrfs filesystem was converted 
from ext4 (not initially created as btrfs).
Could this cause this corruption?

Also, does this df output look weird to anyone, shouldn't metadata be 
duplicated?
# btrfs fi df /
Data, single: total=21.00GiB, used=20.82GiB
System, single: total=32.00MiB, used=4.00KiB
Metadata, single: total=1.25GiB, used=901.21MiB
GlobalReserve, single: total=304.00MiB, used=0.00B


Philip

On 05/10/2015 04:58 PM, Philip Seeger wrote:
> Forgot to mention kernel version: Linux 4.0.1-1-ARCH
>
> $ sudo btrfs fi show
> Label: none  uuid: 3e8973d3-83ce-4d93-8d50-2989c0be256a
>     Total devices 1 FS bytes used 19.87GiB
>     devid    1 size 45.00GiB used 21.03GiB path /dev/sda1
>
> btrfs-progs v3.19.1
>
>
>
> On 05/10/2015 04:37 PM, Philip Seeger wrote:
>> I have installed a new virtual machine (VirtualBox) with Arch on btrfs
>> (just a root fs and swap partition, no other partitions).
>> I suddenly noticed 10 checksum errors in the kernel log:
>> $ dmesg | grep csum
>> [  736.283506] BTRFS warning (device sda1): csum failed ino 1704363 off
>> 761856 csum 1145980813 expected csum 2566472073
>> [  736.283605] BTRFS warning (device sda1): csum failed ino 1704363 off
>> 1146880 csum 1961240434 expected csum 2566472073
>> [  745.583064] BTRFS warning (device sda1): csum failed ino 1704346 off
>> 393216 csum 4035064017 expected csum 2566472073
>> [  752.324899] BTRFS warning (device sda1): csum failed ino 1705927 off
>> 2125824 csum 3638986839 expected csum 2566472073
>> [  752.333115] BTRFS warning (device sda1): csum failed ino 1705927 off
>> 2588672 csum 176788087 expected csum 2566472073
>> [  752.333303] BTRFS warning (device sda1): csum failed ino 1705927 off
>> 3276800 csum 1891435134 expected csum 2566472073
>> [  752.333397] BTRFS warning (device sda1): csum failed ino 1705927 off
>> 3964928 csum 3304112727 expected csum 2566472073
>> [ 2761.889460] BTRFS warning (device sda1): csum failed ino 1705927 off
>> 2125824 csum 3638986839 expected csum 2566472073
>> [ 9054.226022] BTRFS warning (device sda1): csum failed ino 1704363 off
>> 761856 csum 1145980813 expected csum 2566472073
>> [ 9054.226106] BTRFS warning (device sda1): csum failed ino 1704363 off
>> 1146880 csum 1961240434 expected csum 2566472073
>>
>> This is a new vm, it hasn't crashed (which might have caused filesystem
>> corruption). The virtual disk is on a RAID storage on the host, which is
>> healthy. All corrupted files are Firefox data files:
>> $ dmesg | grep csum | grep -Eo 'csum failed ino [0-9]* ' | awk '{print
>> $4}' | xargs -I{} find -inum {}
>> ./.mozilla/firefox/nfh217zw.default/cookies.sqlite
>> ./.mozilla/firefox/nfh217zw.default/cookies.sqlite
>> ./.mozilla/firefox/nfh217zw.default/webappsstore.sqlite
>> ./.mozilla/firefox/nfh217zw.default/places.sqlite
>> ./.mozilla/firefox/nfh217zw.default/places.sqlite
>> ./.mozilla/firefox/nfh217zw.default/places.sqlite
>> ./.mozilla/firefox/nfh217zw.default/places.sqlite
>> ./.mozilla/firefox/nfh217zw.default/places.sqlite
>> ./.mozilla/firefox/nfh217zw.default/cookies.sqlite
>> ./.mozilla/firefox/nfh217zw.default/cookies.sqlite
>>
>> How could this possibly happen?
>>
>> And more importantly: Why doesn't the btrfs stat(u)s output tell me that
>> errors have occurred?
>> $ sudo btrfs dev stats /
>> [/dev/sda1].write_io_errs   0
>> [/dev/sda1].read_io_errs    0
>> [/dev/sda1].flush_io_errs   0
>> [/dev/sda1].corruption_errs 0
>> [/dev/sda1].generation_errs 0
>>
>> If the filesystem health was monitored using btrfs dev stats (cronjob)
>> (like checking a zpool using zpool status), the admin would not have
>> been notified:
>> $ sudo btrfs dev stats / | grep -v 0 -c
>> 0
>>
>> Is my understanding of the stats command wrong, does "corruption_errs"
>> not mean corruption errors?
>>
>>
>>
>


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:32794 "EHLO mout2.freenet.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753915AbdHWNSC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 09:18:02 -0400
Date: Wed, 23 Aug 2017 15:12:45 +0200
From: g6094199@freenet.de
Subject: Re: degraded BTRFS RAID 1 not mountable: open_ctree failed, unable to find block group for 0
To: Dmitrii Tcvetkov <demfloro@demfloro.ru>
Cc: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Message-Id: <500286930a95a0600dec24257c9d793b@email.freenet.de>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Ursprüngliche Nachricht-----
> Von: Dmitrii Tcvetkov 
> Gesendet: Di. 22.08.2017 12:28
> An: g6094199@freenet.de
> Kopie: linux-btrfs@vger.kernel.org
> Betreff: Re: degraded BTRFS RAID 1 not mountable: open_ctree failed, unable to find block group for 0
>
> On Tue, 22 Aug 2017 11:31:23 +0200
> g6094199@freenet.de wrote:
>> So 1st should be investigating why did the disk not get removed
>> correctly? Btrfs dev del should remove the device corretly, right? Is
>> there a bug?
>
> It should and probably did. To check that we need to see output of 
> btrfs filesystem show 
> and output of 
> btrfs filesystem usage

He Dimitry!

THX fror your suggestions.

root@vHost1:~# btrfs fi show /
Label: 'System'  uuid: 35fdbfd4-5809-4a30-94c1-5e3ca206ca4d
    Total devices 2 FS bytes used 17.00GiB
    devid    6 size 50.00GiB used 22.03GiB path /dev/nvme0n1p1
    devid    7 size 48.83GiB used 22.03GiB path /dev/sda1

root@vHost1:~# btrfs fi df /
Data, RAID1: total=19.00GiB, used=15.68GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=3.00GiB, used=1.32GiB
GlobalReserve, single: total=384.00MiB, used=0.00B

root@vHost1:/var/log#  btrfs filesystem usag /
Overall:
    Device size:          98.83GiB
    Device allocated:          44.06GiB
    Device unallocated:          54.76GiB
    Device missing:             0.00B
    Used:              34.11GiB
    Free (estimated):          30.68GiB    (min: 30.68GiB)
    Data ratio:                  2.00
    Metadata ratio:              2.00
    Global reserve:         384.00MiB    (used: 0.00B)

Data,RAID1: Size:19.00GiB, Used:15.70GiB
   /dev/nvme0n1p1      19.00GiB
   /dev/sda1      19.00GiB

Metadata,RAID1: Size:3.00GiB, Used:1.36GiB
   /dev/nvme0n1p1       3.00GiB
   /dev/sda1       3.00GiB

System,RAID1: Size:32.00MiB, Used:16.00KiB
   /dev/nvme0n1p1      32.00MiB
   /dev/sda1      32.00MiB

Unallocated:
   /dev/nvme0n1p1      27.97GiB
   /dev/sda1      26.80GiB

 
> If there are non-raid1 chunks then you need to do soft balance:
> btrfs balance start -mconvert=raid1,soft -dconvert=raid1,soft

Yes of cause i did a balance after replacing the disk (see above). I'm aware of the problems occuring with single chunks, etc. I did again a soft balance as you have suggested, which finished within seconds.
 
> The balance should finish very quickly as you probably have only one of
> data and metadata single chunks. They appeared during writes when the
> filesystem was mounted read-write in degraded mode.

I guess the typical erros are now sorted out. i will reboot the machine with a currect hwe kernel and send the logs. Anything else i can do?

regards
sash



MIT TRAVELXTRA PROFITIEREN SIE VON 5% RÜCKVERGÜTUNG AUF DEN
REISEPREIS ? bekannte dt. Reiseanbieter und ein umfangreiches
Reiseangebot wie im Reisebüro!
https://email.freenet.de/reisen/index.html
[https://email.freenet.de/reisen/index.html?utm_medium=Text&utm_source=Footersatz&utm_campaign=Footersatz_Reisen07082017&epid=e9900000699&utm_content=Text]


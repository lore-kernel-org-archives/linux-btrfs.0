Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:10311 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751212AbdHPJ0j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 05:26:39 -0400
Subject: Re: slow btrfs with a single kworker process using 100% CPU
To: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
Cc: Marat Khalili <mkh@rqc.ru>, linux-btrfs@vger.kernel.org
References: <eab2f725-ab6e-d2ac-30e1-d9c964ce8be8@profihost.ag>
 <4772c3f2-0074-d86f-24c4-02ff0730fce7@rqc.ru>
 <064eaaed-7748-7064-874e-19d270d0854e@profihost.ag>
 <4669553.344.1502874134710.JavaMail.gkos@dynomob>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <f6f3998b-3ca7-7344-a577-6b02a5b11359@profihost.ag>
Date: Wed, 16 Aug 2017 11:26:38 +0200
MIME-Version: 1.0
In-Reply-To: <4669553.344.1502874134710.JavaMail.gkos@dynomob>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 16.08.2017 um 11:02 schrieb Konstantin V. Gavrilenko:
> Could be similar issue as what I had recently, with the RAID5 and 256kb chunk size.
> please provide more information about your RAID setup.

Hope this helps:

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4] [linear] [multipath]
[raid0] [raid10]
md0 : active raid5 sdd1[1] sdf1[4] sdc1[0] sde1[2]
      11717406720 blocks super 1.2 level 5, 512k chunk, algorithm 2
[4/4] [UUUU]
      bitmap: 6/30 pages [24KB], 65536KB chunk

md2 : active raid5 sdm1[2] sdl1[1] sdk1[0] sdn1[4]
      11717406720 blocks super 1.2 level 5, 512k chunk, algorithm 2
[4/4] [UUUU]
      bitmap: 7/30 pages [28KB], 65536KB chunk

md1 : active raid5 sdi1[2] sdg1[0] sdj1[4] sdh1[1]
      11717406720 blocks super 1.2 level 5, 512k chunk, algorithm 2
[4/4] [UUUU]
      bitmap: 7/30 pages [28KB], 65536KB chunk

md3 : active raid5 sdp1[1] sdo1[0] sdq1[2] sdr1[4]
      11717406720 blocks super 1.2 level 5, 512k chunk, algorithm 2
[4/4] [UUUU]
      bitmap: 6/30 pages [24KB], 65536KB chunk

# btrfs fi usage /vmbackup/
Overall:
    Device size:                  43.65TiB
    Device allocated:             31.98TiB
    Device unallocated:           11.67TiB
    Device missing:                  0.00B
    Used:                         30.80TiB
    Free (estimated):             12.84TiB      (min: 12.84TiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID0: Size:31.83TiB, Used:30.66TiB
   /dev/md0        7.96TiB
   /dev/md1        7.96TiB
   /dev/md2        7.96TiB
   /dev/md3        7.96TiB

Metadata,RAID0: Size:153.00GiB, Used:141.34GiB
   /dev/md0       38.25GiB
   /dev/md1       38.25GiB
   /dev/md2       38.25GiB
   /dev/md3       38.25GiB

System,RAID0: Size:128.00MiB, Used:2.28MiB
   /dev/md0       32.00MiB
   /dev/md1       32.00MiB
   /dev/md2       32.00MiB
   /dev/md3       32.00MiB

Unallocated:
   /dev/md0        2.92TiB
   /dev/md1        2.92TiB
   /dev/md2        2.92TiB
   /dev/md3        2.92TiB


Stefan

> 
> p.s.
> you can also check the tread "Btrfs + compression = slow performance and high cpu usage"
> 
> ----- Original Message -----
> From: "Stefan Priebe - Profihost AG" <s.priebe@profihost.ag>
> To: "Marat Khalili" <mkh@rqc.ru>, linux-btrfs@vger.kernel.org
> Sent: Wednesday, 16 August, 2017 10:37:43 AM
> Subject: Re: slow btrfs with a single kworker process using 100% CPU
> 
> Am 16.08.2017 um 08:53 schrieb Marat Khalili:
>>> I've one system where a single kworker process is using 100% CPU
>>> sometimes a second process comes up with 100% CPU [btrfs-transacti]. Is
>>> there anything i can do to get the old speed again or find the culprit?
>>
>> 1. Do you use quotas (qgroups)?
> 
> No qgroups and no quota.
> 
>> 2. Do you have a lot of snapshots? Have you deleted some recently?
> 
> 1413 Snapshots. I'm deleting 50 of them every night. But btrfs-cleaner
> process isn't running / consuming CPU currently.
> 
>> More info about your system would help too.
> Kernel is OpenSuSE Leap 42.3.
> 
> btrfs is mounted with
> compress-force=zlib
> 
> btrfs is running as a raid0 on top of 4 md raid 5 devices.
> 
> Greets,
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

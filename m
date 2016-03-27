Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:33352 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbcC0J4z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 05:56:55 -0400
Received: by mail-lb0-f173.google.com with SMTP id y6so13440521lbj.0
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Mar 2016 02:56:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADzmB21y=2bpD6OyRgjCA5vxL3tu9yQ76a08MTQWWG5uXsoLoA@mail.gmail.com>
References: <CADzmB20WugZAaeOOBVKq6L+AuPr3Epr4WFG+LoQROaKj11r0Qg@mail.gmail.com>
 <CADzmB21y=2bpD6OyRgjCA5vxL3tu9yQ76a08MTQWWG5uXsoLoA@mail.gmail.com>
From: Ivan P <chrnosphered@gmail.com>
Date: Sun, 27 Mar 2016 11:56:34 +0200
Message-ID: <CADzmB21McM4FecUb58+TGb+HRiqJ0bPWsDObv9GZsVzjK_qJ1Q@mail.gmail.com>
Subject: Re: scrub: Tree block spanning stripes, ignored
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

..forgot to paste btrfs-version: 4.4.1
(slightly outdated, but it's the current version on arch linux)

On Sun, Mar 27, 2016 at 11:54 AM, Ivan P <chrnosphered@gmail.com> wrote:
> Read the info on the wiki, here's the rest of the requested information:
>
> # uname -r
> 4.4.5-1-ARCH
>
> # btrfs fi show
> Label: 'ArchVault'  uuid: cd8a92b6-c5b5-4b19-b5e6-a839828d12d8
>        Total devices 1 FS bytes used 2.10GiB
>        devid    1 size 14.92GiB used 4.02GiB path /dev/sdc1
>
> Label: 'Vault'  uuid: 013cda95-8aab-4cb2-acdd-2f0f78036e02
>        Total devices 2 FS bytes used 800.72GiB
>        devid    1 size 931.51GiB used 808.01GiB path /dev/sda
>        devid    2 size 931.51GiB used 808.01GiB path /dev/sdb
>
> # btrfs fi df /mnt/vault/
> Data, RAID1: total=806.00GiB, used=799.81GiB
> System, RAID1: total=8.00MiB, used=128.00KiB
> Metadata, RAID1: total=2.00GiB, used=936.20MiB
> GlobalReserve, single: total=320.00MiB, used=0.00B
>
> On Fri, Mar 25, 2016 at 3:16 PM, Ivan P <chrnosphered@gmail.com> wrote:
>> Hello,
>>
>> using kernel  4.4.5 and btrfs-progs 4.4.1, I today ran a scrub on my
>> 2x1Tb btrfs raid1 array and it finished with 36 unrecoverable errors
>> [1], all blaming the treeblock 741942071296. Running "btrfs check
>> --readonly" on one of the devices lists that extent as corrupted [2].
>>
>> How can I recover, how much did I really lose, and how can I prevent
>> it from happening again?
>> If you need me to provide more info, do tell.
>>
>> [1] http://cwillu.com:8080/188.110.141.36/1
>> [2] http://pastebin.com/xA5zezqw
>>
>> Regards,
>> Soukyuu
>>
>> P.S.: please add me to CC when replying as I did not subscribe to the
>> mailing list. Majordomo won't let me use my hotmail address and I
>> don't want that much traffic on this address.
